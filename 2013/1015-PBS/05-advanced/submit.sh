#!/bin/bash
echo "This script will submit a ribosome movie session for encoding"
echo "It requires a couple environment variables to be set."
echo "1.  SESSIONDIR  :  a directory in which the pymol session file should live."
echo "2.  MOVIE_SCRIPT : A python script used to direct the movie."
#export MYBASE=/a/f20-fs1/data/dt-vol6/abelew
export MYBASE=/export/lustre_1/abelew
export LD_LIBRARY_PATH=${MYBASE}/bin:${LD_LIBRARY_PATH}
export PATH=${MYBASE}/bin:${PATH}
export PYM=pymol1.3
export FREEMOL=${MYBASE}/bin/freemol
echo "Type the name of the directory with your pymol session here."
echo "It should contain a single file named 'session.pse' inside it."
read -e NAME
export SESSIONNAME=$NAME
export SESSIONDIR=$MYBASE/$SESSIONNAME
export SESSION=${SESSIONDIR}/session.pse

if [ ! -f "$SESSION" ]; then
  echo "The file $SESSION does not exist."
  exit 1
fi

if [ "$FRAMES" = "" ]; then
  echo "The default number of frames in the movie is 480."
  echo "Change this by export FRAMES=###"
  export FRAMES=480
fi

if [ "$RENDERERS" = "" ]; then
  echo "The default number of compute nodes is 30."
  echo "Change this with export RENDERERS=##"
  export RENDERERS=40
fi

if [ "$MOVIE_SCRIPT" = "" ]; then
  echo "The default movie script is render.py"
  echo "Change this by export MOVIE_SCRIPT=\"newscript.py\""
  export MOVIE_SCRIPT=$MYBASE/bin/render.py
else
  export MOVIE_SCRIPT=$MYBASE/bin/$MOVIE_SCRIPT
fi

if [ "$PBS_QUEUE" = "" ]; then
  echo "The default PBS queue is 'serial'"
  echo "To go faster, do:"
  echo "export PBS_QUEUE=\"narrow-long -A clfshpc-hi\""
  export PBS_QUEUE="narrow-long -A clfshpc-hi"
#  export PBS_QUEUE="serial"
fi
#export MEM=$(expr ${RENDERERS} \* 12000)
export MEM=7168
export QSUB_COMMAND="/usr/local/torque/bin/qsub\
 -q $PBS_QUEUE -l pmem=${MEM}mb\
 -N $SESSIONNAME\
 -S /bin/sh -t 1-$RENDERERS -V -o ${MYBASE}/logs/${SESSIONNAME}_out \
 -e ${MYBASE}/logs/${SESSIONNAME}_err ${MYBASE}/bin/pymol_pbs"

echo "Waiting for 5 seconds if you wish to change anything before starting the submission."
echo "This script will run:"
echo "$QSUB_COMMAND"
echo ""
echo ""
echo "Using the pymol session file: $SESSION"
echo "Rendering $FRAMES frames."
echo "And movie instructions found in: $MOVIE_SCRIPT"
echo "If this is correct, type 'go' and hit return."
read GO
if [ $GO = 'go' ]; then
  echo "Changing directory to $SESSIONDIR"
  cd $SESSIONDIR && $QSUB_COMMAND
  echo "Running $QSUB_COMMAND"
  echo "Image files should be in $SESSIONDIR."

else
  exit 0
fi
