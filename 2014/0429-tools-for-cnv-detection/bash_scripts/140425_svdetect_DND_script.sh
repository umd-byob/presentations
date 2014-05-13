#PBS -l walltime=48:00:00,vmem=10gb,mem=10gb,nodes=1
#PBS -N svdetect
#PBS -M josiereinhardt@gmail.com
#PBS -m e

export PERL5LIB=~/perl5/lib/perl5
module add samtools
module add bedtools

samtools view /N/dc2/scratch/joserein/CNVdata/svdetect/TD_Gom12_Drive.a600.sort.RG.norm.bam > /N/dc2/scratch/joserein/CNVdata/svdetect/TD_Gom12_Drive.a600.sort.RG.norm.sam
samtools view /N/dc2/scratch/joserein/CNVdata/svdetect/TD_Gom12_Drive.a600.sort.RG.ab.bam > /N/dc2/scratch/joserein/CNVdata/svdetect/TD_Gom12_Drive.a600.sort.RG.ab.sam
samtools view /N/dc2/scratch/joserein/CNVdata/svdetect/TD_Gom12_ND1.RG.norm.bam > /N/dc2/scratch/joserein/CNVdata/svdetect/TD_Gom12_ND1.RG.norm.sam
samtools view /N/dc2/scratch/joserein/CNVdata/svdetect/TD_Gom12_ND1.RG.ab.bam > /N/dc2/scratch/joserein/CNVdata/svdetect/TD_Gom12_ND1.RG.ab.sam

#Generation and filtering of links from the sample data
SVDetect linking filtering -conf ~/drive.sv.conf

#Generation and filtering of links from the reference data
SVDetect linking filtering -conf ~/nondrive.sv.conf

#Comparison of links between the two datasets
SVDetect links2compare -conf ~/drive.sv.conf

#Calculation of depth-of-coverage log-ratios
SVDetect cnv ratio2bedgraph -conf ~/DND.svdet.cnv.conf
