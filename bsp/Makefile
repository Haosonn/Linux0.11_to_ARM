AR	=arm-linux-gnueabihf-ar
AS	=arm-linux-gnueabihf-as
CC	=arm-linux-gnueabihf-gcc
LD	=arm-linux-gnueabihf-ld
CFLAGS	=-Wall  -g -nostdinc -I../include -nostdlib -fomit-frame-pointer
# CFLAGS += -fstrength-reduce -fomit-frame-pointer
CPP	=arm-linux-gnueabihf-gcc -E -nostdinc -I../include -g

.c.s: $*
	$(CC) $(CFLAGS) \
	-S -o $*.s $<
.c.o: $*
	$(CC) $(CFLAGS) \
	-c -o $*.o $<
.s.o: $*
	$(AS) -o $*.o $<

OBJS= bsp_int.o bsp_uart.o

bsp.o: $(OBJS)
	$(LD) -r -o bsp.o $(OBJS)

clean:
	rm -f core *.o *.a tmp_make
	for i in *.c;do rm -f `basename $$i .c`.s;done

dep:
	sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	(for i in *.c;do $(CPP) -M $$i;done) >> tmp_make
	cp tmp_make Makefile
