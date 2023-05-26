#include "bsp/bsp_uart.h"

void uart_init(void)
{

	uart_disable(UART); // Close UART
    // Set baud rate 115200
    UART->IBRD = 0x2;
    UART->FBRD = 0xB;

    UART->CR |= UART_ENABLE_RX_MASK | UART_ENABLE_TX_MASK;

	uart_enable(UART);

    puts("WYYMYWIFE");
    // putc('W');
    // putc('Y');
    // putc('Y');
    // putc('M');
    // putc('Y');
    // putc('W');
    // putc('I');
    // putc('F');
    // putc('E');
}

void uart_disable(UART_T *base)
{
	base->CR &= ~(1<<0);	
}

void uart_enable(UART_T *base)
{
	base->CR |= (1<<0);	
}
void putc(unsigned char c){
	while (UART->FR & UART_TX_FULL) {asm("nop");}
	UART->DR = c;
}

void puts(char *str)
{
	char *p = str;
	while(*p)
		putc(*p++);
}

unsigned char getc(void)
{
    while (UART->FR & UART_RX_EMPTY) {asm("nop");}
    return UART->DR;
}


void raise(int sig_nr) 
{

}


