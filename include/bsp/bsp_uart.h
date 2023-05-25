#ifndef _BSP_UART_H
#define _BSP_UART_H
#include "imx6ul.h"

#define _R volatile
#define _RW volatile
#define _W volatile

typedef struct {
    _RW uint32_t DR; 
    // Data Register 0x000
    _RW uint32_t RSR_ECR; 
    // Receive Status Register/Error Clear Register 0x004
    uint8_t RESERVED_0[0x6];
    // 0x008 ~ 0x014
    _RW uint32_t FR;
    // Flag Register 0x018
    uint8_t RESERVED_1[0x2];
    // 0x01C ~ 0x020
    _RW uint32_t ILPR;
    // IrDA Low-Power Counter Register 0x020
    _RW uint32_t IBRD;
    // Integer Baud Rate Register 0x024
    _RW uint32_t FBRD;
    // Fractional Baud Rate Register 0x028
    _RW uint32_t LCR_H;
    // Line Control Register 0x02C
    _RW uint32_t CR;
    // Control Register 0x030
    _RW uint32_t IFLS;
    // Interrupt FIFO Level Select Register 0x034
    _RW uint32_t IMSC;
    // Interrupt Mask Set/Clear Register 0x038
    _R uint32_t RIS;
    // Raw Interrupt Status Register 0x03C
    _R uint32_t MIS;
    // Masked Interrupt Status Register 0x040
    _W uint32_t ICR;
    // Interrupt Clear Register 0x044
    _RW uint32_t DMACR;
    // DMA Control Register 0x048
} UART_T;

#define UART_BASE                               (0x9000000)
#define UART                                    ((UART_T *)UART_BASE)
#define UART_ENABLE_RX_MASK                     (1 << 9)
#define UART_ENABLE_TX_MASK                     (1 << 8)
#define UART_TX_FULL                            (1 << 5)
#define UART_RX_EMPTY                           (1 << 4)

void uart_init(void);
void uart_disable(UART_T *base);
void uart_enable(UART_T *base);
void putc(unsigned char c);
void puts(char *str);
unsigned char getc(void);
void raise(int sig_nr);


#endif
