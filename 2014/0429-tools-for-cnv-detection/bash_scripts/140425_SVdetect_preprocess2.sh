#PBS -l walltime=12:00:00,vmem=10gb,mem=10gb,nodes=1
#PBS -N svdetect_pre2
#PBS -M josiereinhardt@gmail.com
#PBS -m e

module add samtools 

export PERL5LIB=~/perl5/lib/perl5
perl ~/programs/SVDetect_r0.8b/scripts/BAM_preprocessingPairs.pl -n 10000000 -d -o /N/dc2/scratch/joserein/CNVdata/svdetect/ /N/dc2/scratch/joserein/CNVdata/TD_Gom12_ND1.RG.bam
