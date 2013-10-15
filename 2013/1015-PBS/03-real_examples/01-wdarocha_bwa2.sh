#PBS -S /bin/bash
#PBS -l mem=24GB,walltime=72:00:00
#PBS -q large
#PBS -N BWA_JC
#PBS -j eo -e ibissub01.umiacs.umd.edu:/cbcb/personal-scratch/wdarocha/Trinity/Jaccard_Clip/BWA

source /cbcb/lab/nelsayed/scripts/dotbashrc

bwa bwasw /cbcb/lab/nelsayed/ref_data/tcruzi_clbrener/genome/tc_combined/nonemser_with_unassigned_contigs/TcruziNonEsmeraldo_UnassignedContigs-4.1.fasta /cbcb/personal-scratch/wdarocha/Trinity/Jaccard_Clip/Gstrain_TranscriptomeAssembly_Trinity_JC_SingleLine_HigherThan450bp_SLplusminusSameStrand.fasta > bwa_trinity_output_Gstrain_TranscriptomeAssembly_NonEsmPlusUnassigned.sam

