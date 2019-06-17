/* Includes for printf() use, SWI-defines, and kernel-modules to do SWI-calls*/
#include <stdio.h>
#include "kernel.h"
#include "swis.h"

/* Function prototypes*/
void getBusCountI2C();
void detectDevicesI2C();

/* main() function calls the functions to get the amount of I2C-busses available and detect which devices are connected to the I2C-bus on what specific address*/
int main()
{
	getBusCountI2C();
	detectDevicesI2C();
	return 0;
}

/* Retreives the available amount of I2C-busses on the current system*/
void getBusCountI2C()
{
        /* Definition of a '_kernel_swi_regs' struct to inject and retreive parameters from the SWI-calls*/
        _kernel_swi_regs regs;

        /* Passing 14 to specify the I2C-bus count*/
        regs.r[0] = 14;
        /* Execution of the 'OS_ReadSysInfo SWI*/
        _kernel_swi(OS_ReadSysInfo, &regs, &regs);
        /* Printing the result which is stored in the '_kernel_swi_regs' struct*/
        printf("I2C bus count: %d\n", regs.r[0]);
}

void detectDevicesI2C()
{
       /* Definition of a '_kernel_swi_regs' struct to inject and retreive parameters from the SWI-calls*/
       _kernel_swi_regs regs;
       int i, res, block = 0;

       /* Loop through every possible device-address of the I2C-bus*/
       for(i = 0x03; i < 0x77; i++)
       {
             /* Set the first parameter of the '_kernel_swi_regs' struct to the current address and shift 1 position to the left since bits 1-7 represent the device address
             Bit 0 will remain unset to select write-mode*/
             regs.r[0] = i << 1;
             /* Set the second parameter of the '_kernel_swi_regs' struct to the pointer of the data that will be sent*/
             regs.r[1] = (int)&block;
             /* Set the third parameter of the '_kernel_swi_regs' struct to the size of the data that will be sent*/
             regs.r[2] = sizeof(block);
             /* Excecute the 'IIC_Control' SWI in write-mode*/
             _kernel_swi(IIC_Control, &regs, &regs);

             /* Set the 'res' variable to -1 as an indicator of no result being retreived*/
             res = -1;
             /* Set the first parameter of the '_kernel_swi_regs' struct to the current address and shift 1 position to the left since bits 1-7 represent the device address*/
             regs.r[0] = i << 1;
             /* Set bit 0 of the first parameter of the '_kernel_swi_regs' struct to select read-mode*/
             regs.r[0] += 1;
             /* Set the second parameter of the '_kernel_swi_regs' struct to the pointer of the variable where the retreived data can be stored*/
             regs.r[1] = (int)&res;
             /* Set the third parameter of the '_kernel_swi_regs' struct to the size of the variable where the retreived data can be stored*/
             regs.r[2] = sizeof(res);
             /* Excecute the 'IIC_Control SWI in read-mode*/
             _kernel_swi(IIC_Control, &regs, &regs);
             /* Check whether there is a device active on the current address
                If so, notify the user with usefull information*/
             if(res != -1)
                    printf("Device detected at 0x%X (bitshifted: %d)\n", i, i << 1);
       }
}