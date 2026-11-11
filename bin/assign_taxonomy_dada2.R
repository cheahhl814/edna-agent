#!/usr/bin/env Rscript

# Naive-Bayes taxonomic assignment — dada2 assignTaxonomy (Wang k-mer classifier).
# Third SP5 classification option in edna-agent (v1.3.3), closing the last
# course-named annotation route (TBCG2026 manual Part D: BLAST / VSEARCH /
# trained Naive Bayes). Per-rank bootstrap confidences on a percent scale.
#
# Input contract: identical to the consensus-BLAST path — a labelled reference
# (FASTA + taxonomy TSV, RDP rank-coded lineages or per-rank columns) and a
# query FASTA (rep_seqs_clean.fna — ;size= annotations already stripped).
# Output contract: identical to bin/idtaxa_rds.R / bin/consensus_blast_taxonomy.R
# (SequenceID + seven lowercase rank columns; confidence TSV percent-scale), so
# filter_idtaxa_by_confidence.jl + agglomerate_data.R consume it unchanged.
#
# Reference-length caveat (F10 lesson family): assignTaxonomy performs best when
# training sequences resemble the amplicon length; run the recipe's optional
# in-silico primer-span trim on the reference FASTA first for short amplicons
# (the default recipe keeps full-gene refs and records the caveat instead).
#
# Requires: argparse, data.table, dada2 (all present in env/denoise).

suppressPackageStartupMessages({
    library(argparse)
    library(data.table)
    library(dada2)
})

RANK_CODES <- c(k = "superkingdom", d = "superkingdom",
                p = "phylum", c = "class", o = "order",
                f = "family", g = "genus", s = "species")
RANK_ORDER <- unique(unname(RANK_CODES))  # k__ and d__ both map to superkingdom — dedup or the
# positional level-name vector carries the duplicate and seq_len() then drops species

parser <- ArgumentParser(description = 'Naive-Bayes taxonomic assignment of ASVs via dada2::assignTaxonomy (Wang k-mer classifier).')
parser$add_argument('--query_seqs', type='character', required=TRUE,
                    help='Query FASTA (rep_seqs_clean.fna — headers must NOT carry ;size= annotations).')
parser$add_argument('--reference_fasta', type='character', required=TRUE,
                    help='Labelled reference FASTA (ids matching reference_taxonomy).')
parser$add_argument('--reference_taxonomy', type='character', required=TRUE,
                    help='Reference taxonomy TSV: either [ID, lineage] with RDP rank codes (k__/d__)..;p__..;) or ID + one column per rank.')
parser$add_argument('--output_classification', type='character', required=TRUE,
                    help='Output classification TSV (SequenceID + rank columns).')
parser$add_argument('--output_confidence', type='character', required=TRUE,
                    help='Output confidence TSV (percent-scale bootstrap per rank).')
parser$add_argument('--min_boot', type='double', default=0,
                    help='assignTaxonomy minBoot; default 0 — the confidence threshold is applied DOWNSTREAM by filter_idtaxa_by_confidence.jl, keeping the comparison methods consistent.')
parser$add_argument('--try_rc', action='store_true', default=FALSE,
                    help='Also try reverse-complement assignment (slower; use when primer orientation may vary).')
parser$add_argument('--unassigned_label', type='character', default='NA',
                    help='Value written for ranks below the minBoot threshold.')
parser$add_argument('--max_records', type='integer', default=0,
                    help='Stratified subsample of the training set (evenly spaced over the file) — 0 = all. the assignTaxonomy k-mer table is memory-hungry: 41,868 Mitohelper refs OOM a 14 GB host; 16,329 also OOMed in the 2026-11-11 test; 1,000 worked. For hosts with ~3 GB free use ~3-5k.')
parser$add_argument('--cpu', type='integer', default=0,
                    help='>0 = multithread TRUE (fork), 0 = single-core (RAM-constrained hosts).')

args <- parser$parse_args()
MT <- args$cpu > 0

# --- Load reference taxonomy -------------------------------------------------
ref_tax <- fread(args$reference_taxonomy, sep = "\t", header = TRUE, data.table = FALSE, check.names = FALSE)
if (ncol(ref_tax) < 2) stop("reference_taxonomy needs >= 2 columns (ID + lineage, or ID + rank columns).")
names(ref_tax)[1] <- "ref_id"

if (sum(grepl(";", as.character(ref_tax[[2]]))) > 0) {
    ref_tax$lineage <- as.character(ref_tax[[2]])
} else {
    code_for <- c(superkingdom = "k__", phylum = "p__", `class` = "c__", order = "o__",
                  family = "f__", genus = "g__", species = "s__")
    rank_cols <- vapply(RANK_ORDER, function(rk) which(tolower(names(ref_tax)) == rk)[1], 0L)
    rank_cols <- rank_cols[rank_cols > 0]
    if (length(rank_cols) == 0) stop("reference_taxonomy columns are neither rank-coded lineages nor rank names.")
    get_lin <- function(i) {
        parts <- vapply(names(rank_cols), function(rk) {
            v <- trimws(as.character(ref_tax[i, rank_cols[[rk]]]))
            if (v != "" && !grepl("^unassigned$", v, ignore.case = TRUE)) paste0(code_for[[rk]], v) else ""
        }, "")
        paste(parts[parts != ""], collapse = ";")
    }
    ref_tax$lineage <- vapply(seq_len(nrow(ref_tax)), get_lin, "")
}

tax_lookup <- setNames(as.character(ref_tax$lineage), as.character(ref_tax$ref_id))
tax_lookup[is.na(tax_lookup)] <- ""

# --- Parse the reference FASTA (sequential, id + sequence pairing) -----------
lines <- readLines(args$reference_fasta, warn = FALSE)
lines <- lines[nzchar(lines)]
is_h  <- startsWith(lines, ">")
ids   <- sub("^>", "", lines[is_h])
ids   <- vapply(strsplit(ids, "\\s"), function(x) x[[1]], "")   # drop header extras after the id
grp   <- cumsum(is_h)
seqs  <- as.character(tapply(lines[!is_h], grp[!is_h], function(s) paste(s, collapse = "")))
ref_df <- data.frame(id = ids[unique(grp[!is_h])], seq = seqs, stringsAsFactors = FALSE)
if (nrow(ref_df) == 0) stop("reference_fasta is empty or unparsable.")

missing_tax <- setdiff(ref_df$id, names(tax_lookup))
if (length(missing_tax) > 0) {
    warning(paste(length(missing_tax), "reference FASTA ids lack a taxonomy entry — excluded from training."))
    ref_df <- ref_df[ref_df$id %in% names(tax_lookup), ]
}
ref_df$tax <- vapply(ref_df$id, function(x) gsub("^d__", "k__", tax_lookup[[x]]), "")
if (args$max_records > 0 && nrow(ref_df) > args$max_records) {
    idx <- round(seq(1, nrow(ref_df), length.out = args$max_records))
    ref_df <- ref_df[idx, ]
    message(paste("Subsampled training set (stratified) to", nrow(ref_df), "records (--max_records)"))
}
ref_df <- ref_df[nzchar(ref_df$tax), ]
if (nrow(ref_df) == 0) stop("No reference records carry a usable taxonomy lineage.")

# level count from the reference lineages -> name the output columns in RDP order
n_levels <- max(vapply(strsplit(ref_df$tax, ";"), function(x) sum(nzchar(x)), 0L))
if (min(vapply(strsplit(ref_df$tax, ";"), function(x) sum(nzchar(x)), 0L)) < n_levels) {
    warning("Non-uniform rank depth in reference lineages — shallower lineages truncate at their last rank.")
}
present_letters <- unique(unlist(lapply(strsplit(ref_df$tax, ";"), function(x) substr(x[nzchar(x)], 1, 1))))
# map letters to rank names and DEDUPLICATE (k__ and d__ both mean superkingdom);
# passing a duplicated level name shifts every later rank one column left and
# silently drops the deepest rank (species) from the output
present_ranks <- unique(unname(vapply(present_letters, function(l) {
    code <- RANK_CODES[[l]]
    if (is.null(code)) NA_character_ else code
}, "")))
present_ranks <- present_ranks[!is.na(present_ranks)]
tax_levels <- RANK_ORDER[RANK_ORDER %in% present_ranks]
tax_levels <- tax_levels[seq_len(min(n_levels, length(tax_levels)))]

# --- dada2-format training FASTA --------------------------------------------
train_file <- tempfile(fileext = ".fna")
con <- file(train_file, open = "wt")
# INTERLEAVE header/sequence per record — writing all headers first and all
# sequences after pairs every dada2-parsed record with the NEXT header line as
# its 'sequence', collapsing the whole reference set onto one degenerate record
for (i in seq_len(nrow(ref_df))) {
  writeLines(paste0(">", ref_df$id[i], " ", ref_df$tax[i]), con)
  writeLines(as.character(ref_df$seq[i]), con)
}
close(con)
message(paste("Built dada2 training FASTA:", nrow(ref_df), "references /", length(tax_levels), "levels:",
              paste(tax_levels, collapse = ",")))

# --- Assign -------------------------------------------------------------------
# DADA2 names assignment rows by the QUERY SEQUENCE, not the header id (verified
# 2026-11-11) — remap back to header ids so downstream rank tables stay in
# lockstep with the feature table (compare_classifications.R joins on ids).
qlines <- readLines(args$query_seqs, warn = FALSE)
qlines <- qlines[nzchar(qlines)]
q_is_h <- startsWith(qlines, ">")
q_ids <- sub("^>", "", qlines[q_is_h])
q_grp <- cumsum(q_is_h)
q_seqs <- as.character(tapply(qlines[!q_is_h], q_grp[!q_is_h], function(s) paste(s, collapse = "")))
q_ids <- q_ids[unique(q_grp[!q_is_h])]
seq_to_id <- setNames(q_ids, q_seqs)

remap_ids <- function(m) {
    ids <- rownames(m)
    if (ids[1] %in% q_ids) return(ids)   # already header ids
    mapped <- unname(seq_to_id[ids])
    if (any(is.na(mapped))) {
        warning(paste(sum(is.na(mapped)), "assigned rows could not be mapped back to query ids — kept as-is."))
        mapped[is.na(mapped)] <- ids[is.na(mapped)]
    }
    mapped
}

taxres <- assignTaxonomy(args$query_seqs, train_file, minBoot = args$min_boot,
                         tryRC = args$try_rc, outputBootstraps = TRUE,
                         taxLevels = tax_levels, multithread = MT, verbose = TRUE)
rownames(taxres$tax) <- remap_ids(taxres$tax)
rownames(taxres$boot) <- remap_ids(taxres$boot)

strip  <- function(x) {
  x <- sub("^.* ([A-Za-z])__", "\\1__", x)   # space-format headers glue the reference ID into rank1
  gsub("^[A-Za-z]__", "", x)
}
keepNA <- function(x) ifelse(x == "" | is.na(x), args$unassigned_label, x)

out_tax <- data.frame(SequenceID = rownames(taxres$tax),
                      as.data.frame(apply(taxres$tax, 2, strip), stringsAsFactors = FALSE),
                      check.names = FALSE)
for (rc in setdiff(names(out_tax), "SequenceID")) out_tax[[rc]] <- keepNA(out_tax[[rc]])
out_boot <- data.frame(SequenceID = rownames(taxres$boot),
                       as.data.frame(taxres$boot, stringsAsFactors = FALSE),
                       check.names = FALSE)
names(out_boot)[-1] <- names(out_tax)[-1]
for (rc in setdiff(names(out_boot), "SequenceID")) out_boot[[rc]] <- round(as.numeric(out_boot[[rc]]), 2)

fwrite(out_tax, file = args$output_classification, sep = "\t", quote = FALSE)
fwrite(out_boot, file = args$output_confidence, sep = "\t", quote = FALSE)

genus_assigned <- sum(out_tax$genus != args$unassigned_label, na.rm = TRUE)
message(paste("Naive-Bayes classification written:", genus_assigned, "/", nrow(out_tax),
              "ASVs assigned at genus level (minBoot =", args$min_boot, ")."))
message("dada2-nb classification complete.")
