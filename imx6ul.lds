SECTIONS{
	. = 0xC0008000;
	__text_start = .;
	.text :
	{
		boot/start.o
		*(.text)
	}
	__text_end = .;
	.rodata ALIGN(4) : {*(.rodata*)}     
	.data ALIGN(4)   : { *(.data) }    
	__bss_start = .;    
	.bss ALIGN(4)  : { *(.bss)  *(COMMON) }    
	__bss_end = .;
}