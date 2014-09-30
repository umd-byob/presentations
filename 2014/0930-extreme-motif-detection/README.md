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

[T. brucei](images/Trypanosoma_parasiteblood_cells_ger.jpg)
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

Rather than regulating expression at the transcriptional level, it is believed
that most of the regulation occurs at the post-transcriptional level. One
possible scenario (the current favored hypothesis) is that the regulation
occurs via binding of RNA binding proteins in the (primary 3'-) UTRs of genes,
impacting, perhaps, stability or translational efficiency. The problem is,
that, while there has been some evidence for this, no one has been able to
precisely describe the regulation of large numbers of genes in via this
mechanism in any of the Trypanosomes.

If the mechanism of regulation is via RNA binding binding in the 3'UTRs, then
their should be some signal(s) being bound.

A number of people have looked for them (including our lab), but so far the
results are still not completely satisfying.

Can we do better?
