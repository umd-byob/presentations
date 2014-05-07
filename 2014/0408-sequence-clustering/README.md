Sequence Clustering
===================
Ted Gibbons

Understanding the OrthoMCL pipeline
-----------------------------------
The [OrthoMCL](http://orthomcl.org/orthomcl/) pipeline was introduced over a
decade ago and remains one of the most popular approaches for clustering
(protein) sequences.  Several variants of the pipeline have since been
published, but the major steps remain unchanged.  In this first session, I will
explain each step of the OrthoMCL pipeline in detail.

Effects of graph weighting parameters and inflation values on clustering
------------------------------------------------------------------------
The primary differences between the various flavors of the OrthoMCL pipeline
are the metrics used to weight the graph and/or MCL inflation parameter
value(s).  The effects of these differences can be very difficult to understand
and the corresponding publications provide very little, if any, helpful
information.  I have therefore systematically explored the effects of these
parameters on clustering a subset of sequences from the [euKaryotic Orthologous
Groups (KOG) database](http://www.ncbi.nlm.nih.gov/COG/), simulating the
fragmentation that commonly results from modern high-throughput sequencing
projects.
