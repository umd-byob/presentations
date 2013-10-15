#!/bin/env bash
echo "This is essentially the same submission script as last time."
echo "Except this time I will call qsub from within this script."
echo "This makes use of a variable I have in my bashrc 'PBS_ARGS'"
echo "Ok, a big caveat:  cat <<EOF means read until 'End Of File' without"
echo "variable interpolation."
echo "However, cat <<\"EOF\" means the same _with_ variable interpolation."
echo "Thus in the latter case, I can include variables from this portion of my script"
echo "And they will be included in the text of the stuff sent to qsub."
echo ""
echo "My PBS_ARGS are:"
echo "$PBS_ARGS"

export TAKE_ME_TO="Funkytown!"
export DONE="finished.txt"\

if [ -r "$DONE" ]; then
    rm ${DONE}
fi

## Note the '-' at the end of the next line!!
cat <<"EOF" | qsub $PBS_ARGS -
source ${HOME}/.bashrc
cd $PBS_O_WORKDIR
WHERE=$TAKE_ME_TO
echo "Oh, take me to where?:  $WHERE"
uname -a
pwd
env > $DONE
EOF

echo "At this time the script has been submitted to pbs."
echo "I can tell this script to wait until the script is finished executing..."
while [ /bin/true ]; do
    sleep 5
    if [ -r "$DONE" ]; then
	cat $DONE
	rm $DONE
	break
    fi
done
echo "The script is finished."
