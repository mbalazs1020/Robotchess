#include <stdio.h>
#include "types.h"
#include "consts.h"
#include "modbus_driver.h"


int main(void)
{
	char s[3];

	printf("Connecting to robot: \n");

	// Csatlakozás
	while( robot_connect(DEBUG_IP, PORT) == false )
	{
		printf("Connection error! \n");
	}


	while(s != "ex")
	{
		printf("Write your input: \n");
		scanf("%s", s);

		printf("Your input was: %s \n", s);
	}

	// Kapcsolat bontás
	robot_disconnect();

	printf("Shutting down...");

	return 0;
}
