#!/bin/bash

for i in {0..31}; do
    # host_addr: 10.0.4.(5 + i)
    addr_num=$((11 + i))
    host_addr="10.0.4.$addr_num"
    
    cat > "${i}.config" << EOF
host_addr $host_addr
host_netmask 255.255.255.0
host_gateway 10.0.4.2
runtime_kthreads 1
runtime_spinning_kthreads 0
runtime_guaranteed_kthreads 0
runtime_priority lc
runtime_quantum_us 0
EOF
    
    echo "created: ${i}.config (host_addr: $host_addr)"
done
