#ifndef __MODBUS_DRIVER_H__
#define __MODBUS_DRIVER_H__

// Csatlakozunk
bool robot_connect(char * ip, int port);

// Lekapcsol�dunk
void robot_disconnect(void);

// Kik�ldj�k a parancsot
bool robot_sendCmd(CMD cmd);

// L�p�s kik�ld�s �s v�r�s
bool robot_sendMove(MOVE move);

// Kiadott parancs t�rl�se
void modbusClearCommand( void );


#endif
