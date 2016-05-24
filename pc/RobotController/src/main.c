#include <stdio.h>
#include "types.h"
#include "consts.h"
#include "modbus_driver.h"


int main(void)
{
	int input = 0;
	int source = 0;
	int dest = 0;
	MOVE move;

	printf("Connecting to robot: \n");

	// Csatlakozás
	while( robot_connect(PLC_IP, PORT) == false )
	{
		printf("Connection error! \n");
	}

	printf("Connection successful. \n");

	while(input != -1)
	{
		int i = 0;
		printf("Move soure: \n");
		scanf("%d", &input);
		source = input;

		if(input != -1)
		{
			printf("Move destination: \n");
			scanf("%d", &input);
			dest = input;
		}

		if(input != -1)
		{
			printf("Starting normal move from %d to %d \n", source, dest);
			move.source = source;
			move.dest = dest;
			move.type = NORMAL_MOVE;

			robot_sendMove(move);
		}

	}

	robot_sendCmd(CMD_EXIT);

	// Kapcsolat bontás
	robot_disconnect();

	printf("Shutting down robot... \n Disconnecting... \n");

	return 0;
}
