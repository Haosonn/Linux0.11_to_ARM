/*
 *  linux/mm/page.s
 *
 *  (C) 1991  Linus Torvalds
 */

/*
 * page.s contains the low-level page-exception code.
 * the real work is done in mm.c
 */

.globl page_fault       @ 声明为全局变量。将在traps.c中用于设置页异常描述符。

page_fault:
	
