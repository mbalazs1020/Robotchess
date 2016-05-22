#ifndef __MODBUS_DRIVER_H__
#define __MODBUS_DRIVER_H__

// Csatlakozunk
bool robot_connect(char * ip, int port);

// Lekapcsol�dunk
void robot_disconnect(void);

// Kik�ldj�k a parancsot
bool robot_sendCmd(CMD cmd);

// Kik�ldj�k a l�p�s poz�ci�t a robotnak
bool robot_sendMoveData(MOVE move);


#endif
