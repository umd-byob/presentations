#PBS -l walltime=24:00:00,vmem=10gb,mem=10gb,nodes=8
#PBS -N 150216_bwamem_TDGD
#PBS -M josiereinhardt@gmail.com
#PBS -m e

module add bwa
module add samtools

bwa mem -t 8 /N/dc2/scratch/joserein/Genome2015/assembly.CA.coords9.79.15.17.0.05u.fa /N/dc2/scratch/joserein/rawreads/TD_Gom12_Drive_R1.fastq.gz /N/dc2/scratch/joserein/rawreads/TD_Gom12_Drive_R2.fastq.gz | samtools view -bS - > /N/dc2/scratch/joserein/bwa_split_newgenome/TDGD_full2015_150212_bwasplit2.bam
samtools sort /N/dc2/scratch/joserein/bwa_split_newgenome/TDGD_full2015_150212_bwasplit2.bam /N/dc2/scratch/joserein/bwa_split_newgenome/TDGD_full2015_150212_bwasplit2.sort
samtools index /N/dc2/scratch/joserein/bwa_split_newgenome/TDGD_full2015_150212_bwasplit2.sort.bam