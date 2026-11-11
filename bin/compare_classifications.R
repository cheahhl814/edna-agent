#!/usr/bin/env Rscript

# Cross-method classification comparison — v1.3.3 companion to the optional
# `classification_comparison: true` mode. Compares N idtaxa-style classification
# TSVs (SequenceID + lowercase rank columns) produced by the SP5 methods on the
# SAME query set, writing rank-level pairwise agreement + a per-ASV concordance
# profile. The canonical taxonomy always stays the PRIMARY method's output —
# this script never merges methods (each annotation is a different inference on
# the same evidence; merging is meaningless, comparison is diagnostic).
#
# Requires: argparse, data.table (env/classification).

suppressPackageStartupMessages({
    library(argparse)
    library(data.table)
})

parser <- ArgumentParser(description = 'Compare N classification TSVs (same SequenceID set) by rank agreement.')
parser$add_argument('--classifications', nargs = '+', required = TRUE,
                    help = 'Paths to idtaxa-style classification TSVs, each prefixed "name=path" (e.g. consensus-blast=taxonomy/idtaxa_classification.tsv).')
parser$add_argument('--output_agreement', required = TRUE,
                    help = 'Output pairwise rank-agreement TSV.')
parser$add_argument('--output_concordance', required = TRUE,
                    help = 'Output per-ASV concordance TSV (which methods assigned each ASV).')
parser$add_argument('--unassigned_labels', nargs = '+', default = c('NA', 'NA/NA', 'unassigned', ''),
                    help = 'Values treated as unassigned across methods.')

args <- parser$parse_args()

parse_one <- function(spec) {
    parts <- strsplit(spec, "=", fixed = TRUE)[[1]]
    if (length(parts) != 2) stop(paste0("--classifications entries must be name=path, got: ", spec))
    list(name = parts[[1]], path = parts[[2]])
}
specs <- lapply(args$classifications, parse_one)
if (length(specs) < 2) stop("Need >= 2 classification files to compare.")

is_unassigned <- function(x) x %in% args$unassigned_labels | is.na(x) | x == ""

tables <- lapply(specs, function(sp) {
    dt <- fread(sp$path, sep = "\t", header = TRUE, data.table = FALSE, stringsAsFactors = FALSE, na.strings = NULL)
    if (!"SequenceID" %in% names(dt)) stop(paste0(sp$path, ": missing SequenceID column."))
    for (c in setdiff(names(dt), "SequenceID")) dt[[c]] <- as.character(dt[[c]])
    dt
})
names(tables) <- vapply(specs, `[[`, "", "name")
rank_cols <- Reduce(intersect, lapply(tables, names))
rank_cols <- setdiff(rank_cols, "SequenceID")
if (length(rank_cols) == 0) stop("The classification files share no rank columns.")

ids_all <- Reduce(intersect, lapply(tables, function(dt) dt$SequenceID))
message(paste("Comparing", length(tables), "methods over", length(ids_all),
              "shared ASVs at ranks:", paste(rank_cols, collapse = ",")))
if (length(ids_all) == 0) stop("The classification files share no common SequenceIDs — are they from the same query set?")

merged <- data.frame(SequenceID = ids_all)
for (nm in names(tables)) {
    d <- tables[[nm]][match(ids_all, tables[[nm]]$SequenceID), , drop = FALSE]
    names(d) <- paste0(nm, "::", names(d))
    merged <- cbind(merged, d[, setdiff(names(d), paste0(nm, "::SequenceID")), drop = FALSE])
}

# --- Pairwise rank agreement ---------------------------------------------------
pairs <- combn(names(tables), 2, simplify = FALSE)
rows <- list()
for (p in pairs) {
    ta <- match(ids_all, tables[[p[1]]]$SequenceID)
    tb <- match(ids_all, tables[[p[2]]]$SequenceID)
    a <- tables[[p[1]]][ta, match(rank_cols, names(tables[[p[1]]])), drop = FALSE]
    b <- tables[[p[2]]][tb, match(rank_cols, names(tables[[p[2]]])), drop = FALSE]
    for (rc in rank_cols) {
        va <- a[[rc]]; vb <- b[[rc]]
        both_assigned <- !is_unassigned(va) & !is_unassigned(vb)
        agree <- both_assigned & va == vb
        one_assigned <- xor(!is_unassigned(va), !is_unassigned(vb))
        rows[[length(rows) + 1L]] <- data.frame(
            method_1 = p[1], method_2 = p[2], rank = rc,
            n_shared = length(ids_all),
            n_both_assigned = sum(both_assigned),
            n_agree = sum(agree),
            agreement_pct_of_both = if (sum(both_assigned) > 0) round(100 * sum(agree) / sum(both_assigned), 1) else NA,
            n_one_assigned = sum(one_assigned),
            n_disagree = sum(both_assigned & !agree),
            stringsAsFactors = FALSE)
    }
}
agreement_df <- rbindlist(rows, use.names = TRUE)
fwrite(agreement_df, file = args$output_agreement, sep = "\t", quote = FALSE)

# --- Per-ASV concordance profile ------------------------------------------------
n_methods <- length(tables)
con_rows <- list()
for (rc in rank_cols) {
    assigned <- sapply(names(tables), function(nm) !is_unassigned(tables[[nm]][ids_all, rc]))
    counts   <- rowSums(assigned)
    # full concordance: every method that assigned this ASV at this rank agrees
    agree_vec <- rep(NA_real_, length(ids_all))
    for (i in seq_along(ids_all)) {
        vals <- vapply(names(tables), function(nm) tables[[nm]][ids_all[i], rc], "")
        vals <- vals[!is_unassigned(vals)]
        if (length(vals) >= 2) agree_vec[i] <- as.integer(length(unique(vals)) == 1)
    }
    conc_rows <- data.frame(
        SequenceID = ids_all, rank = rc,
        n_methods_assigned = as.integer(counts),
        concordant = agree_vec,
        stringsAsFactors = FALSE)
    conc_rows <- conc_rows[!is.na(conc_rows$concordant) | conc_rows$n_methods_assigned > 0, ]
    conc_rows <- conc_rows[conc_rows$n_methods_assigned >= 2, ]
    if (nrow(conc_rows) > 0) con_rows[[length(con_rows) + 1L]] <- conc_rows
}
concordance_df <- if (length(con_rows)) rbindlist(con_rows, use.names = TRUE) else {
    data.frame(SequenceID = character(), rank = character(),
               n_methods_assigned = integer(), concordant = integer())
}
fwrite(concordance_df, file = args$output_concordance, sep = "\t", quote = FALSE)

# console summary
for (rc in rank_cols) {
    m <- agreement_df[agreement_df$rank == rc, ]
    for (i in seq_len(nrow(m))) {
        message(sprintf("%s vs %s @ %s: both-assigned %d/%d, agree %s%%, one-sided %d, disagree %d",
                        m$method_1[i], m$method_2[i], rc, m$n_both_assigned[i], m$n_shared[i],
                        m$agreement_pct_of_both[i], m$n_one_assigned[i], m$n_disagree[i]))
    }
    sel <- concordance_df[concordance_df$rank == rc, ]
    if (nrow(sel) > 0) {
        message(sprintf("concordant multi-method assignments @ %s: %d/%d (%s%%)",
                        rc, sum(sel$concordant), nrow(sel),
                        round(100 * mean(sel$concordant), 1)))
    }
}
message("Cross-method comparison complete — the PRIMARY method's canonical outputs are untouched; cite these files in the interpret report only as side-by-side evidence.")
