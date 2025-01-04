# ARM_64
QEMU_AARCH64 := qemu-system-aarch64
MACHINE_AARCH64 := virt
CPU_AARCH64 := cortex-a72
KERNEL_AARCH64 := kernel/shell_aarch64-qemu-virt.bin

# x86_64
QEMU_X86_64 := qemu-system-x86_64
MACHINE_X86_64 := q35
KERNEL_X86_64 := kernel/shell_x86_64-qemu-q35.elf

MEMORY := 128M
SMP := 4
DISK_IMG := disk.img
DEVICE := virtio-blk-pci
DRIVE_OPTS := -drive id=disk0,if=none,format=raw,file=$(DISK_IMG)
NOGRAPHIC := -nographic

all: x86
	@echo "System Quting..." 

mkdisk:
	qemu-img create -f raw $(DISK_IMG) 128M
	mkfs.vfat $(DISK_IMG)

aarch: mkdisk
	$(QEMU_AARCH64) \
		-m $(MEMORY) \
		-smp $(SMP) \
		-cpu $(CPU_AARCH64) \
		-machine $(MACHINE_AARCH64) \
		-kernel $(KERNEL_AARCH64) \
		-device $(DEVICE),drive=disk0 $(DRIVE_OPTS) \
		$(NOGRAPHIC)

x86: mkdisk
	$(QEMU_X86_64) \
		-m $(MEMORY) \
		-smp $(SMP) \
		-machine $(MACHINE_X86_64) \
		-kernel $(KERNEL_X86_64) \
		-device $(DEVICE),drive=disk0 $(DRIVE_OPTS) \
		$(NOGRAPHIC)

clean:
	rm -f $(DISK_IMG)

.PHONY: aarch x86 clean mkdisk
