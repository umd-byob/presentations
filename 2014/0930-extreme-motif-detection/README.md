An EXTREME Approach to Motif Detection
======================================

<a href='mailto:khughitt@umd.edu'>Keith Hughitt</a> (<time>2014-09-29</time>)

[view source]()

Introduction
------------

### Overview

The purpose of this guide is to share some of my experience using one of the
[numerous](http://www.biologydirect.com/content/1/1/11) motif detection tools
available, [EXTREME](https://github.com/uci-cbcl/EXTREME).

In addition to describing some basic tips for working with EXTREME itself, I
will provide some examples of how I was able to incorporate it into a (still
developing) pipeline for detecting motifs in the 5' and 3'UTRs of a collection
of co-expressed genes.

But first, some motivation...

### Background

![T. brucei](images/Trypanosoma_parasiteblood_cells_ger.jpg)
(source: [Deutsches Elektronen-Synchrotron](http://www.desy.de/information__services/press/pressreleases/2012/pr_291112/index_eng.html))

[*Trypanosomatids*](http://en.wikipedia.org/wiki/Trypanosomatid) are an order
of single-cell eukaryotic parasites, a number of which cause lots of problems
for *H. sapiens*. Some of the more well-known members of the group include *T.
brucei* (pictured above, causitive agent of [sleeping
sickness](http://en.wikipedia.org/wiki/African_trypanosomiasis)), *T. cruzi*
(causitive agent of [Chagas disease](http://en.wikipedia.org/wiki/Chagas_disease)) and *Leishmania major*
(causitive agent of [Leishmaniasis](http://en.wikipedia.org/wiki/Leishmaniasis)).

There is much that is still unknown about these early-branching eukaryotes. The
characteristic that relates to today's discussion, however, is the their
regulation of transcription.

Instead of transcribing genes individually, thus allowing control of expression
levels of inidivual genes, trypanosome genomes include long strings of
similar-stranded genes (polycistronic transcriptional units, or PTUs) which are
transcribed together. The polycistronic mRNAs are then simultaneously
trans-spliced and polyadenylated, resulting in individual processed mRNAs.

![polycistronic transcription](images/embj7594407-fig-0002-m.jpg)
(Clayton, 2002)

Rather than regulating expression at the transcriptional level, it is believed
that most of the regulation occurs at the post-transcriptional level. One
possible scenario (the current favored hypothesis) is that the regulation
occurs via binding of RNA binding proteins in the (primary 3'-) UTRs of genes,
impacting, perhaps, stability or translational efficiency. The problem is,
that, while there has been some evidence for this, no one has been able to
precisely describe the regulation of large numbers of genes via this
mechanism in any of the Trypanosomes.

If the mechanism of regulation is via RNA binding binding in the 3'UTRs, then
their should be some signal(s) being bound.

![utr binding signals](images/motivation_1.png)

A number of people have looked for them (including our lab), but so far the
results are still not completely satisfying.

Can we do better?

Methods
-------

The basic approach one might use to answer this question is to cluster genes by
their expression profiles, and then scan the UTRs of each cluster for common
(enriched) motifs.

### EXTREME

...

### Example data

For demonstration purposes, I have included a sets of sequences corresponding
(roughly) to the 3'UTRs of one cluster of co-expressed genes in *L. major*. The
sequences were extracted from the *L. major Friedlin* genome ([TriTrypDB
release 8.0](http://tritrypdb.org/common/downloads/release-8.0/LmajorFriedlin/fasta/data/)).

The file is located in the `input/` directory and has the creative filename,
`cluster1.fasta`.

I will save the discussion on the clustering approach for another day, but,
given a set of expression profiles your species of interest, you could achieve
some basic clustering using something like kmeans clustering, e.g.:

```r
library(reshape2)
library(ggplot2)

# Fake data (don't try this at home...)
# cluster 1
set.seed(1)

# 5 x 10
seed1 = seq(40, 58, by=2)
cluster1 = t(matrix(rep(seed1, 5), 10)) + 
             matrix(rnorm(50, mean=3, sd=1), ncol=10)

# 15 x 10
seed2 = c(seq(50, 42, by=-1.5), seq(44, 47, by=1))
cluster2 = t(matrix(rep(seed2, 15), 10)) + matrix(rnorm(150, mean=5, sd=1), ncol=10)

mat = rbind(cluster1, cluster2)

clusters = kmeans(mat, 2)

long_dat = melt(mat)
colnames(long_dat) = c('id', 'time', 'expr')
long_dat$cluster = clusters$cluster 
ggplot(long_dat, aes(time, expr, group=id, color=cluster)) + geom_line()
```

### Extracting UTR sequences

(Will come back to this if time permits)

### Using EXTREME to detect motifs in the sequences

Example run:

```sh
EXTREME_DIR=/path/to/extreme
python $EXTREME_DIR/src/fasta-dinucleotide-shuffle.py -f input/cluster1.fasta > input/cluster1_shuffled.fasta
python $EXTREME_DIR/src/GappedKmerSearch.py -l 5 -ming 0 -maxg 10 -minsites 4 cluster1.fasta GM12878_NRSF_ChIP_shuffled.fasta cluster1.words
perl $EXTREME_DIR/src/run_consensus_clusering_using_wm.pl cluster1.words 0.3
python $EXTREME_DIR/src/Consensus2PWM.py cluster1.words.cluster.aln cluster1.wm
```

See the docs on the [EXTREME github repo](https://github.com/uci-cbcl/EXTREME)
for a more detailed explanation of the parameters available at each step of the
pipeline.

### Filtering out repeat regions with RepeatMasker

### Reading the resulting motifs back into R

### Counting the number of motif instances in a given sequence

References
----------

- Quang, D., & Xie, X. (2014). EXTREME: an online EM algorithm for motif
discovery. Bioinformatics (Oxford, England), 30(12), 1667–73.
doi:10.1093/bioinformatics/btu093
- Clayton, C. E. (2002). Life without transcriptional control ? From fly to man
and back again. The EMBO Journal, 21(8),
1881–1888.
