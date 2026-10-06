FW_NAME ?= FORTH

CROSS_COMPILE ?= sh3eb-elf-
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OD = $(CROSS_COMPILE)objdump
OC = $(CROSS_COMPILE)objcopy
SZ = $(CROSS_COMPILE)size

ASFLAGS += --isa=sh4a -big

fw:
	$(AS) $(ASFLAGS) -o fw.o $(FW_NAME).S
	$(LD) -T link.ld -o fw.elf fw.o
	$(OD) -D fw.elf > fw.dis
	$(OC) -O ihex fw.elf fw.hex
	$(OC) -O binary fw.elf fw.bin
	$(SZ) fw.elf
	mkg3a -n $(FW_NAME) \
		-i uns:icon_uns.bmp \
		-i sel:icon_sel.bmp \
		fw.bin $(FW_NAME).g3a
