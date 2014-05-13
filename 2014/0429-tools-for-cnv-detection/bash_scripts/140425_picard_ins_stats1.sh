#PBS -l walltime=12:00:00,vmem=10gb,mem=10gb,nodes=1
#PBS -N picard_insstats1
#PBS -M josiereinhardt@gmail.com
#PBS -m e

module add java
java -Xmx2g -jar ~/programs/picard/CollectInsertSizeMetrics.jar INPUT=/N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.a600.sort.RG.bam OUTPUT=/N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.picardstats.txt VALIDATION_STRINGENCY=LENIENT HISTOGRAM_FILE=/N/dc2/scratch/joserein/CNVdata/TD_Gom12_Drive.picardstats.hist
