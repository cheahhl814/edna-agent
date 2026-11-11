#!/usr/bin/env Rscript

# DADA2 denoising path for edna-agent — alternative DENOISE engine to the
# NGmerge + VSEARCH UNOISE3 default. Mirrors QIIME2 `qiime dada2 denoise-paired`:
#   filterAndTrim -> learnErrors -> dada (paired) -> mergePairs
#   -> makeSequenceTable -> removeBimeraDenovo(consensus)
# Produces the SAME downstream contract as the UNOISE3 chain:
#   --table_out: merged feature table whose first column is "ASV_ID"
#                (header style identical to bin/merge_tables.R output)
#   --fasta_out: representative-sequence FASTA with ";size=<total>" abundance
#                annotations in the headers (stripped downstream by the
#                existing `sed 's/;size=[0-9]*//'` in the classify recipes)
# ASV ids are ASV1..ASVn ordered by decreasing total abundance, so the feature
# table row ids and the FASTA header names always agree (no sequence-as-id).

suppressPackageStartupMessages({
  library(argparse)
  library(data.table)   # fwrite
  library(dada2)
})

parser <- ArgumentParser(description = "DADA2 denoising — alternative DENOISE engine to NGmerge+UNOISE3 (paired-end mirrors qiime dada2 denoise-paired; single-end mirrors qiime dada2 denoise-single)")
parser$add_argument("--mode", default = "auto", help = "paired|single|auto (auto: single when R2 trimmed FASTQs are absent)")
parser$add_argument("--trimmed_dir", required = TRUE,
  help = "QC stage output dir containing <sid>/<sid>_R1.trimmed.fastq.gz and <sid>_R2.trimmed.fastq.gz")
parser$add_argument("--samples", nargs = "+", default = NULL,
  help = "Explicit sample ids (directories under trimmed_dir); default: auto-discover")
parser$add_argument("--table_out", required = TRUE, help = "Output feature-table TSV")
parser$add_argument("--fasta_out", required = TRUE, help = "Output representative-sequence FASTA")
parser$add_argument("--stats_out", required = TRUE, help = "Output per-sample read-flow stats TSV")
parser$add_argument("--filtered_dir", required = TRUE, help = "Directory for filterAndTrim output FASTQs")
parser$add_argument("--trunc_len_f", type = "integer", default = 0,
  help = "truncLen forward read; 0 = no truncation (runs-through reads are fine for short amplicons)")
parser$add_argument("--trunc_len_r", type = "integer", default = 0, help = "truncLen reverse read; 0 = no truncation")
parser$add_argument("--max_ee_f", type = "numeric", default = 2, help = "maxEE forward")
parser$add_argument("--max_ee_r", type = "numeric", default = 2, help = "maxEE reverse")
parser$add_argument("--trunc_q", type = "integer", default = 2, help = "truncQ")
parser$add_argument("--max_len", type = "integer", default = 0,
  help = "maxLen per read pre-merge; 0 = no cap. Do NOT cap at the merged-amplicon length — reads that run through the insert are how mergePairs resolves short amplicons")
parser$add_argument("--min_overlap", type = "integer", default = 12, help = "mergePairs minOverlap")
parser$add_argument("--max_mismatch", type = "integer", default = 0, help = "mergePairs maxMismatch")
parser$add_argument("--chimera_method", default = "consensus", help = "removeBimeraDenovo method (consensus|pooled|per-sample)")
parser$add_argument("--pool", action = "store_true", default = FALSE,
  help = "pool samples in dada() (more power for low-biomass eDNA, slower)")
parser$add_argument("--cpu", type = "integer", default = 8, help = "multithread value")

args <- parser$parse_args()

trimmed_dir <- normalizePath(args$trimmed_dir, mustWork = TRUE)
dir.create(args$filtered_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(args$stats_out), recursive = TRUE, showWarnings = FALSE)

# ---- 1. discover samples ---------------------------------------------------
if (!is.null(args$samples) && length(args$samples) > 0) {
  sample_ids <- args$samples
} else {
  sample_ids <- basename(list.dirs(trimmed_dir, recursive = FALSE))
}
if (length(sample_ids) == 0) {
  stop(paste0("No sample directories found under ", trimmed_dir,
              " — the DADA2 script expects the <sid>/<sid>_R*.trimmed.fastq.gz layout"))
}

fnFs <- file.path(trimmed_dir, sample_ids, paste0(sample_ids, "_R1.trimmed.fastq.gz"))
fnRs <- file.path(trimmed_dir, sample_ids, paste0(sample_ids, "_R2.trimmed.fastq.gz"))

mode <- args$mode
if (mode == "auto") mode <- if (all(file.exists(fnRs))) "paired" else "single"
if (mode == "paired" && !all(file.exists(fnRs))) {
  stop(paste0("mode=paired but R2 trimmed FASTQs are missing for: ",
              paste(sample_ids[!file.exists(fnRs)], collapse = ", "), " — run the qc stage first or use --mode single"))
}
if (!all(file.exists(fnFs))) {
  stop(paste0("Missing trimmed R1 reads for: ", paste(sample_ids[!file.exists(fnFs)], collapse = ", "),
              " — run the qc stage first"))
}
cat("dada2 mode:", mode, "—", length(sample_ids), "samples\n")

filtFs <- file.path(args$filtered_dir, paste0(sample_ids, "_F_filt.fastq.gz"))

# ---- 2. filterAndTrim ------------------------------------------------------
# maxLen: filterAndTrim treats maxLen=0 as no cap; only pass when > 0.
# truncLen: build a vector only from the nonzero components (passing 0 asks for
# truncation to length 0 — wrong), pass nothing when both are 0.
# multithread: pass a LOGICAL (auto core detection), never an integer core count —
# on some dada2 builds an integer multithread crashes the mclapply forking stage
# ('names attribute [n] must be the same length as the vector [m]', scheduled
# cores 'did not deliver results'); multithread=TRUE verified on the same data.
# Set --cpu 0 to force single-core (RAM-constrained hosts: multithread=TRUE forks
# every worker holding full derep objects — a 14 GB box OOMs on multi-sample sets).
MT <- args$cpu > 0

if (mode == "paired") {
  filtRs <- file.path(args$filtered_dir, paste0(sample_ids, "_R_filt.fastq.gz"))
  names(filtFs) <- names(filtRs) <- sample_ids
  filt_args <- list(fnFs, filtFs, fnRs, filtRs,
                    maxN = 0, maxEE = c(args$max_ee_f, args$max_ee_r),
                    truncQ = args$trunc_q, rm.phix = TRUE,
                    compress = TRUE, multithread = MT, verbose = TRUE)
  if (args$max_len > 0) filt_args$maxLen <- args$max_len
  trunc <- c(args$trunc_len_f, args$trunc_len_r)
  if (any(trunc > 0) && all(trunc > 0)) {
    filt_args$truncLen <- trunc
  } else if (any(trunc > 0)) {
    warning("One truncLen side is 0 while the other is set — filterAndTrim has no per-side \"no trunc\", so truncLen is DISABLED entirely for this run.")
  }
  out <- do.call(filterAndTrim, filt_args)
  reads_in <- as.numeric(out[, "reads.in"]); names(reads_in) <- sample_ids
  filtered <- as.numeric(out[, "reads.out"]); names(filtered) <- sample_ids

  # F25 guard (see below the SE branch for the rationale): drop 0-read samples
  # before learnErrors, which dereps the FASTQs internally.
  empties <- sample_ids[filtered == 0]
  if (length(empties) > 0) {
    warning(paste0(length(empties), " sample(s) had 0 filtered reads and are EXCLUDED from DADA2: ",
                   paste(empties, collapse = ", ")))  # stays visible in the stats TSV
    sample_ids <- setdiff(sample_ids, empties)
    filtFs <- filtFs[sample_ids]; filtRs <- filtRs[sample_ids]
  }
  if (length(sample_ids) == 0) {
    stop("All samples have 0 filtered reads — check the qc stage's cutadapt retention and the --min_length / maxEE parameters")
  }

  errF <- learnErrors(filtFs, multithread = MT)
  errR <- learnErrors(filtRs, multithread = MT)

  derepFs <- derepFastq(filtFs); names(derepFs) <- sample_ids
  derepRs <- derepFastq(filtRs); names(derepRs) <- sample_ids

  ddF <- dada(derepFs, err = errF, multithread = MT, pool = args$pool)
  ddR <- dada(derepRs, err = errR, multithread = MT, pool = args$pool)

  # dada() returns a dada object for one sample or a list of them — normalize to list
  ddF_list <- if (inherits(ddF, "dada")) list(ddF) else ddF
  ddR_list <- if (inherits(ddR, "dada")) list(ddR) else ddR
  if (is.null(names(ddF_list))) names(ddF_list) <- sample_ids
  if (is.null(names(ddR_list))) names(ddR_list) <- sample_ids

  denoised_f <- sapply(ddF_list, function(x) {
  d <- x$denoised
  if (is.data.frame(d)) sum(d$abundance) else sum(d)  # list-input dada() stores an atomic abundance vector
})
  denoised_r <- sapply(ddR_list, function(x) {
  d <- x$denoised
  if (is.data.frame(d)) sum(d$abundance) else sum(d)
})

  mergers <- mergePairs(ddF, derepFs, ddR, derepRs,
                        minOverlap = args$min_overlap, maxMismatch = args$max_mismatch)
} else {
  names(filtFs) <- sample_ids
  filt_args <- list(fnFs, filtFs,
                    maxN = 0, maxEE = args$max_ee_f,
                    truncQ = args$trunc_q, rm.phix = TRUE,
                    compress = TRUE, multithread = MT, verbose = TRUE)
  if (args$max_len > 0) filt_args$maxLen <- args$max_len
  if (args$trunc_len_f > 0) filt_args$truncLen <- args$trunc_len_f
  out <- do.call(filterAndTrim, filt_args)
  reads_in <- as.numeric(out[, "reads.in"]); names(reads_in) <- sample_ids
  filtered <- as.numeric(out[, "reads.out"]); names(filtered) <- sample_ids

  # F25 guard — filterAndTrim refuses to write the output FASTQ when all reads are
  # filtered, so learnErrors' internal derepFastq would die with 'Not all provided
  # files exist' on the missing file (F25: a qc sample with 0 primer-matching raw
  # reads). Mirrors the merge_tables.R empty-sample skip.
  empties <- sample_ids[filtered == 0]
  if (length(empties) > 0) {
    warning(paste0(length(empties), " sample(s) had 0 filtered reads and are EXCLUDED from DADA2: ",
                   paste(empties, collapse = ", ")))  # stays visible in the stats TSV
    sample_ids <- setdiff(sample_ids, empties)
    filtFs <- filtFs[sample_ids]
  }
  if (length(sample_ids) == 0) {
    stop("All samples have 0 filtered reads — check the qc stage's cutadapt retention and the --min_length / maxEE parameters")
  }

  errF <- learnErrors(filtFs, multithread = MT)
  derepFs <- derepFastq(filtFs); names(derepFs) <- sample_ids
  ddF <- dada(derepFs, err = errF, multithread = MT, pool = args$pool)
  ddF_list <- if (inherits(ddF, "dada")) list(ddF) else ddF
  if (is.null(names(ddF_list))) names(ddF_list) <- sample_ids

  denoised_f <- sapply(ddF_list, function(x) {
  d <- x$denoised
  if (is.data.frame(d)) sum(d$abundance) else sum(d)  # list-input dada() stores an atomic abundance vector
})
  denoised_r <- rep(0L, length(sample_ids)); names(denoised_r) <- sample_ids

  # SE: no merging step — the denoised reads ARE the final per-read table
  seqtab <- makeSequenceTable(ddF)
  merged <- denoised_f
}

# ---- 6. chimera removal ----------------------------------------------------
seqtab_nochim <- removeBimeraDenovo(seqtab, method = args$chimera_method,
                                    multithread = args$cpu > 0, verbose = TRUE)
# seqtab rows = samples, cols = sequences — per-SAMPLE retained reads are rowSums;
# colSums would be per-SEQUENCE totals (F27 orientation lesson)
nonchim <- rowSums(seqtab_nochim); names(nonchim) <- rownames(seqtab_nochim)
chim_pct <- if (sum(colSums(seqtab)) > 0) round(100 * (1 - sum(nonchim) / sum(colSums(seqtab))), 1) else NA

# ---- 7. ASV ids + outputs --------------------------------------------------
# makeSequenceTable orientation: ROWS = samples, COLUMNS = sequences (both modes).
# The merge_tables.R contract needs the TRANSPOSE (rows = ASVs, cols = samples).
# Order ASVs by decreasing total abundance; names ASV1..n (F26: the original script
# failed on this orientation — data.frame(504 ASV ids, 17x504 matrix) dimension clash).
totals <- colSums(seqtab_nochim)
ord <- order(totals, decreasing = TRUE)
seqtab_ord <- seqtab_nochim[, ord, drop = FALSE]
seq_strings <- colnames(seqtab_ord)
totals <- colSums(seqtab_ord)
n_asv <- ncol(seqtab_ord)
asv_ids <- paste0("ASV", seq_len(n_asv))
colnames(seqtab_ord) <- asv_ids
# sample names are the ROW names of the dada2 table (derep list names) — kept as-is
asv_table <- t(seqtab_ord)   # rows = ASVs, cols = samples

# Feature table: samples as columns, ASV_ID first column — the EXACT
# merge_tables.R output style (plain header line, then data, no index column).
table_df <- data.frame(ASV_ID = asv_ids, asv_table, check.names = FALSE)
# samples with 0 merged reads produce an all-zero column — keep it (merge_tables.R
# keeps zero columns for empty per-sample files too)
header_line <- paste(colnames(table_df), collapse = "\t")
writeLines(header_line, con = args$table_out)
fwrite(table_df, file = args$table_out, sep = "\t", quote = FALSE, col.names = FALSE, append = TRUE)

# Rep-seq FASTA with ;size= annotations (total abundance) — mirrors the UNOISE3
# --sizeout header convention so classify's `sed 's/;size=[0-9]*//'` works unchanged.
con <- file(args$fasta_out, open = "wt")
for (i in seq_len(n_asv)) {
  writeLines(c(paste0(">", asv_ids[i], ";size=", format(as.integer(totals[i]))),
               seq_strings[i]), con = con)
}
close(con)

# Per-sample read-flow stats (mirrors the QIIME2 denoising-stats view):
# raw (untrimmed) count is unavailable here — report reads.in at filter time.
stats_df <- data.frame(
  sample_id        = sample_ids,
  reads_in         = as.integer(reads_in[sample_ids]),
  reads_filtered   = as.integer(filtered[sample_ids]),
  reads_denoised_f = as.integer(denoised_f[sample_ids]),
  reads_denoised_r = as.integer(denoised_r[sample_ids]),
  reads_merged     = as.integer(merged[sample_ids]),
  reads_nonchim    = as.integer(nonchim[sample_ids]),
  stringsAsFactors = FALSE)
fwrite(stats_df, file = args$stats_out, sep = "\t", row.names = FALSE)

cat("\n=== DADA2 summary ===\n")
cat("ASVs (non-chimeric):", n_asv, "\n")
cat("Chimera reads removed:", chim_pct, "%\n")
cat("Samples in table:", nrow(seqtab_nochim), "\n")
zero_samples <- rownames(seqtab_nochim)[rowSums(seqtab_nochim) == 0]
cat("Samples with 0 non-chimeric ASVs:",
    if (length(zero_samples)) paste(zero_samples, collapse = ", ") else "(none)", "\n")
cat(paste0("Wrote: ", args$table_out, "\n       ", args$fasta_out,
           "\n       ", args$stats_out, "\n"))
