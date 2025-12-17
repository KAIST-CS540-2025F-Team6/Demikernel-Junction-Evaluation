#!/bin/bash

if [ $# -ne 1 ]; then
    echo "usage: $0 <cnt>"
    exit 1
fi

cnt=$1
result_dir="/home/hama/bench/results/$cnt"

INTERFACE="ens85f0np0"
DURATION=30
INTERVAL=1
LOGFILE="$result_dir/bandwidth"

max_in=0
max_out=0
max_total=0
start_time=$(date +%s)

while [ $(( $(date +%s) - start_time )) -lt $DURATION ]; do
    prev_in=$(grep "^ *${INTERFACE}:" /proc/net/dev | awk '{print $2}')
    prev_out=$(grep "^ *${INTERFACE}:" /proc/net/dev | awk '{print $10}')
    sleep $INTERVAL
    
    curr_in=$(grep "^ *${INTERFACE}:" /proc/net/dev | awk '{print $2}')
    curr_out=$(grep "^ *${INTERFACE}:" /proc/net/dev | awk '{print $10}')
    
    in_kbs=$(( (curr_in - prev_in) / 1024 ))
    out_kbs=$(( (curr_out - prev_out) / 1024 ))
    total_kbs=$(( in_kbs + out_kbs ))
    
    echo "$in_kbs | $out_kbs | $total_kbs | $(date '+%H:%M:%S')" | tee -a "$LOGFILE"
    
    [ $in_kbs -gt $max_in ] && max_in=$in_kbs
    [ $out_kbs -gt $max_out ] && max_out=$out_kbs
    [ $total_kbs -gt $max_total ] && max_total=$total_kbs
done

echo "Max: Incoming ${max_in}KB/s, Outgoing ${max_out}KB/s, Total ${max_total}KB/s" | tee -a "$LOGFILE"

