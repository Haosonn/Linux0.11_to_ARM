AR	=arm-linux-gnueabihf-ar
AS	=arm-linux-gnueabihf-as
CC	=arm-linux-gnueabihf-gcc
LD	=arm-linux-gnueabihf-ld
CFLAGS	=-Wall -fstrength-reduce -fomit-frame-pointer -g \
	 -nostdinc -I../include -nostdlib 
CPP	=arm-linux-gnueabihf-gcc -E -nostdinc -I../include 

.c.s:
	$(CC) $(CFLAGS) \
	-S -o $*.s $<
.c.o:
	$(CC) $(CFLAGS) \
	-c -o $*.o $<
.s.o:
	$(AS) -o $*.o $<

OBJS=	bsp_beep.o bsp_clk.o bsp_delay.o bsp_epittimer.o bsp_exit.o bsp_gpio.o \
	bsp_int.o bsp_led.o bsp_uart.o

bsp.o: $(OBJS)
	$(LD) -r -o bsp.o $(OBJS)

clean:
	rm -f core *.o *.a tmp_make
	for i in *.c;do rm -f `basename $$i .c`.s;done

dep:
	sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	(for i in *.c;do $(CPP) -M $$i;done) >> tmp_make
	cp tmp_make Makefile

### Dependencies:
bsp_beep.o: bsp_beep.c ../include/bsp/bsp_beep.h ../include/bsp/imx6ul.h \
 ../include/bsp/cc.h ../include/bsp/MCIMX6Y2.h \
 ../include/bsp/fsl_common.h ../include/bsp/fsl_iomuxc.h \
 ../include/bsp/core_ca7.h ../include/string.h
bsp_clk.o: bsp_clk.c ../include/bsp/bsp_clk.h ../include/bsp/imx6ul.h \
 ../include/bsp/cc.h ../include/bsp/MCIMX6Y2.h \
 ../include/bsp/fsl_common.h ../include/bsp/fsl_iomuxc.h \
 ../include/bsp/core_ca7.h ../include/string.h
bsp_delay.o: bsp_delay.c ../include/bsp/bsp_delay.h \
 ../include/bsp/imx6ul.h ../include/bsp/cc.h ../include/bsp/MCIMX6Y2.h \
 ../include/bsp/fsl_common.h ../include/bsp/fsl_iomuxc.h \
 ../include/bsp/core_ca7.h ../include/string.h
bsp_epittimer.o: bsp_epittimer.c ../include/bsp/bsp_epittimer.h \
 ../include/bsp/imx6ul.h ../include/bsp/cc.h ../include/bsp/MCIMX6Y2.h \
 ../include/bsp/fsl_common.h ../include/bsp/fsl_iomuxc.h \
 ../include/bsp/core_ca7.h ../include/string.h ../include/bsp/bsp_int.h \
 ../include/bsp/bsp_led.h
bsp_exit.o: bsp_exit.c ../include/bsp/bsp_exit.h ../include/bsp/imx6ul.h \
 ../include/bsp/cc.h ../include/bsp/MCIMX6Y2.h \
 ../include/bsp/fsl_common.h ../include/bsp/fsl_iomuxc.h \
 ../include/bsp/core_ca7.h ../include/string.h ../include/bsp/bsp_gpio.h \
 ../include/bsp/bsp_int.h ../include/bsp/bsp_delay.h \
 ../include/bsp/bsp_beep.h
bsp_gpio.o: bsp_gpio.c ../include/bsp/bsp_gpio.h ../include/bsp/imx6ul.h \
 ../include/bsp/cc.h ../include/bsp/MCIMX6Y2.h \
 ../include/bsp/fsl_common.h ../include/bsp/fsl_iomuxc.h \
 ../include/bsp/core_ca7.h ../include/string.h
bsp_int.o: bsp_int.c ../include/bsp/bsp_int.h ../include/bsp/imx6ul.h \
 ../include/bsp/cc.h ../include/bsp/MCIMX6Y2.h \
 ../include/bsp/fsl_common.h ../include/bsp/fsl_iomuxc.h \
 ../include/bsp/core_ca7.h ../include/string.h
bsp_led.o: bsp_led.c ../include/bsp/bsp_led.h ../include/bsp/imx6ul.h \
 ../include/bsp/cc.h ../include/bsp/MCIMX6Y2.h \
 ../include/bsp/fsl_common.h ../include/bsp/fsl_iomuxc.h \
 ../include/bsp/core_ca7.h ../include/string.h
bsp_uart.o: bsp_uart.c ../include/bsp/bsp_uart.h ../include/bsp/imx6ul.h \
 ../include/bsp/cc.h ../include/bsp/MCIMX6Y2.h \
 ../include/bsp/fsl_common.h ../include/bsp/fsl_iomuxc.h \
 ../include/bsp/core_ca7.h ../include/string.h
