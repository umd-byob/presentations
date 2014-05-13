#PBS -l walltime=12:00:00,vmem=10gb,mem=10gb,nodes=1
#PBS -N Hydra_samtools1_try2
#PBS -M josiereinhardt@gmail.com
#PBS -m e

module add samtools

samtools view -uF 2 /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.a600.sort.RG.bam | samtools sort -n - /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.RG.nopair
bamToFastq -bam /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.RG.nopair.bam -fq1 /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.pair1.tier1.fq -fq2 /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.pair2.tier1.fq
