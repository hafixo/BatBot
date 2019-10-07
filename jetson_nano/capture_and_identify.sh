#!/bin/bash

image_name=${1}
resolution=${2}
algorithm=${3}

if [ "$image_name" == "" ]
then
    image_name="/tmp/capture.jpg"
fi

if [ "$resolution" == "" ]
then
    resolution="hd"
fi

if [ "$algorithm" == "" ]
then
    algorithm="DenseNet"
fi

#
# Note: be careful editing this file. side-effects can happen:
# The first output lines must be from the 'capture.sh' command below.
# If not, the Android app currently won't find the IMAGE_FILE_HEADER
#

if pgrep -x "identify.py" > /dev/null
then
    ./capture.sh ${image_name} ${resolution}
    python3 ./request_identify.py ${image_name} 2> /dev/null
else
    printf "starting the 'identify' server.."
    printf "algorithm set to: ${algorithm}"
    printf "please wait 1 minute.."
    printf
    printf "..and then retry.."
    printf "the first request will be *very* slow."
    printf "after that, it speeds up greatly."

    nohup ./identify.py ${algorithm} > /dev/null 2>&1 &
fi
