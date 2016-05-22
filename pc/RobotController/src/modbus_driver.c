#include "stdio.h"
#include "types.h"
#include "consts.h"
#include "modbus/modbus.h"

// Globális változók
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


// Lekapcsolódunk
void robot_disconnect(void)
{
	modbus_close(plc);
	modbus_free(plc);
}


// Kiküldjük a parancsot
bool robot_sendCmd(CMD cmd)
{
	int ret = 0;

	// Ha exit-et küldök, vagy allow1-et, akkor az elsõbe
	if( (cmd == CMD_ALLOW_MOVE_1) || (cmd == CMD_EXIT))
	{
		ret = modbus_write_register(plc, ADDR_CMD_1, (REG16) cmd );
	}
	// Ha allow2-t, akkor a másodikba
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

// Kiküldjük a lépés pozíciót a robotnak
bool robot_sendMoveData(MOVE move)
{
	int ret = 0;
	// Ebbe a tömbbe összeszedem az adat minden részét
	REG16 regTemp[3] = {0, 0, 0};

	regTemp[0] = (REG16) move.source;
	regTemp[1] = (REG16) move.dest;
	regTemp[2] = (REG16) move.type;

	// Elküldöm
	ret = modbus_write_registers(plc, ADDR_MOVESOURCE, 3, regTemp);

	if (ret == -1)
	{
		return false;
	}

	return true;
}
