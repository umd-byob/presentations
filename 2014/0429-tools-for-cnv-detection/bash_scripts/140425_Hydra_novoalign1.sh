#PBS -l walltime=72:00:00,vmem=10gb,mem=10gb,nodes=8
#PBS -N Hydra_novoalign1
#PBS -M josiereinhardt@gmail.com
#PBS -m e

module add samtools
module add bedtools
module add novoalign

novoalign -c 8 -d /N/dc2/scratch/joserein/genome.scf.20k.novoalign -f /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.pair1.tier1.fq /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.pair2.tier1.fq -i 500 50 -r Random -o SAM | samtools view -Sb - > /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.tier2.bam 
bamToBed -i /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.tier2.bam -tag NM | ~/programs/Hydra-Version-0.5.3/scripts/pairDiscordants.py -i stdin -m hydra -z 722 -y 182 -n 1000 > /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.bedpe
~/programs/Hydra-Version-0.5.3/scripts/dedupDiscordants.py -i /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.bedpe -s 3 > /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.dedup.bedpe
hydra -in /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.dedup.bedpe -out /N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.hydra.breaks -mld 240 -mno 480
