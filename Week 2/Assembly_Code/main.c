#include"LPC210x.h"
void Initialize(void);
 © Koninklijke Philips Electronics N.V. 2005. All rights reserved.
Application note Rev. 01 — 06 April 2005 11 of 17
Philips Semiconductors AN10369
Philips ARM LPC microcontroller family
/* I2C ISR */
__irq void I2 C _ISR(void);
/* Master Transmitter states */
void ISR_8(void);
void ISR_18(void);
void ISR_28(void);
/*************************** MAIN ************************/
int main()
 {
/* Initialize system */
 Initialize ();

/* Send start bit */
 I2C ONSET=0x60;

 /* Do forever */
 while(1)
 {
 IOCLR=0x40;
 IOSET=0x40;
 }
 }
/*************** System Initialization ***************/
void Initialize()
{
/* Remap interrupt vectors to SRAM */
 MEMMAP=0x2;

/* Initialize GPIO ports to be used as indicators */
 IODIR=0xF0;
 IOSET=0xF0;
/* Initialize Pin Connect Block */
 PINSEL0=0x50;

 /* Initialize I2C */
I2CONCLR=0x6c; /* clearing all flags */
 I2CONSET=0x40; /* enabling I2C */
 I2SCLH=0xC; /* 100 KHz */
 I2SCLL=0xD;

 /* Initialize VIC for I2C use */
VICINTSEL=0x0; /* selecting IRQ */
 VICINTEN= 0x200; /* enabling I2C */
VICCNTL0= 0x29; /* highest priority and enabled */
 VICVADDR0=(unsigned long) I2C_ISR;
/* ISR address written to the respective address register*/
}
/********************** I2 C ISR **************************/
__irq void I2C_ISR()
 {
 int temp=0;


 temp=I2STAT;

 switch(temp)
 {
 case 8:
 ISR_8();
 break;

 case 24:
 ISR_18();
 break;

 case 40:
 ISR_28();
 break;

 default :
 break;
 }

 VICVADDR=0xFF;

 }


/* I2C states*/
/* Start condition transmitted */
void ISR_8()
 {
/* Port Indicator */
 IOCLR=0x10;
/* Slave address + write */
 I2DAT=0x74;
/* Clear SI and Start flag */
 I2CONCLR=0x28;
/* Port Indicator */
 IOSET=0x10;
 }
/* Acknowledgement received from slave for slave address */
void ISR_18()
 {
/* Port Indicator */
 IOCLR=0x20;
/* Data to be transmitted */
 I2DAT=0x55;
/* clear SI */
 I2CONCLR=0x8;
 /* Port Indicator */
 IOSET=0x20;
 }

/* Acknowledgement received from slave for byte transmitted from master. Stop
condition is transmitted in this state signaling the end of transmission */
void ISR_28()
 {
/* Port Indicator */
 IOCLR=0x80;
/* Transmit stop condition */
 I2CONSET=0x10;
/* clear SI */
 I2CONCLR=0x8;
/* Port Indicator */
 IOSET=0x80;
 }


/********************************************************/ 