OUTPUT_ARCH(sh)
ENTRY(INITIALIZE)


/* from libfxcg's toolchain/prizm.x:
   - code is loaded at 0x00300000 (mkg3a packs it at file offset 0x7000)
   - .data lives in RAM at VMA, with its LMA in ROM right after .text
     (the .pretext crt0 copies it there at startup and zeroes .bss)
   - RAM region follows the libfxcg convention */
MEMORY
{
    ROM (rx)  : ORIGIN = 0x00300000, LENGTH = 1024K
    RAM (rwx) : ORIGIN = 0x08100004, LENGTH = 64K
}

SECTIONS
{
    .text : {
        KEEP(*(.pretext))       /* loader jumps to 0x00300000: entry first */
        *(.text .text* .text.*)
        *(.rodata .rodata* .rodata.*)
    } > ROM

    .data : ALIGN(4) {
        _datald = LOADADDR(.data);
        _sdata = .;
        *(.data .data* .data.*)
	. = ALIGN(4);
        _edata = .;
    } > RAM AT> ROM

    .bss : ALIGN(4) {
        _bbss = .;
        *(.bss .bss* .bss.*)
        *(COMMON)
	. = ALIGN(4);
        _ebss = .;
    } > RAM

    /DISCARD/ : {
        *(.comment)
        *(.note*)
        *(.eh_frame*)
    }
}
