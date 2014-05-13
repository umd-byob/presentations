#PBS -l walltime=48:00:00,vmem=10gb,mem=10gb,nodes=1
#PBS -N CNVnator_statpartcall1
#PBS -j oe 
#PBS -k o
#PBS -M josiereinhardt@gmail.com
#PBS -m e

export ROOTSYS=~/bin/root/
export PATH=$PATH:~/bin/root/bin/
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ROOTSYS}/lib

cnvnator -root /N/dc2/scratch/joserein/CNVdata/Td_Drive.root -his 5000 -d /N/dc2/scratch/joserein/genome_20k/
cnvnator -root /N/dc2/scratch/joserein/CNVdata/Td_Drive.root -stat 5000
cnvnator -root /N/dc2/scratch/joserein/CNVdata/Td_Drive.root -partition 5000
cnvnator -root /N/dc2/scratch/joserein/CNVdata/Td_Drive.root -call 5000 > /N/dc2/scratch/joserein/CNVdata/Td_drive.cnvnator.calls.out
