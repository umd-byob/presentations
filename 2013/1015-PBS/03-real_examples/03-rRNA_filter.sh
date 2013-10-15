#!/bin/env bash
source ${LAB}/scripts/dotbashrc

export MYWD=${PWD}
export QSUB_ARGS="$PBS_ARGS -"
export RNA_LIB="../libraries/rRNA"
export IN="rp.fasta"
export MYTEST=0
unset MYTEST
export MYLOG="/cbcbhomes/abelew/project_scratch/riboseq/014/test.out"


cat <<"EOF" | qsub $QSUB_ARGS
source ${LAB}/scripts/dotbashrc
cd $MYWD
start_log

coproc dstat -t -c -d -n -g -m -y -p -r --fs --tcp --vm --proc-count --output=${MYWD}/${PBS_JOBNAME}.csv 2>>${MYWD}/${PBS_JOBNAME}_dstat.txt 1>&2

export BOB="testme"
echo ""
env > $MYLOG
ls >> $MYLOG

echo "echoing bob $BOB" >> $MYLOG

CORES=" -p $(cpus) "
MULTALIGN=${MULTIALIGN-" -k 1 "}
TRIM3p=${TRIM3p-" -3 0 "}
SEEDARGS=${SEEDARGS-" -D 5 -R 1 -N 0 -L 10 -i S,0,2.50 "}
FILETYPE=${FILETYPE-" -f "}
REPORTARGS=${REPORTARGS-"  --un  ${MYWD}/unsorted.fasta --al-gz ${MYWD}/ribosomal.fasta.gz --no-head --no-sq "}


CMD="bowtie2 -x ${RNA_LIB} ${FILETYPE} -U ${MYWD}/${IN} -S ${MYWD}/${IN}.sam ${SEEDARGS} ${TRIM3p} ${MULTALIGN} ${REPORTARGS} ${CORES} 2>${MYWD}/${IN}.stderr 1>${MYWD}/${IN}.stdout"

if [ -n "$MYTEST" ]; then
  echo "Would run:" >> $MYLOG
  echo "$CMD" >> $MYLOG
  echo "This can be modified by exporting following variables:" >> $MYLOG
  echo "MULTIALIGN, TRIM3p, SEEDARGS, FILETYPE, REPORTARGS" >> $MYLOG
else
  eval $CMD
fi

if [[ "$?" = "0" ]]; then
   echo "success $? in ${SECONDS}" >> ${MYWD}/status.txt
else
   echo "fail $? in ${SECONDS}" >> ${MYWD}/status.txt
fi

EOJ
