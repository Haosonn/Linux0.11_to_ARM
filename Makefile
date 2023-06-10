#
# if you want the ram-disk device, define this to be the
# size in blocks.
#
RAMDISK =  #-DRAMDISK=512

# 

AS	=arm-linux-gnueabihf-as
LD	=arm-linux-gnueabihf-ld
NM  =arm-linux-gnueabihf-nm
LDFLAGS	=-Tvirt.lds 
CC	=arm-linux-gnueabihf-gcc  $(RAMDISK)
CFLAGS	=-Wall -nostdlib -g -nostdinc -fomit-frame-pointer
# CFLAGS += -fomit-frame-pointer -fno-stack-protector 

CPP	=arm-linux-gnueabihf-cpp -nostdinc -Iinclude -lgcc -L/usr/lib/gcc-cross/arm-linux-gnueabihf/11 -g

#
# ROOT_DEV specifies the default root-device when making the image.
# This can be either FLOPPY, /dev/xxxx or empty, in which case the
# default of /dev/hd6 is used by 'build'.
#
ROOT_DEV= #FLOPPY 

ARCHIVES=kernel/kernel.o mm/mm.o fs/fs.o bsp/bsp.o
DRIVERS =kernel/blk_drv/blk_drv.a kernel/chr_drv/chr_drv.a
MATH	=kernel/math/math.a
LIBS	=lib/lib.a

.c.s: $*
	$(CC) $(CFLAGS) \
	-nostdinc -Iinclude -S -o $*.s $<
.s.o: $* 
	$(AS)  -o $*.o $<
.c.o: $*
	$(CC) $(CFLAGS) \
	-nostdinc -Iinclude -c -o $*.o $<

all: Image

Image: boot/start tools/system
	arm-linux-gnueabihf-objcopy -O binary -R .note -R .comment tools/system Image
	sync


disk: Image
	dd bs=8192 if=Image of=/dev/fd0

mkimage:
	cp Image download_tool
	cd download_tool && ./mkimage.sh Image

tools/system:	 init/main.o boot/start.o \
	$(ARCHIVES) $(DRIVERS) $(MATH) $(LIBS) 
	mkdir -p tools
	$(LD) $(LDFLAGS) init/main.o boot/start.o \
	$(ARCHIVES) \
	$(DRIVERS) \
	$(MATH) \
	$(LIBS) \
	-o tools/system -lgcc -L /usr/lib/gcc-cross/arm-linux-gnueabihf/11 
	$(NM) -n tools/system > System.map

kernel/math/math.a:
	(cd kernel/math; make)

kernel/blk_drv/blk_drv.a:
	(cd kernel/blk_drv; make)

kernel/chr_drv/chr_drv.a:
	(cd kernel/chr_drv; make)

kernel/kernel.o:
	(cd kernel; make)

mm/mm.o:
	(cd mm; make)

fs/fs.o:
	(cd fs; make)

bsp/bsp.o:
	(cd bsp; make)

lib/lib.a:
	(cd lib; make)

boot/start:boot/start.S
	$(AS) -o boot/start.o boot/start.S

# qemu: all
# 	qemu-system-arm \
# 		-machine virt,gic-version=3 \
# 		-m 4G \
# 		-cpu cortex-a7 \
# 		-nographic \
# 		-device loader,file=Image,addr=0xC0008000,cpu-num=0 \
# 		-s -S \
# 		-serial mon:stdio 

qemu: all
	qemu-system-arm \
		-machine virt,gic-version=3 \
		-m 3G \
		-cpu cortex-a7 \
		-nographic \
		-kernel Image \
		-serial mon:stdio \
		-append "console=ttyAMA1 root=/dev/vda rw" \
		-s -S

gdb: all
	gdb-multiarch -x init.gdb

tmux:
	tmux new-session -d -s Linux_ARM -n qemu 'make qemu'
	tmux new-window -t Linux_ARM:2 -n gdb 'make gdb'
	tmux attach -t Linux_ARM

dtc:    
	dtc -o qemu.dts -O dts -I dtb qemu.dtb
		# -machine dumpdtb=qemu.dtb 
		# -machine mcimx6ul-evk 

clean:
	rm -f Image System.map tmp_make core
	rm -f init/*.o tools/system boot/*.o
	(cd mm;make clean)
	(cd fs;make clean)
	(cd kernel;make clean)
	(cd lib;make clean)
	(cd bsp;make clean)

backup: clean
	(cd .. ; tar cf - linux | compress16 - > backup.Z)
	sync

dep:
	sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	(for i in init/*.c;do echo -n "init/";$(CPP) -M $$i;done) >> tmp_make
	cp tmp_make Makefile
	(cd fs; make dep)
	(cd kernel; make dep)
	(cd mm; make dep)
	(cd bsp; make dep)

### Dependencies:
init/main.o: init/main.c include/unistd.h include/sys/stat.h \
 include/sys/types.h include/sys/times.h include/sys/utsname.h \
 include/utime.h include/time.h \
 include/bsp/cc.h  \
 include/bsp/core_ca7.h \
 include/string.h \
 include/bsp/bsp_int.h include/bsp/bsp_uart.h \
 include/linux/tty.h include/termios.h \
 include/linux/sched.h include/linux/head.h include/linux/fs.h \
 include/linux/mm.h include/signal.h include/asm/system.h \
 include/asm/io.h include/stddef.h include/stdarg.h include/fcntl.h
