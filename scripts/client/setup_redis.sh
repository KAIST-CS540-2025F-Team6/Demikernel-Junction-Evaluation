#!/bin/bash

set -x

if [ $# -ne 1 ]; then
    echo "usage: $0 <cnt>"
    exit 1
fi

cnt=$1

nodes=()
for i in $(seq 0 $((cnt - 1))); do
    ip_num=$((11 + i))
    nodes+=("10.0.4.$ip_num:6379")
done

redis-cli --cluster create ${nodes[*]} --cluster-replicas 0 --cluster-yes

