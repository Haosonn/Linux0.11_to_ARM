/*
 *  linux/lib/open.c
 *
 *  (C) 1991  Linus Torvalds
 */

#define __LIBRARY__
#include <unistd.h>
#include <stdarg.h>

int open(const char * filename, int flag, ...)
{
	register int res;
	va_list arg;

	va_start(arg,flag);
	
	asm volatile (
				  "mov r7, %1\n"
				  "mov r0, %2\n"
				  "mov r1, %3\n"
				  "mov r2, %4\n"
				  "swi	0x0"
				  :"=r" (res)
				  :"0" (__NR_open),"r" (filename),"r" (flag),"r" (va_arg(arg, int))
				  : "r0","r1","r2","r7","lr");

	if (res>=0)
		return res;
	errno = -res;
	return -1;
}
