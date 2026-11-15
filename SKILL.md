---
name: edna-agent
description: Agent-driven orchestration of environmental DNA (eDNA) metabarcoding analysis for four marker genes — 16S (Bacteria/Archaea), 18S-V9, COI, and 12S (Eukaryota) — covering intake → QC → denoise → classify (IDTAXA / consensus-BLAST / dada2-nb naive-Bayes, optional cross-method comparison) → diversity → association → interpret with marker-specific parameter presets. The agent executes every stage tool directly (cutadapt, FastQC, NGmerge/UNOISE3 or DADA2 denoiser, decontam, IDTAXA, consensus-BLAST, naive-Bayes, Maaslin2) via per-stage pixi environments; no Nextflow required. Mirrors the BettaMt ask-user pattern and the skill-forge evidence chain (preflight → run → interpret). Use when the user asks to "run an eDNA metabarcoding analysis", "process 16S/18S/COI/12S amplicon reads", "interpret eDNA results", "identify fish species from eDNA", or "set up an eDNA amplicon run". Builds on read-qc-trimming (raw-read QC upstream) and pairs with edna-gbif-publish (downstream publishing) and edna-visualize (figures).
version: 1.4.0
updated: "2026-11-13"
triggers:
  - "run eDNA metabarcoding"
  - "process 16S amplicon reads"
  - "process 18S V9 reads"
  - "process COI reads"
  - "process 12S reads"
  - "eDNA ASV inference"
  - "taxonomic classification 16S"
  - "eDNA alpha beta diversity"
  - "eDNA differential abundance"
  - "IDTAXA classification"
  - "VSEARCH UNOISE3"
  - "metabarcoding pipeline"
  - "edna-agent"
requires:
  - "Pixi (curl -fsSL https://pixi.sh/install.sh | bash) — manages per-stage tool environments under env/"
  - "Python ≥ 3.10 (system) for intake/summary artifacts"
  - "git"
disable-model-invocation: true
---

# Meta-Skill: edna-agent

> **This SKILL.md is a router. It does not duplicate logic from the sub-skills. Its job is to ask: *what stage is the user at, and which sub-skill should they invoke next?*

## Audience

This meta-skill serves two simultaneous audiences:

1. **AI Coding Agents** — triggered by the phrases above. The agent must follow the strict evidence chain (Preflight → Run → Interpret), respect each sub-skill's decision points, and write the `pipeline_state.json`, `run_summary.json`, and `<run_id>-report.md` artifacts the sub-skills specify. Execution is **agent-driven**: the agent reads the stage recipes from `run/edna-run/SKILL.md`, shows the constructed commands to the scientist, and runs them under `pixi run --manifest-path env/{stage}/pixi.toml`.
2. **Human eDNA scientists** — read this document as a workflow guide. The sections explain *why* each phase exists and *what* trade-offs apply at each marker preset.

## When to Use This Skill

Use this meta-skill when you need to:

- Run an **eDNA metabarcoding analysis** for one of the four supported markers (16S, 18S-V9, COI, 12S).
- Execute the analysis in **stages** (QC → denoise → classify → diversity → association), agent-driven, resumable via `pipeline_state.json`.
- Produce a **structured report** and **narrative Results-section summary** from completed outputs.
- Conduct **differential abundance**, **taxon-environment**, or **taxon-taxon correlation** analyses on eDNA community tables.

**Do NOT use this skill** if:

- You have **raw reads that have not been QC-trimmed yet** — use `read-qc-trimming` first; this skill's QC stage does primer trimming only; if your reads also need adapter trimming + quality filtering, do that first.
- You want a **workflow-engine pipeline** (Nextflow/Snakemake WDL) — as of v1.2.0 this skill is agent-driven by design; compose it with an engine externally if needed.
- You are analysing **shotgun metagenomics** (different paradigm; use `gene-quantification` and downstream skills).
- Your marker is **not one of the four supported** — marker-specific behavior is supplied via `params/{16s,18s-v9,coi,12s}.json` presets.

## 0. Orchestrator — detect stage, route to the right sub-skill

### 0.1 Locate the run directory

By convention the agent writes run artifacts to `results/{run_id}/` below the dataset directory. The `pipeline_state.json` lives at `results/{run_id}/pipeline_state.json`. Override with the `RUN_DIR` env var or by passing `--run-dir` to the sub-skill.

### 0.2 Detect the user's stage

Try to detect automatically **before** asking:

```bash
# Stage detection ladder — first match wins
test -f "$RUN_DIR/results/{run_id}/pipeline_state.json" || STAGE="intake"      # no state → start intake
test -f "$RUN_DIR/results/{run_id}/run_summary.json"   && STAGE="interpret"     # summary exists → run interpret
jq -r '.completed_stages | index("association") != null' "$RUN_DIR/results/{run_id}/pipeline_state.json" 2>/dev/null | grep -q true && STAGE="interpret"
jq -r '.completed_stages | index("classify") != null' "$RUN_DIR/results/{run_id}/pipeline_state.json" 2>/dev/null | grep -q true && STAGE="interpret-or-continue"
: "${STAGE:=intake}"
```

If auto-detection is ambiguous, ask the user one short question (see **SP0** below).

### 0.3 Stage → sub-skill routing table

| Detected stage | Route to | Output artifact |
| --- | --- | --- |
| `intake` | `preflight/edna-intake/SKILL.md` | `results/{run_id}/pipeline_state.json` with verdict gate |
| `run` (any stage pending) | `run/edna-run/SKILL.md` | `results/{run_id}/{stage}` outputs + updated `pipeline_state.json` |
| `interpret` (≥ classify complete) | `interpret/edna-interpret/SKILL.md` | `results/{run_id}/<run_id>-report.md` + `narrative.md` |
| `interpret-or-continue` | ask user | — |
| `debug` | inspect stage logs under `results/{run_id}/`, fix, then re-invoke `run/edna-run` from the failed stage | — |

### 0.4 Execution model — agent-driven

There is **no workflow engine**. The `run/edna-run` sub-skill contains the canonical bash recipe for every stage process (mirroring the tool invocations validated in the real-data battle-test runs). The agent:

1. Reads `pipeline_state.json` (SP1 verdict gate).
2. Determines the next stage and constructs the concrete command chain from the recipe table.
3. Shows the commands to the scientist and waits for confirmation.
4. Executes them under `pixi run --manifest-path env/{stage}/pixi.toml …`.
5. Updates `pipeline_state.json` only after verified success (per-stage output checks).

Auxiliary workflows (`idtaxa-training`, `reference-db`, `edna-visualize`) are script-based and have their own preflight + run sub-skills.

### 0.5 Master ask-user stop point (SP0)

#### SP0 — Stage auto-detection ambiguous

| Trigger | Evidence check | Action |
| --- | --- | --- |
| `pipeline_state.json` exists with ≥ 3 completed stages AND user did not specify intake / run / interpret | Multiple valid routings | Ask: "I see `<run_id>` with completed stages `<list>`. Pick: (A) start a **new run** via `preflight/edna-intake`, (B) **continue** the existing run via `run/edna-run`, (C) **interpret** completed results via `interpret/edna-interpret`, (D) something else — tell me" |
| `pipeline_state.json` is missing AND user mentions a `run_id` | State file lost or never written | Ask: "I see a `run_id` reference but no `results/{run_id}/pipeline_state.json`. Pick: (A) re-run `preflight/edna-intake` to recreate it, (B) point me at the correct location, (C) abort" |

**Auto-pick when**: stage detection ladder resolves unambiguously. No ask.

### Operating rule

> **Auto-pick when the evidence is unambiguous; ask when the agent genuinely cannot decide.** When asking, present the evidence first, then a recommendation, then 2–4 concrete options.

## Description

This meta-skill orchestrates eDNA metabarcoding analysis through three phases:

1. **`preflight/edna-intake`** — gather run parameters (marker, primers, metadata, IDTAXA model, run_id), validate inputs (E1–E7 evidence items), write `results/{run_id}/pipeline_state.json` with the GO gate.
2. **`run/edna-run`** — read `pipeline_state.json`, determine the next stage (qc → denoise → classify → diversity → association), construct the stage's tool commands from the recipe table, execute via pixi stage envs, and update state after each verified stage.
3. **`interpret/edna-interpret`** — read `results/{run_id}/run_summary.json`, turn it into a structured `<run_id>-report.md` and `narrative.md`, then enter an interactive Q&A loop.

Each phase ships its own **ask-user stop points** for decision ambiguity inside the phase (e.g., primer mismatch tolerance, DAA method choice, occurrence-crosscheck realm).

## Prerequisites

- **Pixi** — manages per-stage tool envs under `env/{qc,denoise,classification,database,diversity,association}/pixi.toml`. First run of a stage resolves and caches its env automatically; no manual conda setup.
- **Python ≥ 3.10** (system) for `bin/skill-update-check.py` and the intake/summary artifacts.
- **Reference assets per marker** — trained IDTAXA models live under `assets/{16s,18s-v9,coi,12s}/` and are gitignored (supply your own; the `idtaxa-training/` sub-skill trains one from a reference FASTA, the `reference-db/` sub-skill sources reference databases).
- **git** — for versioning and commits.

## Marker presets (`params/`)

| Preset        | Marker | Length range | Kingdoms          | DAA/correlation level |
| ------------- | ------ | ------------ | ----------------- | --------------------- |
| `16s.json`    | 16S    | 350–550 bp   | Bacteria, Archaea | Genus                 |
| `18s-v9.json` | 18S-V9 | 100–180 bp   | Eukaryota         | Species               |
| `coi.json`    | COI    | 290–340 bp   | Eukaryota         | Species               |
| `12s.json`    | 12S    | 150–220 bp   | all (mitochondria)| Species               |

At intake, the preset and the run-specific `params.json` are **merged into one JSON object** (preset first, run overrides last-wins) because CLI flag-lists are single-file: `merged = {**preset, **run_specific}` — see the v1.1.0 signature-library entry for the multi-`-params-file` regression lesson. Each preset carries `"denoiser"` (`"unoise3"` default, or `"dada2"` for the alternative paired-end error model — see the run sub-skill's SP6).

## Output artifacts

For a complete run (`run_id = 12s-20261007-battletest`):

```
results/{run_id}/
├── pipeline_state.json           ← written by preflight/edna-intake, updated by run/edna-run
├── qc/trimmed/<sample>/          ← cutadapt primer-trimmed FASTQs
├── qc/fastqc/<sample>/           ← FastQC reports (raw + trimmed)
├── denoise/                      ← NGmerge merged reads + UNOISE3 ASVs (default engine), or DADA2 denoised ASVs (`denoiser: "dada2"`)
├── asv_table/                    ← merged table, decontam + filter outputs
├── taxonomy/                     ← IDTAXA classification + agglomerated rank tables
├── diversity/                    ← tree, alpha metrics, beta/PERMANOVA, community typing
├── association/                  ← differential abundance (Maaslin2), correlations
├── run_summary.json              ← compact summary for LLM context (bin/summarise_run.py)
├── <run_id>-report.md            ← structured report (interpret/edna-interpret)
└── narrative.md                  ← plain-language Results-section draft
```

## Composability with other AiX-BIO skills

| Skill | When to chain |
| --- | --- |
| `read-qc-trimming` | Run **before** `preflight/edna-intake` if your reads are raw (untrimmed) and need adapter trimming first. |
| `pixi-skill` | Use to add/modify the per-stage pixi envs under `env/`. |
| `skill-forge` | Meta-skill: battle-test and rebuild this skill (`test_smoke.py --offline`). |
| `edna-gbif-publish` | After `interpret/edna-interpret`, publish occurrence data to GBIF. |
| `occurrence-crosscheck` | After `interpret/edna-interpret`: validate the run's occurrence records against GBIF/OBIS/WoRMS/FishBase + environmental envelopes, then viz → publish. Chain: `interpret → occurrence-crosscheck (validate → viz → publish)`. Coordinates come from the sample sheet (`scientificName, decimalLatitude, decimalLongitude, eventDate`) — there is no runtime geocode step. Realm is a per-run choice (marine/freshwater/terrestrial; coastal/estuarine fish runs → marine). `crosscheck` preflight hard-fails without `--user-email` (SP-4): the agent MUST ask the user for their contact email. OBIS publishing additionally needs WoRMS `scientificNameID` LSIDs; biodb-fetch owns OBIS rate spacing. Outputs (`enriched.parquet`, `crosscheck_report.json`, `flagged_occurrences.tsv`, `review_queue.csv`) are the handoff artifacts to viz/publish. |
| **`idtaxa-training/`** (this repo) | Run **before** the first-ever run if you don't yet have an IDTAXA `.rds` model. NCBI FASTA → DECIPHER headers → trained `.rds`. |
| **`reference-db/`** (this repo) | Curated download URLs for the 4 marker reference databases + validation + training chain. |
| **`edna-visualize/`** (this repo) | After `interpret/edna-interpret`: publication-ready figures from the rank count tables. |

## Handoff contract

| From | To | Artifact |
| --- | --- | --- |
| `preflight/edna-intake` | `run/edna-run` | `results/{run_id}/pipeline_state.json` (verdict gate + params) |
| `run/edna-run` | `interpret/edna-interpret` | `results/{run_id}/run_summary.json` (compact, LLM-loadable) |
| `run/edna-run` | next `run/edna-run` invocation | updated `pipeline_state.json` with new `completed_stages` |
| `interpret/edna-interpret` | human / manuscript | `results/{run_id}/<run_id>-report.md` + `narrative.md` |
| `interpret/edna-interpret` | `occurrence-crosscheck` (validate) | sample-sheet-derived 4-column occurrence CSV (`scientificName, decimalLatitude, decimalLongitude, eventDate`) |

## What NOT to do

- Do **not** skip `preflight/edna-intake`. The pipeline expects a complete `pipeline_state.json` with every parameter validated.
- Do **not** re-add a workflow engine unless the canonical battle-test re-run proves it; agent-driven execution is the design as of v1.2.0.
- Do **not** edit `params/{marker}.json` to add a new marker — marker-specific behavior lives across `bin/` scripts and presets. Adding a marker requires the canonical extension procedure.
- Do **not** delete `pipeline_state.json` mid-run — resumability depends on it.
- Do **not** commit `assets/`, `results/`, `work/`, or `*.fastq.gz` — see `.gitignore`.
- Do **not** trust marker assignment from primer signatures alone — the battle-test round-2 lesson (F10): primer sites are necessary but not sufficient; run the post-denoise ASV-vs-reference sanity check before CLASSIFY.

## Reproducibility

- Stage recipes: `run/edna-run/SKILL.md` (single source of truth for every command)
- Per-stage tool envs: `env/{stage}/pixi.toml` (+ `pixi.lock` gitignored, resolved per machine)
- Marker presets: `params/{16s,18s-v9,coi,12s}.json`
- Run artifacts: `results/{run_id}/` (gitignored)
- Skill spec: `SKILL.md` (this file), `preflight/edna-intake/SKILL.md`, `run/edna-run/SKILL.md`, `interpret/edna-interpret/SKILL.md`
- Structural smoke tests: `test_smoke.py --offline`

## Update Check

This skill ships a self-update check comparing the deployed copy against the upstream GitHub repo via `git fetch` + SHA diff:

```bash
python3 bin/skill-update-check.py      # or: pixi run update-check
# UP-TO-DATE (0) | LOCAL-AHEAD (0) | BEHIND-BY-N (1) | OFFLINE (2) | NO-ORIGIN (2)
```

When `BEHIND-BY-N`, re-deploy from `@skills/edna-agent/` (per AGENTS.md §4a) and verify with `diff -rq`.

## Handoff

After `interpret/edna-interpret` writes `<run_id>-report.md` and `narrative.md`, the run is complete. Common follow-ups: manuscript drafting (`literature-pipeline`), GBIF publishing (`edna-gbif-publish`), figures (`edna-visualize`), or a new run at a different marker.