##Quality assurance for WGS/RNA-seq data with PRINSEQ

### Introduction
[PRINSEQ](http://prinseq.sourceforge.net/manual.html) is a tool for summarizing, and filtering next-gen sequencing data.

### Quality control
1. Length
2. Base qualities
3. Duplicates

### Tutorial
[PRINSEQ](http://prinseq.sourceforge.net/manual.html) is available as a [standalone version](http://sourceforge.net/projects/prinseq/files/) (perl script) or as a web service.


* Download the example RNA-seq data.
* Run PRINSEQ with b

```
  perl $PRINSEQ_DIR/prinseq-lite.pl -fastq SRR069556.fastq \
  -min_len 20 \
  -trim_qual_right 11 \
  -min_qual_mean 20 \
  -ns_max_n 1 \
  -out_format 3 \
  -graph_data SRR069556_graph.gd \
  -log log.txt \
  -out_good SRR069556_good.fastq \
  -out_bad SRR069556_bad.fastq
```
* Upload **SRR069556_graph.gd** to [PRINSEQ webserver](http://edwards.sdsu.edu/cgi-bin/prinseq/prinseq.cgi?report=1).
* Look at [figures](http://edwards.sdsu.edu/cgi-bin/prinseq/tmp/1382390222/SRR069556.fastq_graph.gd.html) to determine reasonable parameter cutoffs.
* Rerun PRINSEQ.
 
```
  perl $PRINSEQ_DIR/prinseq-lite.pl -fastq SRR069556.fastq \
  -min_len 20 \
  -trim_qual_right 11 \
  -min_qual_mean 20 \
  -ns_max_n 1 \
  -derep 235 \
  -lc_method dust \ 
  -lc_threshold 70 \
  -trim_tail_left 5 \
  -trim_tail_right 5 \
  -out_format 3 \
  -graph_data SRR069556_try2_graph.gd \
  -log log.txt \
  -out_good SRR069556_try2_good.fastq \
  -out_bad SRR069556_try2_bad.fastq
```
