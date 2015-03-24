##Getting started

###Installation
The installations of both RepeatMasker and RepeatModeler are fairly straight forward and easy to follow as described on their websites:
http://www.repeatmasker.org/RepeatModeler.html
http://www.repeatmasker.org/RMDownload.html

Both RepeatModeler and RepeatMasker require Perl (5.8+) and TandemRepeatFinder (http://tandem.bu.edu/trf/trf.html)

RepeatModeler requires RepeatMasker as well as RECON (http://www.repeatmasker.org/RECON-1.08.tar.gz) and RepeatScout (http://repeatscout.bioprojects.org/RepeatScout-1.0.5.tar.gz) 

In addition, each program requires a search engine from several options. I’ve found their modified version of NCBI Blast+ to work fine (http://www.repeatmasker.org/RMBlast.html).

Finally, you need you’ll need to install the RepBase RepeatMasker library available from http://www.girinst.org/. This requires registration, but is free. Specifically, you’ll want to download the “RepBase-derived RepeatMasker Libraries”. 
```bash
[bash]$  tar -zxvf repeatmaskerlibraries-20140131.tar.gz 
x Libraries/
x Libraries/RepeatMaskerLib.embl
x Libraries/RepeatAnnotationData.pm
x Libraries/README.html
x Libraries/taxonomy.dat
x Libraries/README
```
This `Libraries` directory can be moved into the RepeatMasker directory for installation or simply copy `RepeatMaskerLib.embl` to the `Libraries` directory in RepeatMasker. You can also convert this file into FASTA format which will be useful. Do this with the supplied Perl script in the RepeatMasker `util` directory:

```bash
[bash]$  perl /your_full_path_to_RepeatMasker/util/buildRMLibFromEMBL.pl RepeatMaskerLib.embl > RepeatMaskerLib.fasta
```
##Running RepeatModeler
If you are working with a well studied model organism such as human, mouse, or drosophila you can probably skip the step of running RepeatModeler to create a species specific repeat database. 

For example, a search of `melanogaster` in the RepBase library reveals many melanogaster specific repeats:
```bash
[bash]$ grep "melanogaster" RepeatMaskerLib.fasta
>PLACW_DM#DNA/P @Drosophila_melanogaster  [S:] RepbaseID: PLACW_DM
>Transib-N1_DM#DNA/CMC-Transib @Drosophila_melanogaster  [S:] RepbaseID: Transib-N1_DM
>HOBO#DNA/hAT-hobo @Drosophila_mauritiana @Drosophila_melanogaster @Drosophila_sechellia @Drosophila_simulans  [S:] RepbaseID: HOBO
>ROVER-I_DM#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: ROVER_DM
>ROVER-LTR_DM#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: ROVER_DM
>STALKER4_I#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: STALKER4_I
>STALKER4_LTR#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: STALKER4_LTR
>Transib5#DNA/CMC-Transib @Drosophila_melanogaster  [S:] RepbaseID: Transib5
>TAHRE#LINE/Jockey @Drosophila_melanogaster  [S:] RepbaseID: TAHRE
>FROGGER_I#LTR/Copia @Drosophila_melanogaster  [S:] RepbaseID: FROGGER_I
>FROGGER_LTR#LTR/Copia @Drosophila_melanogaster  [S:] RepbaseID: FROGGER_LTR
>QUASIMODO2-I_DM#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: QUASIMODO2-I_DM
>QUASIMODO2-LTR_DM#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: QUASIMODO2-LTR_DM
>Galileo_DM#DNA/P @Drosophila_melanogaster  [S:] RepbaseID: Galileo_DM
>Chimpo_LTR#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: Chimpo_LTR
>Chimpo_I#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: Chimpo_I
>Copia1-I_DM#LTR/Copia @Drosophila_melanogaster  [S:] RepbaseID: Copia1-I_DM
>Copia1-LTR_DM#LTR/Copia @Drosophila_melanogaster  [S:] RepbaseID: Copia1-LTR_DM
>Gypsy1-LTR_DM#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: Gypsy1-LTR_DM
>Gypsy2-LTR_DM#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: Gypsy2-LTR_DM
>Gypsy1-I_DM#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: Gypsy1-I_DM
>Gypsy2-I_DM#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: Gypsy2-I_DM
>Bica_LTR#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: Bica_LTR
>Chouto_I#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: Chouto_I
>Bica_I#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: Bica_I
>Chouto_LTR#LTR/Gypsy @Drosophila_melanogaster  [S:] RepbaseID: Chouto_LTR
>SAR2_DM#Satellite @Drosophila_melanogaster  [S:] RepbaseID: SAR2_DM
```
Whereas, a search for something less studied, reveals fewer specific repeats:
```bash
[bash]$ grep "Cichlidae" RepeatMaskerLib.fasta
>SINE2AFC#SINE @Cichlidae  [S:] RepbaseID: SINE2AFC
>RTE-1_AFC#LINE/RTE-BovB @Cichlidae  [S:] RepbaseID: RTE-1_AFC
>RTE-2_AFC#LINE/RTE-BovB @Cichlidae  [S:] RepbaseID: RTE-2_AFC
>REX1-2_AFC#LINE/Rex-Babar @Cichlidae  [S:] RepbaseID: REX1-2_AFC
>REX1-1_AFC#LINE/Rex-Babar @Cichlidae  [S:] RepbaseID: REX1-1_AFC
>REX1-4_AFC#LINE/Rex-Babar @Cichlidae  [S:] RepbaseID: REX1-4_AFC
>REX1-3_AFC#LINE/Rex-Babar @Cichlidae  [S:] RepbaseID: REX1-3_AFC
>Penelope-1_AFC#LINE/Penelope @Cichlidae  [S:] RepbaseID: Penelope-1_AFC
>L1-1_AFC#LINE/L1 @Cichlidae  [S:] RepbaseID: L1-1_AFC
>SINE2-1_AFC#SINE/tRNA-Core @Cichlidae  [S:] RepbaseID: SINE2-1_AFC
>SINE3_AFC#SINE/Mermaid @Cichlidae  [S:] RepbaseID: SINE3_AFC
```
In cases where you are working with a genome that is less studied, you can run RepeatModeler first to identify de-novo repeat families in your species of interest and create a species-specific repeat library. 

##Running RepeatModeler

The first step is to run the BuildDatabase program:
```bash
[bash]$  perl /your_full_path_to_RepeatModeler/BuildDatabase -name my_cool_genome.repeat_modeler -engine ncbi -batch repeat_modeler.batch_file
```
This batch file is a simple text file that should have a line with the full path to the fasta file of the genome you would like to run RepeatModeler on. Or if you have multiple fasta files, one file per line.

In this case, since I specified `-engine ncbi`, this BuildDatabase step simply builds a NCBI Blast database of the specified fasta file(s). If you already have an NCBI Blast database for this fasta file, you can probably skip this step. 

The next step is to run the actual RepeatModeler program:
```bash
[bash]$  perl /your_full_path_to_RepeatModeler/RepeatModeler -database my_cool_genome.repeat_modeler -engine ncbi -pa 7
```
There aren’t a whole lot of options to this program, just the engine `-engine` choice and the number of processors `-pa`. In this case, I specified 7 processors for BLAST and left 1 for the RepeatModeler script.

##RepeatModeler output

By default, RepeatModeler will create an output directory in your working directory with a unique name like `RM_8872.WedFeb251418042015`, corresponding to the process id and the time stamp of when you ran it. The output looks something like this:
```bash
[bash]$ ls -lh RM_8872.WedFeb251418042015/
total 88M
-rw-rw-r-- 1 conte conte 1008K Mar  1 02:11 consensi.fa
-rw-rw-r-- 1 conte conte  1.1M Mar  1 03:28 consensi.fa.classified
-rw-rw-r-- 1 conte conte 1023K Mar  1 02:12 consensi.fa.masked
drwxrwxr-x 2 conte conte  156K Feb 25 18:07 round-1
drwxrwxr-x 7 conte conte   12K Feb 25 18:20 round-2
drwxrwxr-x 7 conte conte   36K Feb 25 19:16 round-3
drwxrwxr-x 7 conte conte  108K Feb 25 23:59 round-4
drwxrwxr-x 7 conte conte  332K Feb 27 06:27 round-5
drwxrwxr-x 7 conte conte  332K Mar  1 02:11 round-6
```
The three `consensi.fa*` files are all fasta files of the consensus sequences of repeats that RepeatModeler detected and the `round-*` directories contain the output files from running RepeatScout and RECON. You’ll want to use the **consensi.fa.classified** as it is a fasta file formatted for RepeatMasker like the RepBase fasta file shown before:

```bash
[bash]$ head consensi.fa.classified 
>rnd-1_family-220#LINE/Rex-Babar ( RepeatScout Family Size = 132, Final Multiple Alignment Size = 100, Localized to 504 out of 528 contigs )
TATACTATATATATATATATATATAATGTTCTTCCTCTACACCCCCCCCC
AATTTTTGCACATGTCGAGGAGCGTGTCAGGCTACATTTCACTGCGTGTC
GTACTGTGTATAACTATGCACGTGACAAATAAAGAACCTTGAACCTTGAA
CCTT
>rnd-1_family-29#DNA ( RepeatScout Family Size = 418, Final Multiple Alignment Size = 100, Localized to 504 out of 528 contigs )
TAGTTCTGATTAGCGTCACCGCTGTCTCGGTGGAGTTTAATAAACTCGGC
CGTCTGCTCCTTGCTATCTAAAATATAACCGGACACTGGCGTAAATTCTC
GACCGTCTCATACTTCTGTTTAATCAGTTTTCTGTTTGACGTTTAGTCAG
CTGTGTGAAAACCAAGGAGGAACCCACCCGGGGGATTAATAAAGTTTTAT
```
Repbase provides a tool for submitting sequences to RepBase:
http://www.girinst.org/downloads/software/RepbaseSubmitter/
I haven’t tried doing this yet. If anyone does, please report back and I can update this. 

###Combining repeat libraries (optional)
If you are working with a species that has several repeat families already annotated in the RepBase library, you may want to combine the new RepeatModeler generated sequences with the RepBase library. This was the case for me as there were several well-annotated, hand-curated, cichlid-specific SINEs and LINEs already in the RepBase library and they are probably more accurate than the ones that RepeatModeler created.

Even if this isn’t the case for your project, you might want to combine these repeat libraries as RepeatModeler may not detect older ancestral repeats that may be present in your genome of interest. 

Simply run cat to combine the two fasta files:
```bash
[bash]$ cat /your_full_path_to_RepeatMaskerLibraries/RepeatMaskerLib.fasta consensi.fa.classified > combined_repeat_libs.fasta
```
**Note** - Again make sure to use the consensi.fa.classified file for RepeatMasker and not the consensi.fa, otherwise all of your species-specific repeats will be classified as “unknown”, which nobody likes. 

##Running RepeatMasker

There are many different options for running RepeatMasker, most of which are self-explanatory:
```bash
[bash]$ /your_full_path_to_RepeatMasker/RepeatMasker -h
```
A sample RepeatMasker run may look like:
```bash
[bash]$ /your_full_path_to_RepeatMasker/RepeatMasker -pa 5 -s -lib /your_full_path_to_RepeatMaskerLibraries/combined_repeat_libs_classified.fasta -dir my_RM_output_dir -e ncbi my_input_genome_assembly.fasta
```

I’ll only focus on a few key options. The first is the number of processors to use `-pa`. **Be careful here!** For whatever reason, RepeatMasker allocates the specified number of processes specified here, but then each RMBlast process uses 4 threads. So if you have 20 total cores available, only specify `-pa 5` as shown here. 

Assuming you have access to some decent compute power, specifying the slow search `-s`, shouldn’t take that long. 

You can either specify `-lib` or `-species`, but not both. If you are working with a model organism and decided to skip the RepeatModeler step, then simply specify your species (e.g. `-species human`). Otherwise use `-lib` to specify the combined repeat library that was created in the previous step. 

You can specify an output directory like `-dir my_RM_output_dir`, but you must create the directory first, RepeatMasker will not do it for you. If you don’t create this directory before running RepeatMasker, it will be ignored and it will create a directory similar to before `RM_8872.WedFeb251418042015`. This may not sound so bad, but I’ve had a case where I lost a days worth of jobs because I was running RepeatMasker with slurm on Deepthought2 and the output directory was treated as temporary and deleted at the end of the job.

##Output of RepeatMasker

Several files will created by running RepeatMasker command as above:
```bash
[bash]$ ls -lh my_RM_output_dir
-rw-r--r-- 1 conte conte 349M Mar  7 15:49 my_input_genome_assembly.fasta.cat.gz
-rw-r--r-- 1 conte conte 826M Mar  7 15:49 my_input_genome_assembly.fasta.masked
-rw-r--r-- 1 conte conte 166M Mar  7 15:49 my_input_genome_assembly.fasta.out
-rw-r--r-- 1 conte conte 2.0K Mar  7 15:49 my_input_genome_assembly.fasta.tbl
```
The first file `my_input_genome_assembly.fasta.cat.gz` contains detailed alignments of each annotated repeat:
```bash
[bash]$ zcat my_input_genome_assembly.fasta.cat.gz | head
562 24.04 0.00 4.00 scaffold_0 4 159 (18958380) rnd-6_family-220#DNA/TcMar-ISRm11 1827 1976 (482) m_b1s001i0

 scaffold_0             4 CAGTAGATGCATGCCAGGGGTGGATCAGGCATGCAAGAGGATTTTACCCC 53
                             ii  vv v    ii  ?     iv v   ? v  i vi    v   v
 rnd-6_family-       1827 CAGCGGAGTCCTGCCGAGGNTGGATTCGCCATNCCAGGGCGTTTTTCCCG 1876

 scaffold_0            54 CGCTGCCTGGCTGGGGCCAATATAGCCTGTGATGTGGATGAGATTCTCTG 103
                            v        ?  i v i          i            i  ? v  
 rnd-6_family-       1877 CGGTGCCTGGCNGGAGACGATATAGCCTGCGATGTGGATGAGGTTNTGTG 1926

 scaffold_0           104 GCCTGACCCAGACCACAGACAAGATGCTGAGGTGGGATAATGTTTCTGGT 153
                             i   v   vi  vv    v     i------ v i i  v  v    
 rnd-6_family-       1927 GCCCGACGCAGCTCAGCGACATGATGCC------GCACAGTGATTGTGGT 1970

 scaffold_0           154 GTGTGT 159
                                
 rnd-6_family-       1971 GTGTGT 1976

Matrix = 20p41g.matrix
Kimura (with divCpGMod) = 23.64
Transitions / transversions = 0.80 (16/20)
Gap_init rate = 0.04 (6 / 155), avg. gap size = 1.00 (6 / 6)
```
The second file `my_input_genome_assembly.fasta.masked`, contains a “hard” masked version of your genome assembly:
```bash
[bash]$ head my_input_genome_assembly.fasta.masked
>scaffold_0
TATNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
NNNNNNNNNTGTACTGTATAGTACATGAATGACAATGTGCCACTGTACAT
ACATTGGTTGCGTCTTTTGTGTTTATCATGTGACAAGGGTTTTGAAGGGG
AGAACCATAAGCAACCTATTTGTTTTGGAACTATTGTTTTGAATTAATTG
TACCAGTGTGTAAAACTCTGTTGTAGTGTGTGTGTTTTTGAGGGCTTGTG
TTTGATGTCTGAGGGCAAAGTTTGGTTTTTCAGCAGGAGTGAATAGTTTT
GGGTGTAGAGCTTCATTTTGACCTGGAAATAGGATGTCTGGGAAATTGAG
TGAGATGTTATGAATTTGTGTTTACTGTTGTGAGGATAGGAGGCGTAGTT
TCAAGAAATGTGCTTTAGCAATCGAGAAAAACTGNNNNNNNNNNNNNNNN
NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
…
```
This is the default masking, but there are several other masking options:
```bash
[bash]$ /your_full_path_to_RepeatMasker/RepeatMasker -h
...
   -small
       Returns complete .masked sequence in lower case

   -xsmall
       Returns repetitive regions in lowercase (rest capitals) rather than
       masked

   -x  Returns repetitive regions masked with Xs rather than Ns
...
```
The third file `my_input_genome_assembly.fasta.out` contains detailed location and score information for each detected repeat:
```bash
[bash]$ head my_input_genome_assembly.fasta.out
  SW   perc perc perc  query          position in query              matching                 repeat                  position in repeat
score   div. del. ins.  sequence       begin    end          (left)   repeat                   class/family        begin   end    (left)       ID

 562   24.0  0.0  4.0  scaffold_0            4      159 (18958380) + rnd-6_family-220         DNA/TcMar-ISRm11       1827   1976   (482)       1  
 946   12.2  0.0  5.8  scaffold_0          535      699 (18957840) C rnd-4_family-508         Unknown               (254)    156       1       2  
4933   10.5  5.3  6.2  scaffold_0          702     1552 (18956987) C rnd-1_family-112         Unknown                 (7)    847       4       3  
 706    9.9  0.0 12.4  scaffold_0         1633     1768 (18956771) C rnd-1_family-463         DNA                   (122)    185       1       4  
2626    2.9  3.8  0.0  scaffold_0         2961     3273 (18955266) + rnd-6_family-3424        DNA/hAT-Charlie           1    325     (1)       5  
3975   22.7  1.0  0.1  scaffold_0         4005     4826 (18953713) + Rex1-26_DRe              LINE/Rex-Babar         2110   2938   (452)       6  
1063   12.0  3.4  8.4  scaffold_0         4979     5214 (18953325) + rnd-1_family-672         Unknown                   7    231     (0)       7  
1210    4.1  0.0  0.0  scaffold_0         5361     5507 (18953032) C rnd-1_family-203         DNA/hAT-Ac              (1)    363     217       8  
1063   12.0  3.4  8.4  scaffold_0        11401    11636 (18946903) + rnd-1_family-672         Unknown                   7    231     (0)       9  
2368    3.7 11.3  0.0  scaffold_0        11783    12108 (18946431) C rnd-1_family-203         DNA/hAT-Ac              (1)    363       1      10  
```
RepeatMasker provides a utility script for converting this to GFF3 which you may find useful for viewing in a browser. The Repeatmasker program has an option to output a GFF2 formatted file `-gff`, but the GFF3 file is more useful. Convert the `*.out` to GFF3:
```bash
[bash]$ perl /your_full_path_to_RepeatMasker/util/rmOutToGFF3.pl my_input_genome_assembly.fasta.out
> my_input_genome_assembly.fasta.out.gff3

[bash]$ head my_input_genome_assembly.fasta.out.gff3
##gff-version 3
##sequence-region scaffold_0 1 18958539
scaffold_0	RepeatMasker	dispersed_repeat	4	159	562	+	.	Target=rnd-6_family-220 1827 1976
scaffold_0	RepeatMasker	dispersed_repeat	535	699	946	-	.	Target=rnd-4_family-508 1 156
scaffold_0	RepeatMasker	dispersed_repeat	702	1552	4933	-	.	Target=rnd-1_family-112 4 847
scaffold_0	RepeatMasker	dispersed_repeat	1633	1768	706	-	.	Target=rnd-1_family-463 1 185
scaffold_0	RepeatMasker	dispersed_repeat	2961	3273	2626	+	.	Target=rnd-6_family-3424 1 325
scaffold_0	RepeatMasker	dispersed_repeat	4005	4826	3975	+	.	Target=Rex1-26_DRe 2110 2938
scaffold_0	RepeatMasker	dispersed_repeat	4979	5214	1063	+	.	Target=rnd-1_family-672 7 231
scaffold_0	RepeatMasker	dispersed_repeat	5361	5507	1210	-	.	Target=rnd-1_family-203 217 363
```
Unfortunately, this conversion does not retain the repeat class/family information, but this probably just requires some modification of their perl script `rmOutToGFF3.pl`. I’ll update this if/when I figure that out.

The last file `my_input_genome_assembly.fasta.tbl` contains some overall stats of the RepeatMasker run:
```bash
[bash]$ cat my_input_genome_assembly.fasta.tbl
==================================================
file name: M_zebra_v0.assembly.fasta
sequences:          3750
total length:  848776495 bp  (713568230 bp excl N/X-runs)
GC level:         40.54 %
bases masked:  177829643 bp ( 20.95 %)
==================================================
              number of      length   percentage
              elements*    occupied  of sequence
--------------------------------------------------
SINEs:            55466      8346313 bp    0.98 %
     ALUs            6          384 bp    0.00 %
     MIRs        12734      1744833 bp    0.21 %

LINEs:           166953     38058472 bp    4.48 %
     LINE1        9184      3267217 bp    0.38 %
     LINE2       65651     14719562 bp    1.73 %
     L3/CR1        414        25550 bp    0.00 %

LTR elements:     25069      6645672 bp    0.78 %
     ERVL           60         3800 bp    0.00 %
     ERVL-MaLRs      2          152 bp    0.00 %
     ERV_classI   2842       448709 bp    0.05 %
     ERV_classII  2232       216734 bp    0.03 %

DNA elements:    293260     62617329 bp    7.38 %
    hAT-Charlie  23548      4941801 bp    0.58 %
    TcMar-Tigger  2719       647828 bp    0.08 %

Unclassified:    289468     50500040 bp    5.95 %

Total interspersed repeats:166167826 bp   19.58 %

Small RNA:         2837       302574 bp    0.04 %

Satellites:        2798       520247 bp    0.06 %
Simple repeats:  243670      9662850 bp    1.14 %
Low complexity:   36439      1720125 bp    0.20 %
==================================================
```
However, RepeatMasker assumes you are working with human by default and so this summary is tailored towards human specific repeat elements. They do provide a utility script to build a more detailed summary of the output:
```bash
[bash]$ perl /your_full_path_to_RepeatMasker/util/buildSummary.pl -species my_species -genome my_input_genome_assembly.fasta.out.fai.tsv -useAbsoluteGenomeSize my_input_genome_assembly.fasta.out > my_input_genome_assembly.fasta.out.detailed
```
You will need to create a tab-delimited file that contains the size of each chromsome/scaffold/contig in the fasta file you used. This can easily be created with the samtools faidx command. This script will create a much more detailed summary:
```bash
[bash]$ head my_input_genome_assembly.fasta.out.detailed
Repeat Classes
==============
Total Sequences: 3560
Total Length: 859851869 bp
Ancestral Repeats: 1153935 ( 234447039 bp )
Lineage Specific Repeats: 15585 ( 6875733 bp )
Class                  Count        bpMasked    %masked
=====                  =====        ========     =======
ARTEFACT               2            117          0.00% 
DNA                    32216        6312364      0.73% 
   Academ             129          7118         0.00% 
   CMC-Chapaev        276          12627        0.00% 
   CMC-Chapaev-3      327          44271        0.01% 
   CMC-EnSpm          11705        2565693      0.30% 
   CMC-Mirage         1            58           0.00% 
   CMC-Transib        216          12777        0.00% 
   Crypton            46           4490         0.00% 
   Crypton-V          4            391          0.00% 
   Dada               664          59378        0.01% 
   Ginger             804          44878        0.01% 
   Harbinger          11           832          0.00% 
   IS3EU              35           2455         0.00% 
   Kolobok            8            337          0.00% 
   Kolobok-Hydra      303          16996        0.00% 
   Kolobok-T2         301          12067        0.00% 
   MULE-F             1            36           0.00% 
   MULE-MuDR          525          31588        0.00% 
   MULE-NOF           25           3548         0.00% 
   Maverick           1616         139830       0.02% 
```
These summary files that RepeatMasker outputs are space-separated and kind of a pain to deal with if you are trying to use something like R for downstream analysis. The following command converts this space-separated output to tab-separated:
```bash
[bash]$ tr -s ' ' my_input_genome_assembly.fasta.out.detailed < | sed 's/^ *//g' | tr ' ' '\t' > my_input_genome_assembly.fasta.out.detailed.tab
```

