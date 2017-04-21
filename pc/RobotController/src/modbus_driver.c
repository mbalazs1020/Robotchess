#include "stdio.h"
#include "types.h"
#include "consts.h"
#include "modbus/modbus.h"

// Glob�lis v�ltoz�k
modbus_t *plc = NULL;

// Csatlakozunk
bool robot_connect(char * ip, int port)
{
	int i = 0;
	plc = modbus_new_tcp(ip, port);

	if(modbus_connect(plc) == -1)
	{
		return false;
	}

	modbus_write_register(plc, ADDR_CMD_1, (REG16) 0 );
	for(i = 0; i < 1000; i++);
	modbus_write_register(plc, ADDR_CMD_2, (REG16) 0 );
	for(i = 0; i < 1000; i++);
	modbus_write_register(plc, ADDR_MOVESOURCE, (REG16) 0 );
	for(i = 0; i < 1000; i++);
	modbus_write_register(plc, ADDR_MOVEDEST, (REG16) 0 );
	for(i = 0; i < 1000; i++);
	modbus_write_register(plc, ADDR_MOVETYPE, (REG16) 0 );
	for(i = 0; i < 1000; i++);
	modbus_write_register(plc, ADDR_CMD_EXIT, (REG16) 0 );
	for(i = 0; i < 1000; i++);

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

	// Ha CMD_CLR_READY-t k�ld�k
	if( cmd == CMD_CLR_READY )
	{
		ret = modbus_write_register(plc, ADDR_CMD_1, (REG16) cmd );
	}

	// Ha exit-et k�ld�k
	else if( cmd == CMD_EXIT )
	{
		ret = modbus_write_register(plc, ADDR_CMD_EXIT, (REG16) cmd );
	}

	// Ha allow1-et k�ld�k, az els�be
	else if( cmd == CMD_ALLOW_MOVE_1 )
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
bool robot_sendMove(MOVE move)
{
	int i = 0;
	int ret = 0;
	REG16 ans = 0;
	// Ebbe a t�mbbe �sszeszedem az adat minden r�sz�t
	REG16 regTemp[3] = {0, 0, 0};

	regTemp[0] = (REG16) move.source;
	regTemp[1] = (REG16) move.dest;
	regTemp[2] = (REG16) move.type;


	// Els� enged�lyez� parancs
	robot_sendCmd(CMD_ALLOW_MOVE_1);
	for(i = 0; i < 1000; i++);

	// Elk�ld�m a l�p�st
	ret = modbus_write_registers(plc, ADDR_MOVESOURCE, 3, regTemp);
	for(i = 0; i < 1000; i++);

	if (ret == -1)
	{
		return false;
	}

	// Utols� enged�lyez� parancs
	robot_sendCmd(CMD_ALLOW_MOVE_2);
	for(i = 0; i < 1000; i++);

	printf("Waiting for answer... \n");

	// V�rom a v�laszt
	while (ans != CMD_READY)
	{
		ret = modbus_read_registers(plc, 1040, 1, &ans);
		for(i = 0; i < 1000; i++);
		if(ret == -1)
		{
			return false;
		}
	}

	printf("Move ready. \n");

	// Mem�ri�k t�rl�se
	modbus_write_register(plc, ADDR_CMD_1, (REG16) 0 );
	for(i = 0; i < 1000; i++);
	modbus_write_register(plc, ADDR_CMD_2, (REG16) 0 );
	for(i = 0; i < 1000; i++);

	// Megk�rem, hogy t�r�lje a k�sz jelz�st
	robot_sendCmd(CMD_CLR_READY);

	return true;
}

void modbusClearCommand( void )
{
	int i =0;
	// Mem�ri�k t�rl�se
	modbus_write_register(plc, ADDR_CMD_1, (REG16) 0 );
	for( i = 0; i < 1000; i++);
	modbus_write_register(plc, ADDR_CMD_2, (REG16) 0 );
	for( i = 0; i < 1000; i++);

	// Megk�rem, hogy t�r�lje a k�sz jelz�st
	robot_sendCmd(CMD_CLR_READY);

	printf("Elvileg t�r�ltem az �sszes mem�ri�t");
}
