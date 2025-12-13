ENTRY(_start)
SECTIONS {
  . = 0x0;
  .text : {
    KEEP(*(.text._start))
    *(.text*)
  }
  .rodata : { *(.rodata*) }
  .data : { *(.data*) }
  .bss  : { *(.bss*)  }
}

