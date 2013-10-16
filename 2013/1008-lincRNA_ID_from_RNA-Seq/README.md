Bring Your Own Bioinformatics 10-08-13
Unannotated transcripts and long intergenic noncoding RNA identification using RNAcode and CPAT
by Kevin Nyberg

See BYOB_10-8-13.pptx for info behind RNAcode and CPAT, including my test runs on annotated Drosophila pseudoobscura transcripts.

<<<RNAcode>>>
Get RNAcode here: http://wash.github.io/rnacode/

To run a test, make sure you have the following files:
RNAcode_BYOB.sh
TCONS_00000047_4species.aln
TCONS_00001351_4species.aln
TCONS_00001358_4species.aln
TCONS_00001369_4species.aln

Run
> bash RNAcode_BYOB.sh
Output file is RNAcode_BYOB_out.txt
If p-value < 0.05, then assumed to be protein-coding.
If not info is given (and no error), assume to be noncoding.


<<<Coding Potential Assessment Tool (CPAT)>>>
Get CPAT here: http://rna-cpat.sourceforge.net/

To run a test, make sure you have the following files:
cpat.py
BYOB.fasta
fly_Hexame.tab
fly_train.RData

Run
> python cpat.py --gene BYOB.fasta --outfile BYOB_CPAT_out --hex fly_Hexame.tab --logitModel fly_train.Rdata
Protein coding probabilities are in the right-most column. Cutoff for D. melanogaster training set is 0.39. Any probability above 0.39 can be assumed to be protein coding. Any probability below 0.39 can be assumed to be noncoding.