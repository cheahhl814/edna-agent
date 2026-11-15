Usage: ./NGmerge {-1 <file> -2 <file> -o <file>}  [optional arguments]
Required arguments:
  -1  <file>       Input FASTQ file with reads from forward direction
  -2  <file>       Input FASTQ file with reads from reverse direction
  -o  <file>       Output FASTQ file(s):
                   - in 'stitch' mode (def.), the file of merged reads
                   - in 'adapter-removal' mode (-a) or 'validate' mode (-r),
                     the output files will be <file>_1.fastq and <file>_2.fastq
Alignment parameters:
  -m  <int>        Minimum overlap of the paired-end reads (def. 20)
  -p  <float>      Mismatches to allow in the overlapped region
                     (a fraction of the overlap length; def. 0.10)
  -a               Use 'adapter-removal' mode (also sets -d option)
  -d               Option to check for dovetailing (with 3' overhangs)
  -e  <int>        Minimum overlap of dovetailed alignments (def. 50)
  -s               Option to produce shortest stitched read
  -r               Use 'validate' mode (skip alignment)
I/O options:
  -l  <file>       Log file for stitching results of each read pair
  -f  <file>       FASTQ files for reads that failed stitching
                     (output as <file>_1.fastq and <file>_2.fastq)
  -c  <file>       Log file for dovetailed reads (adapter sequences)
  -j  <file>       Log file for formatted alignments of merged reads
  -z/-y            Option to gzip (-z) or not (-y) FASTQ output(s)
  -i               Option to produce interleaved FASTQ output(s)
  -w  <file>       Use given error profile for merged qual scores
  -g               Use 'fastq-join' method for merged qual scores
  -q  <int>        FASTQ quality offset (def. 33)
  -u  <int>        Maximum input quality score (0-based; def. 40)
  -t  <char>       Delimiter for headers of paired reads (def. ' ')
  -x  <int>        Minimum length of output reads (def. 1)
  -n  <int>        Number of threads to use (def. 1)
  -v               Option to print status updates/counts to stderr
