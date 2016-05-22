#include <stdio.h>
#include "modbus/modbus.h"

#define PLC_IP "192.168.0.104"
#define PORT 502

#define DEBUG_IP "192.168.1.65"

int main(void)
{
	modbus_t *plc = NULL;

	printf("Starting Modbus TPC communication: \n");

	plc = modbus_new_tcp(DEBUG_IP, PORT);

	if( modbus_connect(plc) == -1)
	{
		printf("Nyilv�n nem siker�lt m�g megnyitni, mert nincs senki a m�sik v�g�n. \n");
	}
	else
	{
		printf("Ez el�g indokolatlan. \n");
	}

	return 0;
}