#include "devdriv_2a.h"


void sighandler(int signum)
{
    shShutdown(); //Free resources
    exit(1);
}

// The LED Array is handled by a dedicated microcontroller
// It must be updated in a single shot by writing
// 192 bytes starting at register 0
// The memory is laid out in each row like this:
// RRRRRRRR GGGGGGGG BBBBBBBB
// Each byte can have 64 unique levels (0-63)

void SetJoystickDirection(unsigned char dir)
{
    int x, y;
    uint16_t Arrow[8][8];
    //Prepare LED matrix arrow directions
    switch (dir)
    {
        case JOY_DOWN:
            memcpy(Arrow, ArrowDown, sizeof(uint16_t) * MATRIXAXISSIZE * MATRIXAXISSIZE);
        break;
        case JOY_UP:
            memcpy(Arrow, ArrowUp, sizeof(uint16_t) * MATRIXAXISSIZE * MATRIXAXISSIZE);
        break;
        case JOY_LEFT:
            memcpy(Arrow, ArrowLeft, sizeof(uint16_t) * MATRIXAXISSIZE * MATRIXAXISSIZE);
        break;
        case JOY_RIGHT:
            memcpy(Arrow, ArrowRight, sizeof(uint16_t) * MATRIXAXISSIZE * MATRIXAXISSIZE);
        break;
        case JOY_ENTER:
            memcpy(Arrow, Crosshair, sizeof(uint16_t) * MATRIXAXISSIZE * MATRIXAXISSIZE);
        break;
        default:
            memcpy(Arrow, Off, sizeof(uint16_t) * MATRIXAXISSIZE * MATRIXAXISSIZE);
        break;
    }
    
    for (y=0; y < MATRIXAXISSIZE; y++) // do 64 pixels (whole matrix)
	{
        for(x = 0; x < MATRIXAXISSIZE; x++)
        {
            shSetPixel(x, y, Arrow[y][x], 0);
        }
	}
    x = 0;
    y = 0;
	shSetPixel(x, y, Arrow[y][x], 1); // force an update
}


int main(int argc, char *argv[])
{
    unsigned char joystickValues;
    int gyrox, gyroy, gyroz; 
    int temp, humid;
    //Rpi uses the /dev/i2c-1 driver, so send 1 to the init function.
    if (shInit(1) == 0) // Open I2C.
    {
        printf("Unable to open sense hat; is it connected?\n");
        return -1;
    }
    joystickValues = 0;
    gyrox = 0;
    gyroy = 0;
    gyroz = 0;
    temp = 0;
    humid = 0;
    signal(SIGINT, sighandler);
    //Start an infinite loop to update joystick directions.
    while(1)
    {
        joystickValues = shReadJoystick();
        if(joystickValues > 0)
        {
            printf("Joystick value = %02x\n", joystickValues);
            SetJoystickDirection(joystickValues);
        }
        else
        {
            shGetGyro(&gyrox, &gyroy, &gyroz);
            printf("Gyro value: x = %d, y = %d, z = %d \n", gyrox, gyroy, gyroz);
            shGetTempHumid(&temp, &humid);
            printf("Temperature and humidity values: temp = %d, humid = %d \n", temp, humid);
            fflush(stdout);
            usleep(500000);
        }
    }
    shShutdown();
	return 0;
}    