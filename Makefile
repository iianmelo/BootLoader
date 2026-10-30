# Imagem de disquete: setor 1 = boot1, setor 2 = boot2, setor 3 em diante = kernel.
# O boot2 le 20 setores (10 KiB) para 0x7E00; o teste abaixo falha se o kernel passar disso.

NASM      = nasm
QEMU      = qemu-system-i386

BOOT1     = boot1.bin
BOOT2     = boot2.bin
KERNEL    = kernel.bin
DISK      = disk.img

BLOCK     = 512
DISK_SECS = 100
KERNEL_MAX = 10240

.PHONY: all disk run clean

all: run

disk: $(DISK)

$(BOOT1): boot1.asm
	$(NASM) -f bin $< -o $@

$(BOOT2): boot2.asm
	$(NASM) -f bin $< -o $@

$(KERNEL): kernel.asm sprite.asm
	$(NASM) -f bin $< -o $@

$(DISK): $(BOOT1) $(BOOT2) $(KERNEL)
	@test $$(stat -c%s $(BOOT1)) -eq 512
	@test $$(stat -c%s $(BOOT2)) -eq 512
	@test $$(stat -c%s $(KERNEL)) -le $(KERNEL_MAX)
	dd if=/dev/zero of=$(DISK) bs=$(BLOCK) count=$(DISK_SECS) status=none
	dd if=$(BOOT1) of=$(DISK) bs=$(BLOCK) conv=notrunc status=none
	dd if=$(BOOT2) of=$(DISK) bs=$(BLOCK) seek=1 conv=notrunc status=none
	dd if=$(KERNEL) of=$(DISK) bs=$(BLOCK) seek=2 conv=notrunc status=none

run: $(DISK)
	$(QEMU) -boot a -drive file=$(DISK),format=raw,if=floppy

clean:
	rm -f $(BOOT1) $(BOOT2) $(KERNEL) $(DISK)
