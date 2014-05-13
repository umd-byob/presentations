#PBS -l walltime=48:00:00,vmem=10gb,mem=10gb,nodes=1
#PBS -N svdetect
#PBS -M josiereinhardt@gmail.com
#PBS -m e

export PERL5LIB=~/perl5/lib/perl5
module add samtools
module add bedtools

###This is a example of script for using SVDetect

#Comparison of links between the two datasets
SVDetect links2compare -conf ~/drive.sv.conf

