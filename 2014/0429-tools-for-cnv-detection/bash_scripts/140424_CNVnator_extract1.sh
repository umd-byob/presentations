#PBS -l walltime=12:00:00,vmem=10gb,mem=10gb,nodes=1
#PBS -N CNVnator_extract1
#PBS -j oe 
#PBS -k o
#PBS -M josiereinhardt@gmail.com
#PBS -m e

export ROOTSYS=~/bin/root/
export PATH=$PATH:~/bin/root/bin/
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ROOTSYS}/lib

cnvnator -root /N/dc2/scratch/joserein/CNVdata/Td_Drive.root -tree /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.a600.sort.RG.bam
