#PBS -l walltime=36:00:00,vmem=5gb,mem=5gb,nodes=1
#PBS -N 150217_delly
#PBS -M josiereinhardt@gmail.com
#PBS -m e

delly -t DEL -o /N/dc2/scratch/joserein/DELLY/TDG_deletions.vcr -g /N/dc2/scratch/joserein/Genome2015/assembly.CA.coords9.79.15.17.0.05u.fa /N/dc2/scratch/joserein/bwa_split_newgenome/TDGD_full2015_150212_bwasplit2.sort.bam /N/dc2/scratch/joserein/bwa_split_newgenome/TDGND1_full2015contig_150212_bwamem.sort.bam /N/dc2/scratch/joserein/bwa_split_newgenome/TDGND2_full2015contig_150212_bwamem.sort.bam 
