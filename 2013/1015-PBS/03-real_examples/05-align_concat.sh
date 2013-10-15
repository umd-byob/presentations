cat <<"EOF" | qsub  -V -S /cbcb/lab/nelsayed/local/bin/bash -q throughput -l walltime=12:00:00   -j eo -e ibissub00.umiacs.umd.edu:/cbcbhomes/abelew/outputs/pbs.out -m n
source /cbcb/lab/nelsayed/scripts/dotbashrc

cd /cbcb/personal-scratch/abelew/riboseq/concat

echo "bowtie /cbcb/project-scratch/atb/libraries/rRNA/lmajor \
  --seedlen=23 -p $(cpus) -v 0 \
  -f /cbcb/personal-scratch/abelew/riboseq/concat/03_completed.fasta \
  --un /cbcb/personal-scratch/abelew/riboseq/concat/04_completed_notrRNA.fasta 2>/cbcb/personal-scratch/abelew/riboseq/concat/04_completed_notrRNA.err 1>/dev/null 
"

eval "bowtie /cbcb/project-scratch/atb/libraries/rRNA/lmajor \
  --seedlen=23 -p $(cpus) -v 0 \
  -f /cbcb/personal-scratch/abelew/riboseq/concat/03_completed.fasta \
  --un /cbcb/personal-scratch/abelew/riboseq/concat/04_completed_notrRNA.fasta 2>/cbcb/personal-scratch/abelew/riboseq/concat/04_completed_notrRNA.err 1>/dev/null 
"


touch /cbcb/personal-scratch/abelew/riboseq/concat/04_completed_notrRNA.finished
EOF


finished=0
while [ "$finished" -eq "0" ]; do
  if [ -e /cbcb/personal-scratch/abelew/riboseq/concat/04_completed_notrRNA.finished ]; then
    finished=1
  else
    sleep 10
  fi
done


cat <<"EOF" | qsub  -V -S /cbcb/lab/nelsayed/local/bin/bash -q throughput -l walltime=12:00:00   -j eo -e ibissub00.umiacs.umd.edu:/cbcbhomes/abelew/outputs/pbs.out -m n
source /cbcb/lab/nelsayed/scripts/dotbashrc

cd /cbcb/personal-scratch/abelew/riboseq/concat

echo "bowtie /cbcb/project-scratch/atb/libraries/lmajor/genome \
  -p $(cpus) -M 1 -v 2 \
  -f /cbcb/personal-scratch/abelew/riboseq/concat/04_completed_notrRNA.fasta \
  --al /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.fasta \
  --un /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-nohits.fasta \
  -S /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome.sam \
  2>/cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome.err 1>/cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome.out \
    &&     echo 'Sam2Bam' && samtools view -b -S -u \
  -t /cbcb/project-scratch/atb/libraries/lmajor/genome.fasta \
  /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.sam \
  /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.bam \
    &&     echo 'Samtools sort' && samtools sort -@ 1 -l 6 /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.bam /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits_sorted \
    &&     echo 'Samtools index' && samtools index /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits_sorted.bam \
    &&     echo 'Cleaning up' && rm /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.bam \
    &&     mv /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits_sorted.bam /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.bam \
    &&     mv /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits_sorted.bam.bai /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.bam.bai"

eval "bowtie /cbcb/project-scratch/atb/libraries/lmajor/genome \
  -p $(cpus) -M 1 -v 2 \
  -f /cbcb/personal-scratch/abelew/riboseq/concat/04_completed_notrRNA.fasta \
  --al /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.fasta \
  --un /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-nohits.fasta \
  -S /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome.sam \
  2>/cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome.err 1>/cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome.out \
    &&     echo 'Sam2Bam' && samtools view -b -S -u \
  -t /cbcb/project-scratch/atb/libraries/lmajor/genome.fasta \
  /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.sam \
  /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.bam \
    &&     echo 'Samtools sort' && samtools sort -@ 1 -l 6 /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.bam /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits_sorted \
    &&     echo 'Samtools index' && samtools index /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits_sorted.bam \
    &&     echo 'Cleaning up' && rm /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.bam \
    &&     mv /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits_sorted.bam /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.bam \
    &&     mv /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits_sorted.bam.bai /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_genome-hits.bam.bai"


EOF


cat <<"EOF" | qsub  -V -S /cbcb/lab/nelsayed/local/bin/bash -q throughput -l walltime=12:00:00   -j eo -e ibissub00.umiacs.umd.edu:/cbcbhomes/abelew/outputs/pbs.out -m n
source /cbcb/lab/nelsayed/scripts/dotbashrc

cd /cbcb/personal-scratch/abelew/riboseq/concat

echo "bowtie /cbcb/project-scratch/atb/libraries/lmajor/annotated_cds \
  -p $(cpus) -M 1 -v 2 \
  -f -f /cbcb/personal-scratch/abelew/riboseq/concat/04_completed_notrRNA.fasta \
  --al /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.fasta \
  --un /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds-nohits.fasta \
  -S /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.sam \
  2>/cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.err 1>/cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.out \
    &&     echo 'Sam2Bam' && samtools view -b -S -u \
  -t /cbcb/project-scratch/atb/libraries/lmajor/annotated_cds.fasta \
  /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.sam \
  /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.bam \
    &&     echo 'Samtools sort' && samtools sort -@ 1 -l 6 /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.bam /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds_sorted \
    &&     echo 'Samtools index' && samtools index /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds_sorted.bam \
    &&     echo 'Cleaning up' && rm /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.bam \
    &&     mv /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds_sorted.bam /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.bam \
    &&     mv /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds_sorted.bam.bai /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.bam.bai"

eval "bowtie /cbcb/project-scratch/atb/libraries/lmajor/annotated_cds \
  -p $(cpus) -M 1 -v 2 \
  -f -f /cbcb/personal-scratch/abelew/riboseq/concat/04_completed_notrRNA.fasta \
  --al /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.fasta \
  --un /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds-nohits.fasta \
  -S /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.sam \
  2>/cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.err 1>/cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.out \
    &&     echo 'Sam2Bam' && samtools view -b -S -u \
  -t /cbcb/project-scratch/atb/libraries/lmajor/annotated_cds.fasta \
  /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.sam \
  /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.bam \
    &&     echo 'Samtools sort' && samtools sort -@ 1 -l 6 /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.bam /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds_sorted \
    &&     echo 'Samtools index' && samtools index /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds_sorted.bam \
    &&     echo 'Cleaning up' && rm /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.bam \
    &&     mv /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds_sorted.bam /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.bam \
    &&     mv /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds_sorted.bam.bai /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_cds.bam.bai"


EOF


cat <<"EOF" | qsub  -V -S /cbcb/lab/nelsayed/local/bin/bash -q throughput -l walltime=12:00:00   -j eo -e ibissub00.umiacs.umd.edu:/cbcbhomes/abelew/outputs/pbs.out -m n
source /cbcb/lab/nelsayed/scripts/dotbashrc

cd /cbcb/personal-scratch/abelew/riboseq/concat

echo "bowtie /cbcb/project-scratch/atb/libraries/lmajor/annotated_transcripts \
  -p $(cpus) -M 1 -v 2 \
  -f -f /cbcb/personal-scratch/abelew/riboseq/concat/04_completed_notrRNA.fasta \
  --al /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.fasta \
  --un /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts-nohits.fasta \
  -S /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.sam \
  2>/cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.err 1>/cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.out \
    &&     echo 'Sam2Bam' && samtools view -b -S -u \
  -t /cbcb/project-scratch/atb/libraries/lmajor/annotated_transcripts.fasta \
  /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.sam \
  /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.bam \
    &&     echo 'Samtools sort' && samtools sort -@ 1 -l 6 /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.bam /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts_sorted \
    &&     echo 'Samtools index' && samtools index /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts_sorted.bam \
    &&     echo 'Cleaning up' && rm /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.bam \
    &&     mv /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts_sorted.bam /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.bam \
    &&     mv /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts_sorted.bam.bai /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.bam.bai"

eval "bowtie /cbcb/project-scratch/atb/libraries/lmajor/annotated_transcripts \
  -p $(cpus) -M 1 -v 2 \
  -f -f /cbcb/personal-scratch/abelew/riboseq/concat/04_completed_notrRNA.fasta \
  --al /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.fasta \
  --un /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts-nohits.fasta \
  -S /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.sam \
  2>/cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.err 1>/cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.out \
    &&     echo 'Sam2Bam' && samtools view -b -S -u \
  -t /cbcb/project-scratch/atb/libraries/lmajor/annotated_transcripts.fasta \
  /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.sam \
  /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.bam \
    &&     echo 'Samtools sort' && samtools sort -@ 1 -l 6 /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.bam /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts_sorted \
    &&     echo 'Samtools index' && samtools index /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts_sorted.bam \
    &&     echo 'Cleaning up' && rm /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.bam \
    &&     mv /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts_sorted.bam /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.bam \
    &&     mv /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts_sorted.bam.bai /cbcb/personal-scratch/abelew/riboseq/concat/05_completed_annotated_transcripts.bam.bai"


EOF

