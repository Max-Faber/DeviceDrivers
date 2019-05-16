#ifndef MAIN_H
#define MAIN_H

#include <stdio.h>
#include <stdbool.h>

#include <unistd.h>				//Needed for I2C port
#include <fcntl.h>				//Needed for I2C port
#include <sys/ioctl.h>			//Needed for I2C port
#include <linux/i2c-dev.h>		//Needed for I2C port

#include <string.h>             //memcpy

#define I2CCHANNEL 1

/*  LED controller is a 24 bit shift register. 
*   Data is layed out like RRRRRRRR - GGGGGGGG - BBBBBBBB (in the standard config) per LED
*   
*
*/



//Make the I2C file descriptors available for all functions
static int file_led = -1; // LED array
static int file_hum = -1; // humidity/temp sensor
static int file_acc = -1; // accelerometer/gyro
//Create a global data buffer for all the functions


//Initialize the sensors on the Sense Hat and open the I2C channel.
int InitialiseSenseHatI2C(void);

//Command to read data from the I2C data buffer.
int ReadFromI2C(int i2cFileDesc, char regAddr, char* dataBuffer);

//Command to write data to the I2C data buffer. 
int WriteToI2C(int i2cFileDesc, char regAddr, char* dataBuffer);

//The LED matrix contains a buffer for all LEDS.
//The matrix needs an update command to show these colors.
int AddLedToPixelBuffer(char color[3], int x, int y);

//Send an update command to the LED matrix to show the colors.
int ShowLedMatrix(void);

//Get Gyroscope values, pass by reference.
int GetGyro(bool rawData, int *gx, int *gy, int *gz);

//Calculate 0-360 degree output.
int CalculateGyroDegrees(int *gx, int *gy, int *gz);

//Get Temperatur values, pass by reference.
int GetTempHumid(int *temp, int *humidity);

//Empty all registers on the sense hat, like the LED matrix buffer.
//Close all I2C channels.
void ShutdownSenseHat(void);


#endif

