/***************************************************************
Copyright © laoyening Co., Ltd. 1998-2019. All rights reserved.
文件名	: 	 start.s
作者	   : 劳业宁
版本	   : V1.0
描述	   : LINUX 0.11 ARM MX6ULL开发板启动文件，完成C环境初始化，
		 C环境初始化完成以后跳转到C代码。
其他	   : 无
**************************************************************/

.equ DISABLE_IRQ,0x80
.equ DISABLE_FIQ,0x40
.equ SYS_MOD,0x1f
.equ IRQ_MOD,0x12
.equ FIQ_MOD,0x11
.equ SVC_MOD,0x13
.equ ABT_MOD,0x17
.equ UND_MOD,0x1b
.equ MOD_MASK,0x1f

.global _start  				/* 全局标号 */

.macro CHANGE_TO_SVC
        msr     cpsr_c,#(SVC_MOD)
.endm

.macro CHANGE_TO_IRQ
        msr     cpsr_c,#(IRQ_MOD)
.endm

.macro CHANGE_TO_SYS
        msr     cpsr_c,#(SYS_MOD)
.endm


/*
 * 描述：	_start函数，首先是中断向量表的创建
 * 参考文档:ARM Cortex-A(armV7)编程手册V4.0.pdf P42，3 ARM Processor Modes and Registers（ARM处理器模型和寄存器）
 * 		 	ARM Cortex-A(armV7)编程手册V4.0.pdf P165 11.1.1 Exception priorities(异常)
 */
_start:
	bl Reset_Handler		/* 复位中断 					*/	
	ldr pc, =Undefined_Handler	/* 未定义中断 					*/
	ldr pc, =SVC_Handler		/* SVC(Supervisor)中断 		*/
	ldr pc, =PrefAbort_Handler	/* 预取终止中断 					*/
	ldr pc, =DataAbort_Handler	/* 数据终止中断 					*/
	ldr	pc, =NotUsed_Handler	/* 未使用中断					*/
	ldr pc, =IRQ_Handler		/* IRQ中断 					*/
	ldr pc, =FIQ_Handler		/* FIQ(快速中断)未定义中断 			*/

.equ SVC_Stack_Size,     0x00000100
.equ IRQ_STACK_Size,  0x00000800

.align 4
stack_begin:
.rept (SVC_Stack_Size + IRQ_STACK_Size)
.byte 0
.endr
stack_top:

/* 复位中断 */	
Reset_Handler:
	cpsid i						/* 关闭全局中断 */

	/* 关闭I,DCache和MMU 
	 * 采取读-改-写的方式。
	 */
	mrc     p15, 0, r0, c1, c0, 0     /* 读取CP15的C1寄存器到R0中       		        	*/
    bic     r0,  r0, #(0x1 << 12)     /* 清除C1寄存器的bit12位(I位)，关闭I Cache            	*/
    bic     r0,  r0, #(0x1 <<  2)     /* 清除C1寄存器的bit2(C位)，关闭D Cache    				*/
    bic     r0,  r0, #0x2             /* 清除C1寄存器的bit1(A位)，关闭对齐						*/
    bic     r0,  r0, #(0x1 << 11)     /* 清除C1寄存器的bit11(Z位)，关闭分支预测					*/
    bic     r0,  r0, #0x1             /* 清除C1寄存器的bit0(M位)，关闭MMU				       	*/
    mcr     p15, 0, r0, c1, c0, 0     /* 将r0寄存器中的值写入到CP15的C1寄存器中	 				*/

#if 0	
	/* 汇编版本设置中断向量表偏移 */
	ldr r0, =0X87800000

	dsb
	isb
	mcr p15, 0, r0, c12, c0, 0
	dsb
	isb
#endif

	/* 设置各个模式下的栈指针，
	 * 注意：IMX6UL的堆栈是向下增长的！
	 * 堆栈指针地址一定要是4字节地址对齐的！！！
	 * DDR范围:0X80000000~0X9FFFFFFF
	 */
	mov r7, #0x1000
    sub r7, #1
    mvn r8, r7

    ldr r6, =stack_start
	ldr r6, [r6]
	and r6, r8
	add r6, #0xC0000000
	mov sp, r6

	/* 进入SYS模式 */
	mrs r0, cpsr
	bic r0, r0, #0x1f 	/* 将r0寄存器中的低5位清零，也就是cpsr的M0~M4 	*/
	orr r0, r0, #0x1f 	/* r0或上0x13,表示使用SYS模式					*/
	msr cpsr, r0		/* 将r0 的数据写入到cpsr_c中 					*/
	
	add r6, r6, #0X1000	
	mov sp, r6


	cpsie i				/* 打开全局中断 */

   @清除16kb页表地址
   bl clean_page_table

   @ 映射内核地址
   ldr r0,=__text_start
   ldr r1,=__bss_end
   ldr r2,=0x80000000
   ldr r3,=0x1
   bl  create_page_table               @ 设置页表


   adr	r0, __turn_mmu_on_loc
   ldmia r0, {r3, r5, r6}	
   sub	r0, r0, r3			@ virt->phys offset
   add	r5, r5, r0			@ phys __turn_mmu_on
   add	r6, r6, r0			@ phys __turn_mmu_on_end
   
   mov r0,r5
   mov r1,r6
   mov r2,r5
   ldr r3,=0x1
   bl  create_page_table               @ 设置页表

   @映射led寄存器地址
   ldr r0,=0x02000000
   ldr r1,=0x03000000
   ldr r2,=0x02000000
   ldr r3,=0x0
   bl  create_page_table               @ 设置页表

   @映射uart寄存器地址
   ldr r0,=0x09000000
   ldr r1,=0x09010000
   ldr r2,=0x09000000
   ldr r3,=0x0
   bl  create_page_table               @ 设置页表



   @映射led测试地址
   ldr r0,=0x0B000000
   ldr r1,=0x0B000000
   ldr r2,=0x02000000
   ldr r3,=0x0
   bl  create_page_table               @ 设置页表

   @映射GIC
   ldr r0,=0x08000000
   ldr r1,=0x08200000
   ldr r2,=0x08000000
   ldr r3,=0x0
   bl  create_page_table               @ 设置页表

   @映射中断向量表基地址，避免开启mmu后无法使用中断
   ldr r0,=0xA00000
   ldr r1,=0xA00000
   ldr r2,=0xA00000
   ldr r3,=0x0
   bl  create_page_table               @ 设置页表

   @映射
   ldr r0,=0x30000000
   ldr r1,=0x40000000
   ldr r2,=0x30000000
   ldr r3,=0x0
   bl  create_page_table               @ 设置页表

__turn_mmu_on:
   bl  mmu_init                        @ 启动MMU
__turn_mmu_on_end:
     
   mov r7, #0x1000
   sub r7, #1
   mvn r8, r7

    ldr r6, =stack_start
	ldr r6, [r6]

    cpsid i
	/* 进入IRQ模式 */
	ldr r0, =stack_top
	CHANGE_TO_IRQ
	mov sp, r0

	/* 进入SVC模式 */
	CHANGE_TO_SVC
	sub r0, r0,#IRQ_STACK_Size
	mov sp, r0

	/* 进入SYS模式 */
	CHANGE_TO_SYS
	and r6, r8
	add r6, r6, #0X1000	
	mov sp, r6

    cpsie i				/* 打开全局中断 */

	mrs r0, cpsr		/* 读取cpsr寄存器值到r0中 			*/
	bic r0, r0, #0x80	/* 将r0寄存器中bit7清零，也就是CPSR中的I位清零，表示允许IRQ中断 */
	msr cpsr, r0		/* 将r0重新写入到cpsr中 			*/

	cpsid i
	cpsid f
	cpsid a

    bl main

/* 未定义中断 */
Undefined_Handler:
	ldr r0, =Undefined_Handler
	bx r0

/* SVC中断 */
SVC_Handler:
	stmdb sp!, {r0-r12,lr}
	CHANGE_TO_SYS
	push {r0 - r3, r12}
	and r0, r7, #0xff
	bl  system_call
	mov r6,r0
	pop {r0 - r3, r12}
	blx r6
	CHANGE_TO_SVC
	ldmia sp!, {r0-r12,pc}^


	

/* 预取终止中断 */
PrefAbort_Handler:
	ldr r0, =PrefAbort_Handler	
	bx r0

/* 数据终止中断 */
DataAbort_Handler:
	ldr r0, =DataAbort_Handler
	mrc p15, 0, r1, c5, c0, 0
	bx r0

/* 未使用的中断 */
NotUsed_Handler:

	ldr r0, =NotUsed_Handler
	bx r0

/* IRQ中断！重点！！！！！ */
IRQ_Handler:
@	bl led_on
	push {lr}					/* 保存lr地址 */
	push {r0-r3, r12}			/* 保存r0-r3，r12寄存器 */

	mrs r0, spsr				/* 读取spsr寄存器 */
	push {r0}					/* 保存spsr寄存器 */
	
	mrc p15, 4, r3, c15, c0, 0 /* 从CP15的C0寄存器内的值到R1寄存器中
								* 参考文档ARM Cortex-A(armV7)编程手册V4.0.pdf P49
								* Cortex-A7 Technical ReferenceManua.pdf P68 P138
								*/							
	add r3, r3, #0X2000			/* GIC基地址加0X2000，也就是GIC的CPU接口端基地址 */
	ldr r0, [r3, #0XC]			/* GIC的CPU接口端基地址加0X0C就是GICC_IAR寄存器，
								 * GICC_IAR寄存器保存这当前发生中断的中断号，我们要根据
								 * 这个中断号来绝对调用哪个中断服务函数
								 */
	push {r0, r3}				/* 保存r0,r1 */

	ldr r2, =system_irqhandler	/* 加载C语言中断处理函数到r2寄存器中*/
	bl led_on
	blx r2						/* 运行C语言中断处理函数，带有一个参数，保存在R0寄存器中 */

	pop {r0, r3}				
	str r0, [r3, #0X10]			/* 中断执行完成，写EOIR */

	
	pop {r0}						
	msr spsr_cxsf, r0			/* 恢复spsr */

	pop {r0-r3, r12}			/* r0-r3,r12出栈 */
	pop {lr}					/* lr出栈 */
	subs pc, lr, #4				/* 将lr-4赋给pc */

/* FIQ中断 */
FIQ_Handler:

	ldr r0, =FIQ_Handler	
	bx r0									

led_on:
	@ 使能GPIO时钟
	ldr r0,=0xB0c406c
	ldr r1,=0xffffffff
	str r1,[r0]

	@ 设置引脚复用为GPIO
	ldr r0,=0xB0e006c
	ldr  r1,=5
	str r1,[r0]


	@ 设置引脚属性(上下拉、速率、驱动能力)
	ldr r0,=0xB0e02f8
	ldr  r1,=0x10b0
	str r1,[r0]

	@ 控制GPIO引脚输出高低电平
	ldr r0,=0x0B09c004
	ldr  r1,=16
	str r1,[r0]

	ldr r0,=0x0B09c000
	ldr  r1,=0
	str r1,[r0]

	mov pc, lr

__turn_mmu_on_loc:
	.long	.
	.long	__turn_mmu_on
	.long	__turn_mmu_on_end

