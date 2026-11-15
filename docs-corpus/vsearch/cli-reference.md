vsearch v2.32.0_linux_x86_64, 15.0GB RAM, 12 cores
https://github.com/torognes/vsearch

Rognes T, Flouri T, Nichols B, Quince C, Mahe F (2016)
VSEARCH: a versatile open source tool for metagenomics
PeerJ 4:e2584 doi: 10.7717/peerj.2584 https://doi.org/10.7717/peerj.2584

Usage: /home/cheahhl814/claude_workspace/bioinformatics/AIx-BIO/skills/edna-agent/env/denoise/.pixi/envs/default/bin/vsearch [OPTIONS]

For further details, please consult the manual by entering: man vsearch
(or man vsearch-<command> for one command). It is also readable online at
https://torognes.github.io/vsearch/

General options
  --bzip2_decompress          decompress input with bzip2 (required if pipe)
  --fasta_width INT           width of FASTA seq lines, 0 for no wrap (80)
  --gzip_decompress           decompress input with gzip (required if pipe)
  --help | -h                 display help information
  --log FILENAME              write messages, timing and memory info to file
  --maxseqlength INT          maximum sequence length (50000)
  --minseqlength INT          min seq length (clust/derep/search: 32, other:1)
  --no_progress               do not show progress indicator
  --notrunclabels             do not truncate labels at first space
  --quiet                     output just warnings and fatal errors to stderr
  --threads INT               number of threads to use, zero for all cores (0)
  --version | -v              display version information

Chimera detection with new algorithm
  --chimeras_denovo FILENAME  detect chimeras de novo in long exact sequences
 Parameters
  --abskew REAL               minimum abundance ratio (1.0)
  --chimeras_diff_pct REAL    mismatch % allowed in each chimeric region (0.0)
  --chimeras_length_min INT   minimum length of each chimeric region (10)
  --chimeras_parents_max INT  maximum number of parent sequences (3)
  --chimeras_parts INT        number of parts to divide sequences (length/100)
  --sizein                    propagate abundance annotation from input
 Output
  --alignwidth INT            width of alignments in alignment output file (60)
  --alnout FILENAME           output chimera alignments to file
  --chimeras FILENAME         output chimeric sequences to file
  --lengthout                 write length annotation to output
  --nonchimeras FILENAME      output non-chimeric sequences to file
  --relabel STRING            relabel nonchimeras with this prefix string
  --relabel_keep              keep the old label after the new when relabelling
  --relabel_md5               relabel with md5 digest of normalized sequence
  --relabel_self              relabel with the sequence itself as label
  --relabel_sha1              relabel with sha1 digest of normalized sequence
  --sample STRING             add sample identifier annotation to output
  --sizeout                   include abundance information when relabelling
  --tabbedout FILENAME        output chimera info to tab-separated file
  --xlength                   strip length information in output
  --xsize                     strip abundance information in output

Chimera detection with UCHIME algorithms
  --uchime_denovo FILENAME    detect chimeras de novo
  --uchime2_denovo FILENAME   detect chimeras de novo in denoised amplicons
  --uchime3_denovo FILENAME   detect chimeras de novo in denoised amplicons
  --uchime_ref FILENAME       detect chimeras using a reference database
 Data
  --db FILENAME               reference database for --uchime_ref
 Parameters
  --abskew REAL               minimum abundance ratio (2.0, 16.0 for uchime3)
  --dn REAL                   'no' vote pseudo-count (1.4)
  --mindiffs INT              minimum number of differences in segment (3) *
  --mindiv REAL               minimum divergence from closest parent (0.8) *
  --minh REAL                 minimum score (0.28) * ignored in uchime2/3
  --sizein                    propagate abundance annotation from input
  --self                      exclude identical labels for --uchime_ref
  --selfid                    exclude identical sequences for --uchime_ref
  --xn REAL                   'no' vote weight (8.0)
 Output
  --alignwidth INT            width of alignment in uchimealn output (80)
  --borderline FILENAME       output borderline chimeric sequences to file
  --chimeras FILENAME         output chimeric sequences to file
  --fasta_score               include chimera score in FASTA output
  --lengthout                 write length annotation to output
  --nonchimeras FILENAME      output non-chimeric sequences to file
  --relabel STRING            relabel nonchimeras with this prefix string
  --relabel_keep              keep the old label after the new when relabelling
  --relabel_md5               relabel with md5 digest of normalized sequence
  --relabel_self              relabel with the sequence itself as label
  --relabel_sha1              relabel with sha1 digest of normalized sequence
  --sample STRING             add sample identifier annotation to output
  --sizeout                   include abundance information when relabelling
  --uchimealns FILENAME       output chimera alignments to file
  --uchimeout FILENAME        output to chimera info to tab-separated file
  --uchimeout5                make output compatible with uchime version 5
  --xlength                   strip length information in output
  --xsize                     strip abundance information in output

Clustering
  --cluster_fast FILENAME     cluster sequences after sorting by length
  --cluster_size FILENAME     cluster sequences after sorting by abundance
  --cluster_smallmem FILENAME cluster already sorted sequences (see -usersort)
  --cluster_unoise FILENAME   denoise Illumina amplicon reads
 Parameters (most searching options also apply)
  --cons_truncate             do not ignore terminal gaps in MSA for consensus
  --id REAL                   reject if identity lower, accepted values: 0-1.0
  --iddef INT                 id definition, 0-4=CD-HIT,all,int,MBL,BLAST (2)
  --qmask none|dust|soft      mask seqs with dust, soft or no method (dust)
  --sizein                    propagate abundance annotation from input
  --strand plus|both          cluster using plus or both strands (plus)
  --usersort                  indicate sequences not pre-sorted by length
  --minsize INT               minimum abundance (unoise only) (8)
  --unoise_alpha REAL         alpha parameter (unoise only) (2.0)
 Output
  --biomout FILENAME          filename for OTU table output in biom 1.0 format
  --centroids FILENAME        output centroid sequences to FASTA file
  --clusterout_id             add cluster id info to consout and profile files
  --clusterout_sort           order msaout, consout, profile by decr abundance
  --clusters STRING           output each cluster to a separate FASTA file
  --consout FILENAME          output cluster consensus sequences to FASTA file
  --lengthout                 write length annotation to output
  --mothur_shared_out FN      filename for OTU table output in mothur format
  --msaout FILENAME           output multiple seq. alignments to FASTA file
  --otutabout FILENAME        filename for OTU table output in classic format
  --profile FILENAME          output sequence profile of each cluster to file
  --relabel STRING            relabel centroids with this prefix string
  --relabel_keep              keep the old label after the new when relabelling
  --relabel_md5               relabel with md5 digest of normalized sequence
  --relabel_self              relabel with the sequence itself as label
  --relabel_sha1              relabel with sha1 digest of normalized sequence
  --sample STRING             add sample identifier annotation to output
  --sizeorder                 sort accepted centroids by abundance, AGC
  --sizeout                   write cluster abundances to centroid file
  --centroid_sizeout          write centroid abundances to centroid file
  --uc FILENAME               specify filename for UCLUST-like output
  --xlength                   strip length information in output
  --xsize                     strip abundance information in output

Convert SFF to FASTQ
  --sff_convert FILENAME      convert given SFF file to FASTQ format
 Parameters
  --sff_clip                  clip ends of sequences as indicated in file (no)
  --fastq_asciiout INT        FASTQ output quality score ASCII base char (33)
  --fastq_qmaxout INT         maximum base quality value for FASTQ output (41)
  --fastq_qminout INT         minimum base quality value for FASTQ output (0)
 Output
  --fastqout FILENAME         output converted sequences to given FASTQ file

Dereplication and rereplication
  --derep_fulllength FILENAME dereplicate sequences in the given FASTA file
  --derep_id FILENAME         dereplicate using both identifiers and sequences
  --derep_prefix FILENAME     dereplicate sequences in file based on prefixes
  --derep_smallmem FILENAME   dereplicate sequences in file using less memory
  --fastx_uniques FILENAME    dereplicate sequences in the FASTA/FASTQ file
  --rereplicate FILENAME      rereplicate sequences in the given FASTA file
 Parameters
  --maxuniquesize INT         maximum abundance for output from dereplication
  --minuniquesize INT         minimum abundance for output from dereplication
  --sizein                    propagate abundance annotation from input
  --strand plus|both          dereplicate plus or both strands (plus)
 Output
  --fastq_ascii INT           FASTQ input quality score ASCII base char (33)
  --fastq_qmax INT            maximum base quality value for FASTQ input (41)
  --fastq_qmaxout INT         maximum base quality value for FASTQ output (41)
  --fastq_qmin INT            minimum base quality value for FASTQ input (0)
  --fastq_qminout INT         minimum base quality value for FASTQ output (0)
  --fastq_qout_max            keep the highest quality score in each position
  --fastaout FILENAME         output FASTA file (for fastx_uniques)
  --fastqout FILENAME         output FASTQ file (for fastx_uniques)
  --lengthout                 write length annotation to output
  --output FILENAME           output FASTA file (not for fastx_uniques)
  --relabel STRING            relabel with this prefix string
  --relabel_keep              keep the old label after the new when relabelling
  --relabel_md5               relabel with md5 digest of normalized sequence
  --relabel_self              relabel with the sequence itself as label
  --relabel_sha1              relabel with sha1 digest of normalized sequence
  --sample STRING             add sample identifier annotation to output
  --sizeout                   write abundance annotation to output
  --tabbedout FILENAME        write cluster info to tsv file for fastx_uniques
  --topn INT                  output only n most abundant sequences after derep
  --uc FILENAME               filename for UCLUST-like dereplication output
  --xlength                   strip length information in output
  --xsize                     strip abundance information in derep output

FASTA to FASTQ conversion
  --fasta2fastq FILENAME      convert from FASTA to FASTQ, fake quality scores
 Parameters
  --fastq_asciiout INT        FASTQ output quality score ASCII base char (33)
  --fastq_qmaxout INT         fake quality score for FASTQ output (41)
 Output
  --fastqout FILENAME         FASTQ output filename for converted sequences

FASTQ format conversion
  --fastq_convert FILENAME    convert between FASTQ file formats
 Parameters
  --fastq_ascii INT           FASTQ input quality score ASCII base char (33)
  --fastq_asciiout INT        FASTQ output quality score ASCII base char (33)
  --fastq_qmax INT            maximum base quality value for FASTQ input (41)
  --fastq_qmaxout INT         maximum base quality value for FASTQ output (41)
  --fastq_qmin INT            minimum base quality value for FASTQ input (0)
  --fastq_qminout INT         minimum base quality value for FASTQ output (0)
 Output
  --fastqout FILENAME         FASTQ output filename for converted sequences

FASTQ format detection and quality analysis
  --fastq_chars FILENAME      analyse FASTQ file for version and quality range
 Parameters
  --fastq_tail INT            min length of tails to count for fastq_chars (4)

FASTQ quality statistics
  --fastq_stats FILENAME      report statistics on FASTQ file
  --fastq_eestats FILENAME    quality score and expected error statistics
  --fastq_eestats2 FILENAME   expected error and length cutoff statistics
 Parameters
  --ee_cutoffs REAL,...       fastq_eestats2 expected error cutoffs (0.5,1,2)
  --fastq_ascii INT           FASTQ input quality score ASCII base char (33)
  --fastq_qmax INT            maximum base quality value for FASTQ input (41)
  --fastq_qmin INT            minimum base quality value for FASTQ input (0)
  --length_cutoffs INT,INT,INT fastq_eestats2 length (min,max,incr) (50,*,50)
 Output
  --log FILENAME              output file for fastq_stats statistics
  --output FILENAME           output file for fastq_eestats(2) statistics

Masking (new)
  --fastx_mask FILENAME       mask sequences in the given FASTA or FASTQ file
 Parameters
  --fastq_ascii INT           FASTQ input quality score ASCII base char (33)
  --fastq_qmax INT            maximum base quality value for FASTQ input (41)
  --fastq_qmin INT            minimum base quality value for FASTQ input (0)
  --hardmask                  mask by replacing with N instead of lower case
  --max_unmasked_pct          max unmasked % of sequences to keep (100.0)
  --min_unmasked_pct          min unmasked % of sequences to keep (0.0)
  --qmask none|dust|soft      mask seqs with dust, soft or no method (dust)
 Output
  --fastaout FILENAME         output to specified FASTA file
  --fastqout FILENAME         output to specified FASTQ file

Masking (old)
  --maskfasta FILENAME        mask sequences in the given FASTA file
 Parameters
  --hardmask                  mask by replacing with N instead of lower case
  --qmask none|dust|soft      mask seqs with dust, soft or no method (dust)
 Output
  --output FILENAME           output to specified FASTA file

Orient sequences in forward or reverse direction
  --orient FILENAME           orient sequences in given FASTA/FASTQ file
 Data
  --db FILENAME               database of sequences in correct orientation
  --dbmask none|dust|soft     mask db seqs with dust, soft or no method (dust)
  --qmask none|dust|soft      mask query with dust, soft or no method (dust)
  --wordlength INT            length of words used for matching 3-15 (12)
 Output
  --fastaout FILENAME         FASTA output filename for oriented sequences
  --fastqout FILENAME         FASTQ output filenamr for oriented sequences
  --notmatched FILENAME       output filename for undetermined sequences
  --tabbedout FILENAME        output filename for result information

Paired-end reads joining
  --fastq_join FILENAME       join paired-end reads into one sequence with gap
 Data
  --reverse FILENAME          specify FASTQ file with reverse reads
  --join_padgap STRING        sequence string used for padding (NNNNNNNN)
  --join_padgapq STRING       quality string used for padding (IIIIIIII)
 Output
  --fastaout FILENAME         FASTA output filename for joined sequences
  --fastqout FILENAME         FASTQ output filename for joined sequences

Paired-end reads synchronizing
  --fastx_syncpairs FILENAME  reorder paired reads to match across both files
 Data
  --reverse FILENAME          specify FASTA/FASTQ file with reverse reads
 Parameters
  --read_separators STRING    characters preceding the mate number 1 or 2 (/)
 Output
  --fastaout FILENAME         FASTA filename for synced forward reads
  --fastaout_rev FILENAME     FASTA filename for synced reverse reads
  --fastaout_orphans FN       FASTA filename for unpaired forward reads
  --fastaout_orphans_rev FN   FASTA filename for unpaired reverse reads
  --fastqout FILENAME         FASTQ filename for synced forward reads
  --fastqout_rev FILENAME     FASTQ filename for synced reverse reads
  --fastqout_orphans FN       FASTQ filename for unpaired forward reads
  --fastqout_orphans_rev FN   FASTQ filename for unpaired reverse reads

Paired-end reads merging
  --fastq_mergepairs FILENAME merge paired-end reads into one sequence
 Data
  --reverse FILENAME          specify FASTQ file with reverse reads
 Parameters
  --fastq_allowmergestagger   allow merging of staggered reads
  --fastq_ascii INT           FASTQ input quality score ASCII base char (33)
  --fastq_maxdiffpct REAL     maximum percentage diff. bases in overlap (100.0)
  --fastq_maxdiffs INT        maximum number of different bases in overlap (10)
  --fastq_maxee REAL          maximum expected error value for merged sequence
  --fastq_maxmergelen         maximum length of entire merged sequence
  --fastq_maxns INT           maximum number of N's
  --fastq_minlen INT          minimum input read length after truncation (1)
  --fastq_minmergelen         minimum length of entire merged sequence
  --fastq_minovlen            minimum length of overlap between reads (10)
  --fastq_nostagger           disallow merging of staggered reads (default)
  --fastq_qmax INT            maximum base quality value for FASTQ input (41)
  --fastq_qmaxout INT         maximum base quality value for FASTQ output (41)
  --fastq_qmin INT            minimum base quality value for FASTQ input (0)
  --fastq_qminout INT         minimum base quality value for FASTQ output (0)
  --fastq_truncqual INT       base quality value for truncation
 Output
  --eetabbedout FILENAME      output error statistics to specified file
  --fastaout FILENAME         FASTA output filename for merged sequences
  --fastaout_notmerged_fwd FN FASTA filename for non-merged forward sequences
  --fastaout_notmerged_rev FN FASTA filename for non-merged reverse sequences
  --fastq_eeout               include expected errors (ee) in FASTQ output
  --fastqout FILENAME         FASTQ output filename for merged sequences
  --fastqout_notmerged_fwd FN FASTQ filename for non-merged forward sequences
  --fastqout_notmerged_rev FN FASTQ filename for non-merged reverse sequences
  --label_suffix STRING       suffix to append to label of merged sequences
  --xee                       remove expected errors (ee) info from output

Pairwise alignment
  --allpairs_global FILENAME  perform global alignment of all sequence pairs
 Output (most searching options also apply)
  --alnout FILENAME           filename for human-readable alignment output
  --acceptall                 output all pairwise alignments

Restriction site cutting
  --cut FILENAME              filename of FASTA formatted input sequences
 Parameters
  --cut_pattern STRING        pattern to match with ^ and _ at cut sites
 Output
  --fastaout FILENAME         FASTA filename for fragments on forward strand
  --fastaout_rev FILENAME     FASTA filename for fragments on reverse strand
  --fastaout_discarded FN     FASTA filename for non-matching sequences
  --fastaout_discarded_rev FN FASTA filename for non-matching, reverse compl.

Reverse complementation
  --fastx_revcomp FILENAME    reverse-complement seqs in FASTA or FASTQ file
 Parameters
  --fastq_ascii INT           FASTQ input quality score ASCII base char (33)
  --fastq_qmax INT            maximum base quality value for FASTQ input (41)
  --fastq_qmin INT            minimum base quality value for FASTQ input (0)
 Output
  --fastaout FILENAME         FASTA output filename
  --fastqout FILENAME         FASTQ output filename
  --label_suffix STRING       label to append to identifier in the output

Searching
  --search_exact FILENAME     filename of queries for exact match search
  --usearch_global FILENAME   filename of queries for global alignment search
 Data
  --db FILENAME               FASTA or UDB database (only FASTA for search_exact)
 Parameters
  --dbmask none|dust|soft     mask db with dust, soft or no method (dust)
  --fulldp                    full dynamic programming alignment (always on)
  --gapext STRING             penalties for gap extension (2I/1E)
  --gapopen STRING            penalties for gap opening (20I/2E)
  --hardmask                  mask by replacing with N instead of lower case
  --id REAL                   reject if identity lower
  --iddef INT                 id definition, 0-4=CD-HIT,all,int,MBL,BLAST (2)
  --idprefix INT              reject if first n nucleotides do not match
  --idsuffix INT              reject if last n nucleotides do not match
  --lca_cutoff REAL           fraction of matching hits required for LCA (1.0)
  --leftjust                  reject if terminal gaps at alignment left end
  --match INT                 score for match (2)
  --maxaccepts INT            number of hits to accept and show per strand (1)
  --maxdiffs INT              reject if more substitutions or indels
  --maxgaps INT               reject if more indels
  --maxhits INT               maximum number of hits to show (unlimited)
  --maxid REAL                reject if identity higher
  --maxqsize INT              reject if query abundance larger
  --maxqt REAL                reject if query/target length ratio higher
  --maxrejects INT            number of non-matching hits to consider (32)
  --maxsizeratio REAL         reject if query/target abundance ratio higher
  --maxsl REAL                reject if shorter/longer length ratio higher
  --maxsubs INT               reject if more substitutions
  --mid REAL                  reject if percent identity lower, ignoring gaps
  --mincols INT               reject if alignment length shorter
  --minqt REAL                reject if query/target length ratio lower
  --minsizeratio REAL         reject if query/target abundance ratio lower
  --minsl REAL                reject if shorter/longer length ratio lower
  --mintsize INT              reject if target abundance lower
  --minwordmatches INT        minimum number of word matches required (12)
  --mismatch INT              score for mismatch (-4)
  --n_mismatch                consider aligning with N's as mismatches
  --pattern STRING            option is ignored
  --qmask none|dust|soft      mask query with dust, soft or no method (dust)
  --query_cov REAL            reject if fraction of query seq. aligned lower
  --rightjust                 reject if terminal gaps at alignment right end
  --sizein                    propagate abundance annotation from input
  --self                      reject if labels identical
  --selfid                    reject if sequences identical
  --slots INT                 option is ignored
  --strand plus|both          search plus or both strands (plus)
  --target_cov REAL           reject if fraction of target seq. aligned lower
  --weak_id REAL              include aligned hits with >= id; continue search
  --wordlength INT            length of words for database index 3-15 (8)
 Output
  --alnout FILENAME           filename for human-readable alignment output
  --biomout FILENAME          filename for OTU table output in biom 1.0 format
  --blast6out FILENAME        filename for blast-like tab-separated output
  --dbmatched FILENAME        FASTA file for matching database sequences
  --dbnotmatched FILENAME     FASTA file for non-matching database sequences
  --fastapairs FILENAME       FASTA file with pairs of query and target
  --lcaout FILENAME           output LCA of matching sequences to file
  --lengthout                 write length annotation to output
  --matched FILENAME          FASTA file for matching query sequences
  --mothur_shared_out FN      filename for OTU table output in mothur format
  --notmatched FILENAME       FASTA file for non-matching query sequences
  --otutabout FILENAME        filename for OTU table output in classic format
  --output_no_hits            output non-matching queries to output files
  --rowlen INT                width of alignment lines in alnout output (64)
  --samheader                 include a header in the SAM output file
  --samout FILENAME           filename for SAM format output
  --sample STRING             add sample identifier annotation to output
  --sizeout                   write abundance annotation to dbmatched file
  --top_hits_only             output only hits with identity equal to the best
  --uc FILENAME               filename for UCLUST-like output
  --uc_allhits                show all, not just top hit with uc output
  --userfields STRING         fields to output in userout file
  --userout FILENAME          filename for user-defined tab-separated output
  --xlength                   strip length information in output

Sequence retrieval
  --fastx_getseq FILENAME     extract one sequence by label from FASTA/FASTQ
  --fastx_getseqs FILENAME    extract sequences by label from FASTA/FASTQ file
  --fastx_getsubseq FILENAME  extract a subsequence by label and position
 Parameters
  --fastq_ascii INT           FASTQ input quality score ASCII base char (33)
  --fastq_qmax INT            maximum base quality value for FASTQ input (41)
  --fastq_qmin INT            minimum base quality value for FASTQ input (0)
  --label STRING              label to match, by default the whole header
  --label_field STRING        field for word matching, for --fastx_getseqs
  --label_substr_match        allow the label to match anywhere in the header
  --label_word STRING         case-sensitive word, for --fastx_getseqs
  --label_words FILENAME      file of words to match, for --fastx_getseqs
  --labels FILENAME           file of labels to match, for --fastx_getseqs
  --sizein                    consider abundance info from input, do not ignore
  --subseq_end INT            end position, 1-based, for --fastx_getsubseq
  --subseq_start INT          start position, 1-based, for --fastx_getsubseq
 Output
  --fastaout FILENAME         FASTA output filename
  --fastqout FILENAME         FASTQ output filename
  --label_suffix STRING       label to append to identifier in the output
  --lengthout                 write length annotation to output
  --notmatched FILENAME       FASTA file for the sequences not extracted
  --notmatchedfq FILENAME     FASTQ file for the sequences not extracted
  --relabel STRING            relabel sequences with this prefix string
  --relabel_keep              keep the old label after the new when relabelling
  --relabel_md5               relabel with md5 digest of normalized sequence
  --relabel_self              relabel with the sequence itself as label
  --relabel_sha1              relabel with sha1 digest of normalized sequence
  --sample STRING             add sample identifier annotation to output
  --sizeout                   write abundance annotation to output
  --xlength                   strip length information in output
  --xsize                     strip abundance information in output

Sorting, shuffling and scrambling
  --scramble FILENAME         randomize nucleotide order within each sequence
  --shuffle FILENAME          shuffle order of sequences in FASTA file randomly
  --sortbylength FILENAME     sort sequences by length in given FASTA file
  --sortbysize FILENAME       abundance sort sequences in given FASTA file
 Parameters
  --fastq_ascii INT           FASTQ input quality score ASCII base char (33)
  --fastq_qmax INT            maximum base quality value for FASTQ input (41)
  --fastq_qmin INT            minimum base quality value for FASTQ input (0)
  --maxsize INT               maximum abundance for sortbysize
  --minsize INT               minimum abundance for sortbysize
  --randseed INT              seed for PRNG, zero to use random data source (0)
  --scramble_kmer INT         preserve counts of words up to this size 1-9 (1)
  --sizein                    propagate abundance annotation from input
 Output
  --fastaout FILENAME         FASTA output filename (for scramble)
  --fastqout FILENAME         FASTQ output filename (for scramble)
  --label_suffix STRING       label to append to identifier in the output
  --lengthout                 write length annotation to output
  --output FILENAME           output to specified FASTA file (not for scramble)
  --relabel STRING            relabel sequences with this prefix string
  --relabel_keep              keep the old label after the new when relabelling
  --relabel_md5               relabel with md5 digest of normalized sequence
  --relabel_self              relabel with the sequence itself as label
  --relabel_sha1              relabel with sha1 digest of normalized sequence
  --sample STRING             add sample identifier annotation to output
  --sizeout                   include abundance information when relabelling
  --topn INT                  output just first n sequences (not for scramble)
  --xlength                   strip length information in output
  --xsize                     strip abundance information in output

Subsampling
  --fastx_subsample FILENAME  subsample sequences from given FASTA/FASTQ file
 Parameters
  --allow_fewer               accept fewer reads than --sample_size, do not fail
  --fastq_ascii INT           FASTQ input quality score ASCII base char (33)
  --fastq_qmax INT            maximum base quality value for FASTQ input (41)
  --fastq_qmin INT            minimum base quality value for FASTQ input (0)
  --randseed INT              seed for PRNG, zero to use random data source (0)
  --sample_pct REAL           sampling percentage between 0.0 and 100.0
  --sample_size INT           sampling size
  --sizein                    consider abundance info from input, do not ignore
 Output
  --fastaout FILENAME         output subsampled sequences to FASTA file
  --fastaout_discarded FILE   output non-subsampled sequences to FASTA file
  --fastqout FILENAME         output subsampled sequences to FASTQ file
  --fastqout_discarded        output non-subsampled sequences to FASTQ file
  --lengthout                 write length annotation to output
  --relabel STRING            relabel sequences with this prefix string
  --relabel_keep              keep the old label after the new when relabelling
  --relabel_md5               relabel with md5 digest of normalized sequence
  --relabel_self              relabel with the sequence itself as label
  --relabel_sha1              relabel with sha1 digest of normalized sequence
  --sample STRING             add sample identifier annotation to output
  --sizeout                   update abundance information in output
  --xlength                   strip length information in output
  --xsize                     strip abundance information in output

Taxonomic classification
  --sintax FILENAME           classify sequences in given FASTA/FASTQ file
 Parameters
  --db FILENAME               taxonomic reference db in given FASTA or UDB file
  --randseed INT              seed for PRNG, zero to use random data source (0)
  --sintax_cutoff REAL        confidence value cutoff level (0.0)
  --sintax_random             use random sequence, not shortest, if equal match
 Output
  --tabbedout FILENAME        write results to given tab-delimited file

Trimming and filtering
  --fastx_filter FILENAME     trim and filter sequences in FASTA/FASTQ file
  --fastq_filter FILENAME     trim and filter sequences in FASTQ file
  --reverse FILENAME          FASTQ file with other end of paired-end reads
 Parameters
  --fastq_ascii INT           FASTQ input quality score ASCII base char (33)
  --fastq_maxee REAL          discard if expected error value is higher
  --fastq_maxee_rate REAL     discard if expected error rate is higher
  --fastq_maxlen INT          discard if length of sequence is longer
  --fastq_maxns INT           discard if number of N's is higher
  --fastq_minlen INT          discard if length of sequence is shorter
  --fastq_minqual INT         discard if any base quality value lower (0)
  --fastq_qmax INT            maximum base quality value for FASTQ input (41)
  --fastq_qmin INT            minimum base quality value for FASTQ input (0)
  --fastq_stripleft INT       delete given number of bases from the 5' end
  --fastq_stripright INT      delete given number of bases from the 3' end
  --fastq_truncee REAL        truncate to given maximum expected error
  --fastq_truncee_rate REAL   truncate to given maximum expected error rate
  --fastq_trunclen INT        truncate to given length (discard if shorter)
  --fastq_trunclen_keep INT   truncate to given length (keep if shorter)
  --fastq_truncqual INT       truncate to given minimum base quality
  --maxsize INT               discard if abundance of sequence is above
  --minsize INT               discard if abundance of sequence is below
 Output
  --eeout                     include expected errors in output
  --fastaout FN               FASTA filename for passed sequences
  --fastaout_discarded FN     FASTA filename for discarded sequences
  --fastaout_discarded_rev FN FASTA filename for discarded reverse sequences
  --fastaout_rev FN           FASTA filename for passed reverse sequences
  --fastqout FN               FASTQ filename for passed sequences
  --fastqout_discarded FN     FASTQ filename for discarded sequences
  --fastqout_discarded_rev FN FASTQ filename for discarded reverse sequences
  --fastqout_rev FN           FASTQ filename for passed reverse sequences
  --lengthout                 write length annotation to output
  --relabel STRING            relabel filtered sequences with given prefix
  --relabel_keep              keep the old label after the new when relabelling
  --relabel_md5               relabel filtered sequences with md5 digest
  --relabel_self              relabel with the sequence itself as label
  --relabel_sha1              relabel filtered sequences with sha1 digest
  --sample STRING             add sample identifier annotation to output
  --sizeout                   include abundance information when relabelling
  --xee                       remove expected errors (ee) info from output
  --xlength                   strip length information in output
  --xsize                     strip abundance information in output

UDB files
  --makeudb_usearch FILENAME  make UDB file from given FASTA file
  --udb2fasta FILENAME        output FASTA file from given UDB file
  --udbinfo FILENAME          show information about UDB file
  --udbstats FILENAME         report statistics about indexed words in UDB file
 Parameters
  --dbmask none|dust|soft     mask db with dust, soft or no method (dust)
  --hardmask                  mask by replacing with N instead of lower case
  --wordlength INT            length of words for database index 3-15 (8)
 Output
  --output FILENAME           UDB or FASTA output file
