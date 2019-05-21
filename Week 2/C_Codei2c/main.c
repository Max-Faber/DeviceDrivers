#include "main.h"

//TODO: fix joystick input
//      fix own gyro init    


int main(int argc, char* argv[])
{
    int error = 0;
    error = InitialiseSenseHatI2C();    
    return error;
}

void SetJoystickDirection(unsigned char dir)
{
    int x, y;
    uint8_t Arrow[BITSPERRGBCOLOR][BITSPERRGBCOLOR][BYTESPERRGBVALUE];
    //Prepare LED matrix arrow directions
    switch (dir)
    {
        case JOY_DOWN:
            memcpy(Arrow, ArrowDown, sizeof(uint8_t) * MATRIXAXISSIZE * MATRIXAXISSIZE * BYTESPERRGBVALUE);
        break;
        case JOY_UP:
            memcpy(Arrow, ArrowUp, sizeof(uint8_t) * MATRIXAXISSIZE * MATRIXAXISSIZE * BYTESPERRGBVALUE);
        break;
        case JOY_LEFT:
            memcpy(Arrow, ArrowLeft, sizeof(uint8_t) * MATRIXAXISSIZE * MATRIXAXISSIZE * BYTESPERRGBVALUE);
        break;
        case JOY_RIGHT:
            memcpy(Arrow, ArrowRight, sizeof(uint8_t) * MATRIXAXISSIZE * MATRIXAXISSIZE * BYTESPERRGBVALUE);
        break;
        case JOY_ENTER:
            memcpy(Arrow, Crosshair, sizeof(uint8_t) * MATRIXAXISSIZE * MATRIXAXISSIZE * BYTESPERRGBVALUE);
        break;
        default:
            memcpy(Arrow, Off, sizeof(uint8_t) * MATRIXAXISSIZE * MATRIXAXISSIZE * BYTESPERRGBVALUE);
        break;
    }
    
    for (y=0; y < MATRIXAXISSIZE; y++) // do 64 pixels (whole matrix)
	{
        for(x = 0; x < MATRIXAXISSIZE; x++)
        {
            SetPixel(x, y, Arrow[y][x][0], Arrow[y][x][1], Arrow[y][x][2]);
        }
	}
    x = 0;
    y = 0;
	SetRegisterRGB(); // force an update
}

int InitialiseSenseHatI2C()
{
    char i2cFileName[32];
    unsigned char dataBuffer[32];
    //Put the channel in the filename
    sprintf(i2cFileName, "/dev/i2c-%d", I2CCHANNEL);
    
    //Use fprintf for direct output, printf puts output in a buffer that doesn't always show directly over ssh.
	if ((file_led = open(i2cFileName, O_RDWR)) < 0) //Open the I2C file for read and write (Master).
	{
		fprintf(stderr, "Failed to open the i2c bus; need to run as sudo?\n");
		return -1;
	}
    printf("file_led: %d\n");
    //LED address is 0x46
    printf("I2C_SLAVE: %d\n", I2C_SLAVE);
	if (ioctl(file_led, I2C_SLAVE, 0x46) < 0) //Open the I2C file for read and write (Slave).
	{
		fprintf(stderr, "Failed to acquire bus for LED matrix\n");
		ShutdownSenseHat();
        return -1;
	}

    //LSM9DS1 address (accelerometer and gyro) is 0x6a
	file_acc = open(i2cFileName, O_RDWR);
	if (ioctl(file_acc, I2C_SLAVE, 0x6a) < 0) //Open the I2C file for read and write (Slave).
	{
		fprintf(stderr, "Failed to acquire bus for accelerometer\n");
		ShutdownSenseHat();
        return -1;
	}

    
    printf("File_des led: %d acc: %d\n", file_led, file_acc);
    
    
    // Init accelerometer and gyroscope
	dataBuffer[0] = 0x60;                           //119hz accel
	WriteToI2C(file_acc, 0x20, dataBuffer, 1);
	dataBuffer[0] = 0x38;                           //Enable gyro on all axes
	WriteToI2C(file_acc, 0x1e, dataBuffer, 1);
    dataBuffer[0] = 0x28;                           //Data rate + full scale + bw selection
                                                    //Bits:        ODR_G2 | ODR_G1 | ODR_G0 | FS_G1 | FS_G0 | 0 | BW_G1 | BW_G0
                                                    //0x28 = 14.9hz, 500dps
    WriteToI2C(file_acc, 0x10, dataBuffer, 1);      //Gyroscope ctrl_reg1


    int x, y, z;
    x = 0;
    y = 0;
    z = 0;

    while(true)
    {
        printf("Joystick: %d\n", shReadJoystick());
    }

    while(1)
    {
        
    	SetJoystickDirection(10);
        GetGyro(true, &x, &y, &z);
        printf("Gyro: x=%d, y=%d, z=%d\n", x, y ,z);
        usleep(1000000);
    }
    return 0;
}

int SetPixel(int xPos, int yPos, uint8_t RGB_Red, uint8_t RGB_Green, uint8_t RGB_Blue)
{
	if(xPos < 0 || xPos > 8)
		return 0;
	else if(yPos < 0 || yPos > 8)
		return 0;

	else if(file_led < 0)
		return 0;
	int LED_Register_Index_Starting_Point = (yPos * BITSPERCOLOR) + xPos;

	LEDArray[LED_Register_Index_Starting_Point] = RGB_Red;
	LEDArray[LED_Register_Index_Starting_Point + 8] = RGB_Green;
	LEDArray[LED_Register_Index_Starting_Point + 16] = RGB_Blue;
    printf("(%d, %d): %d, %d, %d\n", xPos, yPos, RGB_Red, RGB_Green, RGB_Blue);
	return 1;
}

void SetRegisterRGB()
{
    //for(int i = 0; i < 192; i++)
    //{
    //    printf("%hhx ", LEDArray[i]);
    //}
    printf("\n\n");
	WriteToI2C(file_led, 0, LEDArray, 192);
    printf("\n\n");
}

//
// Set a single pixel on the 8x8 LED Array
//
int shSetPixel(int x, int y, uint16_t color, int bUpdate)
{
int i;

	if (x >= 0 && x < 8 && y >= 0 && y < 8 && file_led >= 0)
	{
		i = (y*24)+x; // offset into array
		LEDArray[i] = (uint8_t)((color >> 10) & 0x3e); // Red
		LEDArray[i+8] = (uint8_t)((color >> 5) & 0x3f); // Green
		LEDArray[i+16] = (uint8_t)((color << 1) & 0x3e); // Blue
		if (bUpdate)
		{
			//i2cWrite(file_led, 0, LEDArray, 192); // have to send the whole array at once
		}
		return 1;
	}
	return 0;
} /* shSetPixel() */

int GetGyro(bool rawData, int *gx, int *gy, int *gz)
{
    unsigned char dataBufferTemp[8];
    int rc;

	rc = ReadFromI2C(file_acc, 0x28, dataBufferTemp, 6);
    
	if (rc == 6)
	{
        int x, y, z;
        printf("read succesfull");
		x = dataBufferTemp[0] + (dataBufferTemp[1] << 8);
		y = dataBufferTemp[2] + (dataBufferTemp[3] << 8);
		z = dataBufferTemp[4] + (dataBufferTemp[5] << 8);
		// fix the signed values
		//if (x > 32767) x -= 65536;
        //if (y > 32767) y -= 65536;
		//if (z > 32767) z -= 65536;
		*gx = x; 
        *gy = y; 
        *gz = z;
		return 1;
	}
	return 0;
}

int CalculateGyroDegrees(int *gx, int *gy, int *gz)
{
    return 0;
}

int ReadFromI2C(int i2cFileDesc, char regAddr, unsigned char* dataBuffer, size_t dataLength)
{
    int rc;
	rc = write(i2cFileDesc, &regAddr, 1);
	if (rc == 1)
	{
		rc = read(i2cFileDesc, dataBuffer, dataLength);
	}
	return rc;
}

int WriteToI2C(int i2cFileDesc, char regAddr, unsigned char* dataBuffer, size_t dataLength)
{
    int rc;
    unsigned char dataBufferTemp[512];
    if(dataBuffer == NULL)
    {
        return -1;
    }
    
    dataBufferTemp[0] = regAddr; //Add the register address to the beginning of the array
    printf("dataBufferTemp[0] = 0x%X\n", regAddr);
	memcpy(&dataBufferTemp[1], dataBuffer, dataLength); // followed by the data

    for(int i = 0; i < 512; i++)
    {
        printf("0x%X, ", dataBufferTemp[i]);
    }

	rc = write(i2cFileDesc, dataBufferTemp, dataLength + 1);
	return rc-1;
}

void ShutdownSenseHat(void)
{
	// Close all I2C file handles
	if (file_led != -1) 
    {  
        // Blank the LED array
        //memset(LEDArray, 0, sizeof(LEDArray));
        //i2cWrite(file_led, 0, LEDArray, 192);
        close(file_led);
    }
	if (file_acc != -1) close(file_acc);
	file_led = file_acc = -1;
}

unsigned char shReadJoystick(void)
{
unsigned char ucBuf[2];
int rc;

    if (file_led != -1)
    {
        rc = ReadFromI2C(file_led, 0xf2, ucBuf, 1);
        if (rc == 1)
            return ucBuf[0];
    }
    return 0;
} /* shReadJoystick() */