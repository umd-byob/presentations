#PBS -S /bin/bash
#PBS -l mem=6GB,walltime=72:00:00
#PBS -N wdr_gfp
#PBS -j eo -e /cbcb/personal-scratch/wdarocha/gfp/tophat.out
set -x
base=/cbcb/personal-scratch/wdarocha/HPGL0120

cd $base

export TOPHAT="/cbcb/lab/nelsayed/programs/tophat-2.0.5.Linux_x86_64/tophat"
export OPTIONS="-p 4 -o $base/processed/tophat_HPGL0120_Esm/tophat_HPGL0120_EL.out"
export REFLIB="-G /cbcb/lab/nelsayed/ref_data/tcruzi/tcruzi_clbrener/annotation_tcruzi_clbrener/tc_esmer/TcruziEsmeraldo-Like_TriTrypDB-4.1_CDS_exon_gene_psu.gtf "
export JUNCS="--no-novel-juncs /cbcb/lab/nelsayed/ref_data/tcruzi/tcruzi_clbrener/genome_tcruzi_clbrener/tc_esmer/TcruziEsmeraldo-LikeGenomic_TriTrypDB-4.1 "
export INPUTS="$base/processed/tophat_HPGL0120_Esm/HPGL0120_EL.fastq "

$TOPHAT $OPTIONS $REFLIB $JUNCS $INPUTS

