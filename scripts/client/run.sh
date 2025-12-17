#!/bin/bash

if [ $# -ne 1 ]; then
    echo "usage: $0 <cnt>"
    exit 1
fi

cnt=$1
result_dir="/home/hama/bench/results/$cnt"

if [ -d "$result_dir" ]; then
    rm -rf "$result_dir"
fi
mkdir -p "$result_dir"

pushd /home/hama/YCSB

echo "=== YCSB Load start ==="
./bin/ycsb load redis -s \
    -threads $cnt \
    -P workloads/workloadf \
    -p "redis.host=10.0.4.11" \
    -p "redis.port=6379" \
    > "$result_dir/load"
    # -p "redis.cluster=true" \

echo "=== YCSB Load end (log: $result_dir/load) ==="

echo "=== YCSB Run start ==="
./bin/ycsb run redis -s \
    -threads $cnt \
    -P workloads/workloadf \
    -p "redis.host=10.0.4.11" \
    -p "redis.port=6379" \
    > "$result_dir/run" &
    # -p "redis.cluster=true" \

RUN_PID=$!

sleep 10

/home/hama/bench/bandwidth.sh $cnt

wait $RUN_PID

echo "=== YCSB Run end (log: $result_dir/run) ==="

popd
