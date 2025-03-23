#!/bin/bash

cd /mnt/scratch/sdr/goes_hrit_live/

satdump live goes_hrit . \
    --source rtlsdr \
    --samplerate 2.4e6 \
    --frequency 194.1e6 \
    --gain 49.6 \
    --http_server 127.0.0.1:8999
