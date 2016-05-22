#include "stdio.h"
#include "types.h"
#include "consts.h"
#include "modbus/modbus.h"

// Glob�lis v�ltoz�k
modbus_t *plc = NULL;

// Csatlakozunk
bool robot_connect(char * ip, int port)
{
	plc = modbus_new_tcp(ip, port);

	if(modbus_connect(plc) == -1)
	{
		return false;
	}
	return true;
}


// Lekapcsol�dunk
void robot_disconnect(void)
{
	modbus_close(plc);
	modbus_free(plc);
}


// Kik�ldj�k a parancsot
bool robot_sendCmd(CMD cmd)
{
	int ret = 0;

	// Ha exit-et k�ld�k, vagy allow1-et, akkor az els�be
	if( (cmd == CMD_ALLOW_MOVE_1) || (cmd == CMD_EXIT))
	{
		ret = modbus_write_register(plc, ADDR_CMD_1, (REG16) cmd );
	}
	// Ha allow2-t, akkor a m�sodikba
	else if( cmd == CMD_ALLOW_MOVE_2 )
	{
		ret = modbus_write_register(plc, ADDR_CMD_2, (REG16) cmd );
	}
	else
	{
		printf("Invalid command");
		return false;
	}

	if(ret == -1)
	{
		return false;
	}

	return true;
}

// Kik�ldj�k a l�p�s poz�ci�t a robotnak
bool robot_sendMoveData(MOVE move)
{
	int ret = 0;
	// Ebbe a t�mbbe �sszeszedem az adat minden r�sz�t
	REG16 regTemp[3] = {0, 0, 0};

	regTemp[0] = (REG16) move.source;
	regTemp[1] = (REG16) move.dest;
	regTemp[2] = (REG16) move.type;

	// Elk�ld�m
	ret = modbus_write_registers(plc, ADDR_MOVESOURCE, 3, regTemp);

	if (ret == -1)
	{
		return false;
	}

	return true;
}
