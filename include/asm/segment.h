static inline unsigned char get_fs_byte(const char * addr)
{
	unsigned register char _v;
	return _v;
}

static inline unsigned short get_fs_word(const unsigned short *addr)
{
	unsigned short _v;
	return _v;
}

static inline unsigned long get_fs_long(const unsigned long *addr)
{
	unsigned long _v;

	return _v;
}

static inline void put_fs_byte(char val,char *addr)
{

}

static inline void put_fs_word(short val,short * addr)
{

}

static inline void put_fs_long(unsigned long val,unsigned long * addr)
{

}

/*
 * Someone who knows GNU asm better than I should double check the followig.
 * It seems to work, but I don't know if I'm doing something subtly wrong.
 * --- TYT, 11/24/91
 * [ nothing wrong here, Linus ]
 */

static inline unsigned long get_fs() 
{
	unsigned short _v;

	return _v;
}

static inline unsigned long get_ds() 
{
	unsigned short _v;

	return _v;
}

static inline void set_fs(unsigned long val)
{

}

