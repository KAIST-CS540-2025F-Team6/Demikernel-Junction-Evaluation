#!/bin/bash

source /root/bench/.envrc

if [ $# -ne 1 ]; then
    echo "usage: $0 <cnt>"
    exit 1
fi

cnt=$1

out_dir="/root/bench/out/$cnt"
if [ -d "$out_dir" ]; then
    rm -rf "$out_dir"
fi
mkdir -p "$out_dir"

for i in $(seq 0 $((cnt - 1))); do
    junction_run /root/bench/caladan_config/${i}.config -- \
        /root/redis/src/redis-server \
        --protected-mode no \
        --save "" \
        --appendonly no \
        --cluster-enabled yes \
        > "$out_dir/$i" &
    
done

