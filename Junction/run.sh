#!/bin/bash
QEMU_SSH_PORT=5555
qemu-system-x86_64 \
    -M q35,accel=kvm,kernel-irqchip=split \
    -cpu host,monitor=on -overcommit cpu-pm=on\
    -enable-kvm \
    -m 32G -nographic -smp 32 \
    -device intel-iommu,caching-mode=on,intremap=on \
    -device ioh3420,id=pcie.0,chassis=0 \
	-device e1000,netdev=internet,bus=pcie.0 \
	-netdev type=user,id=internet,hostfwd=tcp::$QEMU_SSH_PORT-:22 \
	-device virtio-blk-pci,drive=drv0 \
	-drive format=qcow2,file=junction.noble.qcow2,if=none,id=drv0 \
	-device ioh3420,id=pcie.1,chassis=1 \
	-device vfio-pci,host=d8:00.1,bus=pcie.1 \
	-device ioh3420,id=pcie.2,chassis=2 \
	-device vfio-pci,host=af:00.1,bus=pcie.2
