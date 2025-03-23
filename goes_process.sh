#!/bin/bash

cd /mnt/scratch/sdr/goes_hrit_live/

while true; do 
    ./rotate.sh
    ./cleanup.sh
    sleep 300
done
