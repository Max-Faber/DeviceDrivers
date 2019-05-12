#include "devdriv_2a.h"


// The LED Array is handled by a dedicated microcontroller
// It must be updated in a single shot by writing
// 192 bytes starting at register 0
// The memory is laid out in each row like this:
// RRRRRRRRGGGGGGGGBBBBBBBB
// Each byte can have 64 unique levels (0-63)

void SetJoystickDirection(unsigned char dir, int gyrox, int gyroy, int gyroz)
{
    int i, j, ledx, ledy;
    uint16_t color;
    //Prepare LED matrix color values
    
    
    //Prepare LED matrix arrow directions
    int x = 7;
    int y = 7;
    for (i=0; i < 8; i++) // do 64 pixels (whole matrix)
	{
		color = 8388608 >> i; // blue 
		//color |= 255; // green
		//color |= 255; // red
		x = 8 - i;
		y = 8 - i;
		shSetPixel(x, y, color, 0);
		//usleep(100000);
	}
	shSetPixel(x, y, color, 1); // force an update
    
    //Show result
}


int main(int argc, char *argv[])
{
    unsigned char joystickValues;
    int gyrox, gyroy, gyroz; 
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
    //Start an infinite loop to update joystick directions.
    while(1)
    {
        //Get the value from the joystick if a button is pressed.
        joystickValues = shReadJoystick();
        //Base the arrow colors on gyro values.
        if(joystickValues > 0)
        {
            shGetGyro(&gyrox, &gyroy, &gyroz);
            SetJoystickDirection(joystickValues, gyrox, gyroy, gyroz);
        }
    }
    shShutdown();
	return 0;
}    