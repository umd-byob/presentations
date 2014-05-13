#PBS -l walltime=12:00:00,vmem=10gb,mem=10gb,nodes=1
#PBS -N breakdancer_max
#PBS -k o
#PBS -M josiereinhardt@gmail.com
#PBS -m e

module add samtools
breakdancer_max -r 5 -g /N/dc2/scratch/joserein/CNVdata/breakdancer/Td_Gom_DvsND_breakdancer.bed -d /N/dc2/scratch/joserein/CNVdata/breakdancer/Td_Gom_DvsND_breakdancer /N/dc2/scratch/joserein/CNVdata/breakdancer/TdGom_DvsND_CNV.cfg 

