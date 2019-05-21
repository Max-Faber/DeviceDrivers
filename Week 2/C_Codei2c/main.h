#ifndef MAIN_H
#define MAIN_H

#include <stdio.h>
#include <stdbool.h>

#include <unistd.h>				//Needed for I2C port
#include <fcntl.h>				//Needed for I2C port
#include <sys/ioctl.h>			//Needed for I2C port
#include <linux/i2c-dev.h>		//Needed for I2C port
#include <stdint.h>

#include <string.h>             //memcpy

#define I2CCHANNEL 1
#define BITSPERRGBCOLOR 8
#define BYTESPERRGBVALUE 3
#define BITSPERCOLOR (BYTESPERRGBVALUE * BITSPERRGBCOLOR)

#define MATRIXAXISSIZE 8

    // bit definitions for joystick
#define JOY_DOWN 1
#define JOY_UP   4
#define JOY_LEFT 16
#define JOY_RIGHT 2
#define JOY_ENTER 8

#define RED 32768
#define GREEN 256
#define BLUE 30
#define OFF 0

uint8_t ArrowUp[MATRIXAXISSIZE][MATRIXAXISSIZE][BYTESPERRGBVALUE] = {
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 30, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 30, 0}, {0, 0, 0}},
    {{0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}};

uint8_t ArrowDown[MATRIXAXISSIZE][MATRIXAXISSIZE][BYTESPERRGBVALUE] = {
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}},
    {{0, 0, 0}, {0, 30, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 30, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}};

uint8_t ArrowLeft[MATRIXAXISSIZE][MATRIXAXISSIZE][BYTESPERRGBVALUE] = {
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}},
    {{0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}},
    {{0, 0, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}};

uint8_t ArrowRight[MATRIXAXISSIZE][MATRIXAXISSIZE][BYTESPERRGBVALUE] = {
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 0, 0}},
    {{0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}},
    {{0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}, {0, 30, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 30, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}}; 

uint8_t Crosshair[MATRIXAXISSIZE][MATRIXAXISSIZE][BYTESPERRGBVALUE] = {
    {{0, 0, 0}, {30, 0, 0}, {30, 0, 0}, {30, 0, 0}, {30, 0, 0}, {30, 0, 0}, {30, 0, 0}, {0, 0, 0}},
    {{30, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {30, 0, 0}},
    {{30, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {30, 0, 0}},
    {{30, 0, 0}, {0, 0, 0}, {0, 0, 0}, {30, 0, 0}, {30, 0, 0}, {0, 0, 0}, {0, 0, 0}, {30, 0, 0}},
    {{30, 0, 0}, {0, 0, 0}, {0, 0, 0}, {30, 0, 0}, {30, 0, 0}, {0, 0, 0}, {0, 0, 0}, {30, 0, 0}},
    {{30, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {30, 0, 0}},
    {{30, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {30, 0, 0}},
    {{0, 0, 0}, {30, 0, 0}, {30, 0, 0}, {30, 0, 0}, {30, 0, 0}, {30, 0, 0}, {30, 0, 0}, {0, 0, 0}}}; 
    
uint8_t Off[MATRIXAXISSIZE][MATRIXAXISSIZE][BYTESPERRGBVALUE] = {
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}}; 

/*  LED controller is a 24 bit shift register. 
*   Data is layed out like RRRRRRRR - GGGGGGGG - BBBBBBBB (in the standard config) per LED
*   
*
*/



//Make the I2C file descriptors available for all functions
static int file_led = -1; // LED array
static int file_acc = -1; // accelerometer/gyro
static unsigned char LEDArray[192];
//Create a global data buffer for all the functions


//Initialize the sensors on the Sense Hat and open the I2C channel.
int InitialiseSenseHatI2C(void);

//Command to read data from the I2C data buffer.
int ReadFromI2C(int i2cFileDesc, char regAddr, unsigned char* dataBuffer, size_t dataLength);

//Command to write data to the I2C data buffer. 
int WriteToI2C(int i2cFileDesc, char regAddr, unsigned char* dataBuffer, size_t dataLength);

//The LED matrix contains a buffer for all LEDS.
//The matrix needs an update command to show these colors.
int AddLedToPixelBuffer(char color[3], int x, int y);

//Send an update command to the LED matrix to show the colors.
int ShowLedMatrix(void);

//Get Gyroscope values, pass by reference.
int GetGyro(bool rawData, int *gx, int *gy, int *gz);

//Calculate 0-360 degree output.
int CalculateGyroDegrees(int *gx, int *gy, int *gz);

//Empty all registers on the sense hat, like the LED matrix buffer.
//Close all I2C channels.
void ShutdownSenseHat(void);

void SetJoystickDirection(unsigned char dir);

int SetPixel(int xPos, int yPos, uint8_t RGB_Red, uint8_t RGB_Green, uint8_t RGB_Blue);
void SetRegisterRGB();
unsigned char shReadJoystick(void);

#endif

