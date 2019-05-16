#include "main.h"

int main(int argc, char* argv[])
{
    
    int error = 0;
    error = InitialiseSenseHatI2C();
    return error;
}

int InitialiseSenseHatI2C()
{
    char i2cFileName[32];
    char dataBuffer[32];
    //Put the channel in the filename
    sprintf(i2cFileName, "/dev/i2c-%d", I2CCHANNEL);
    
    //Use fprintf for direct output, printf puts output in a buffer that doesn't always show directly over ssh.
	if ((file_led = open(i2cFileName, O_RDWR)) < 0) //Open the I2C file for read and write (Master).
	{
		fprintf(stderr, "Failed to open the i2c bus; need to run as sudo?\n");
		return -1;
	}
    
    //LED address is 0x46
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
    
    //HTS221 address (humidity and temperature) is 0x5f
    file_hum = open(i2cFileName, O_RDWR);
	if (ioctl(file_hum, I2C_SLAVE, 0x5f) < 0) //Open the I2C file for read and write (Slave).
	{
		fprintf(stderr, "Failed to acquire bus for Humidity sensor\n");
		ShutdownSenseHat();
        return -1;
	}
    
    printf("File_des led: %d acc: %d hum: %d\n", file_led, file_acc, file_hum);
    
    
    // Init accelerometer and gyroscope
	dataBuffer[0] = 0x60;                           //119hz accel
	WriteToI2C(file_acc, 0x20, dataBuffer);
	dataBuffer[0] = 0x38;                           //Enable gyro on all axes
	WriteToI2C(file_acc, 0x1e, dataBuffer);
    dataBuffer[0] = 0x28;                           //Data rate + full scale + bw selection
                                                    //Bits:        ODR_G2 | ODR_G1 | ODR_G0 | FS_G1 | FS_G0 | 0 | BW_G1 | BW_G0
                                                    //0x28 = 14.9hz, 500dps
    WriteToI2C(file_acc, 0x10, dataBuffer);      //Gyroscope ctrl_reg1
    
    
    int x, y, z;
    x = 0;
    y = 0;
    z = 0;
    
    
    while(1)
    {
        GetGyro(true, &x, &y, &z);
        printf("Gyro: x=%d, y=%d, z=%d\n", x, y ,z);
        usleep(1000000);
    }
    return 0;
}

int GetGyro(bool rawData, int *gx, int *gy, int *gz)
{
    char dataBufferTemp[8];
    int rc, i;

	rc = ReadFromI2C(file_acc, 0x28+0x80, dataBufferTemp);
    
    size_t dataLength = sizeof(dataBufferTemp) / sizeof(char*);
    printf("Databuffer data:");
    for(i = 0; i < dataLength + 1; i++)
    {
       printf("[%d]: 0x%X ", i, dataBufferTemp[i]);
    }
    printf("\n");
    
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

int GetTempHumid(int *temp, int *humidity)
{
    return 0;
}

int ReadFromI2C(int i2cFileDesc, char regAddr, char* dataBuffer)
{
    int rc;
    size_t dataLength = sizeof(dataBuffer) / sizeof(char*);
    if(dataLength == 0)
    {
        dataLength = 1;
    }
	rc = write(i2cFileDesc, &regAddr, 1);
    printf("RC: %d dataLength: %d, i2cFileDesc: %d\n", rc, dataLength, i2cFileDesc);
	if (rc == 1)
	{
		rc = read(i2cFileDesc, dataBuffer, dataLength);
	}
	return rc;
}

int WriteToI2C(int i2cFileDesc, char regAddr, char* dataBuffer)
{
    int rc, i;
    char dataBufferTemp[8];
    if(dataBuffer == NULL)
    {
        return -1;
    }
    
    dataBufferTemp[0] = regAddr; //Add the register address to the beginning of the array
    size_t dataLength = sizeof(dataBuffer) / sizeof(char*);
	memcpy(&dataBufferTemp[1], dataBuffer, dataLength); // followed by the data
    
    printf("Databuffer data:");
    for(i = 0; i < dataLength + 1; i++)
    {
       printf("[%d]: 0x%X ", i, dataBufferTemp[i]);
    }
    printf("\n");
    
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
	if (file_hum != -1) close(file_hum);
	if (file_acc != -1) close(file_acc);
	file_led = file_hum = file_acc = -1;
}