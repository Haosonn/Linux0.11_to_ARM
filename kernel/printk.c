/*
 *  linux/kernel/printk.c
 *
 *  (C) 1991  Linus Torvalds
 */

/*
 * When in kernel-mode, we cannot use printf, as fs is liable to
 * point to 'interesting' things. Make a printf with fs-saving, and
 * all is well.
 */
#include <stdarg.h>
#include <stddef.h>
#include <string.h>

#include <linux/kernel.h>

static char buf[1024];	/* 显示用的临时缓冲区 */

extern int vsprintf(char * buf, const char * fmt, va_list args);

/* 内核使用的显示函数 */
int printk(const char *fmt, ...)
{
	va_list args;
	int i;
	va_start(args, fmt);
	i = vsprintf(buf, fmt, args);
	va_end(args);
	for (i = 0; i < strlen(buf); i++)
	{
		putc(buf[i]);
	}
	return i;
}
