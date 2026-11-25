#!/usr/bin/env python3
"""Merge ASVs with identical sequences ACROSS samples (sum counts, one ASV per sequence).

Why: the UNOISE3 path denoises per sample; vsearch centroid IDs are read headers, and
bin/merge_tables.R joins on that ID, so identical sequences in different samples are never
merged (every ASV ends up in exactly one sample). Run after merge_tables.R, BEFORE decontam.

Exact, case-insensitive sequence identity only (reads are strand-oriented by cutadapt -g).
New ID = ASV_ + first 12 hex of sha1(sequence): deterministic, stable across reruns.
"""
import argparse, csv, hashlib, collections, sys
p = argparse.ArgumentParser()
p.add_argument("--feature_table", required=True); p.add_argument("--rep_seqs", required=True)
p.add_argument("--out_table", required=True); p.add_argument("--out_rep_seqs", required=True)
p.add_argument("--out_map", required=True)
a = p.parse_args()

seq = {}; cur = None
for l in open(a.rep_seqs):
    if l.startswith(">"): cur = l[1:].strip().split(";")[0]; seq[cur] = []
    else: seq[cur].append(l.strip())
seq = {k: "".join(v).upper() for k, v in seq.items()}

rows = list(csv.reader(open(a.feature_table), delimiter="\t"))
hdr, body = rows[0], rows[1:]
ns = len(hdr) - 1
merged = collections.OrderedDict(); members = collections.defaultdict(list)
missing = [r[0] for r in body if r[0] not in seq]
if missing: sys.exit(f"{len(missing)} feature IDs have no sequence, e.g. {missing[:3]}")
for r in body:
    s = seq[r[0]]; v = [float(x) for x in r[1:]]
    if s in merged: merged[s] = [x + y for x, y in zip(merged[s], v)]
    else: merged[s] = v
    members[s].append(r[0])
tot_in = [sum(float(r[i + 1]) for r in body) for i in range(ns)]
tot_out = [sum(v[i] for v in merged.values()) for i in range(ns)]
assert all(abs(x - y) < 1e-6 for x, y in zip(tot_in, tot_out)), "per-sample read totals changed!"
order = sorted(merged, key=lambda s: -sum(merged[s]))
ids = {s: "ASV_" + hashlib.sha1(s.encode()).hexdigest()[:12] for s in order}
assert len(set(ids.values())) == len(ids)
fmt = lambda x: str(int(x)) if float(x).is_integer() else str(x)
with open(a.out_table, "w") as f:
    w = csv.writer(f, delimiter="\t", lineterminator="\n"); w.writerow(hdr)
    for s in order: w.writerow([ids[s]] + [fmt(x) for x in merged[s]])
with open(a.out_rep_seqs, "w") as f:
    for s in order: f.write(f">{ids[s]};size={int(sum(merged[s]))}\n{s}\n")
with open(a.out_map, "w") as f:
    w = csv.writer(f, delimiter="\t", lineterminator="\n"); w.writerow(["old_id", "merged_asv_id"])
    for s in order:
        for m in members[s]: w.writerow([m, ids[s]])
multi = sum(1 for s in order if len(members[s]) > 1)
print(f"{len(body)} per-sample ASVs -> {len(order)} merged ASVs ({multi} sequences occur in >1 sample); "
      f"per-sample read totals conserved over {ns} samples; total reads {int(sum(tot_out))}")
