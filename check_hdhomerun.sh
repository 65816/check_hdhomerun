#!/bin/bash

# check_hdhomerun.sh
# Zachary McGibbon
# https://github.com/mzac/check_hdhomerun.git

# Adjust to point to your hdhomerun_config binary
HR_BIN="/usr/bin/hdhomerun_config"

if [ ! -f $HR_BIN ]; then
	echo "hdhomerun_config binary not found!"
	exit 3
fi

while getopts ":f:i:t:c:s:x:y:z:" opt; do
    case $opt in
        f)
	    FLAG=$OPTARG
	    ;;
        i)
            HR_ID=$OPTARG
	    ;;
        t)
	    TUNER=tuner$OPTARG
	    ;;
	c)
	    CMD=$OPTARG
	    ;;
	s)
	    SUB=$OPTARG
            ;;
        x)
	    ALT1=$OPTARG
	    ;;
        y)
            ALT2=$OPTARG
	    ;;
        z)
	    ALT3=$OPTARG
	    ;;
        
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 3
        ;;
        
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 3
        ;;
    esac
done

if [ -z "$HR_ID" ]
then
	echo "HR ID required"
	exit 3
fi

OUTPUT=`$HR_BIN $HR_ID $CMD /$TUNER/$SUB`
echo $SUB: $OUTPUT

case "$OUTPUT" in
	*$FLAG* ) NONE=true;;
esac

if [[ $NONE = "true" ]]
then
    #echo "true"
    exit 0
else
	if [ -z "$ALT1" ]
       	then
		ALT1="nothing"
	else
	    OUTPUT=`$HR_BIN $HR_ID $CMD /$TUNER/$ALT1`
	    echo $ALT1: $OUTPUT
	fi

	if [ -z "$ALT2" ]
       	then
		ALT2="nothing"
	else
            OUTPUT=`$HR_BIN $HR_ID $CMD /$TUNER/$ALT2`
            echo $ALT2: $OUTPUT
	fi

	if [ -z "$ALT3" ]
       	then
		ALT3="nothing"
	else
            OUTPUT=`$HR_BIN $HR_ID $CMD /$TUNER/$ALT3`
            echo $ALT3: $OUTPUT
	fi

    exit 1
fi

