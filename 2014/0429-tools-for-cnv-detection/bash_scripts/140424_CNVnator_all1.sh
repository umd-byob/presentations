#PBS -l walltime=12:00:00,vmem=10gb,mem=10gb,nodes=1
#PBS -N CNVnator_all_bin50
#PBS -k o
#PBS -M josiereinhardt@gmail.com
#PBS -m e
#PBS -e /N/dc2/scratch/joserein/CNVdata/Td_Drive_Cnvnator.e.txt
#PBS -o /N/dc2/scratch/joserein/CNVdata/Td_Drive_Cnvnator.o.txt

export ROOTSYS=~/bin/root/
export PATH=$PATH:~/bin/root/bin/
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ROOTSYS}/lib

cnvnator -root /N/dc2/scratch/joserein/CNVdata/Td_Drive.root -tree /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.a600.sort.RG.bam
cnvnator -root /N/dc2/scratch/joserein/CNVdata/Td_Drive.root -his 50
cnvnator -root /N/dc2/scratch/joserein/CNVdata/Td_Drive.root -stat 50
cnvnator -root /N/dc2/scratch/joserein/CNVdata/Td_Drive.root -partition 50
cnvnator -root /N/dc2/scratch/joserein/CNVdata/Td_Drive.root -call 50
