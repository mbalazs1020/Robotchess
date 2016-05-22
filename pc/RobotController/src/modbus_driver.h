#ifndef __MODBUS_DRIVER_H__
#define __MODBUS_DRIVER_H__

// Csatlakozunk
bool robot_connect(char * ip, int port);

// Lekapcsolódunk
void robot_disconnect(void);

// Kiküldjük a parancsot
bool robot_sendCmd(CMD cmd);

// Kiküldjük a lépés pozíciót a robotnak
bool robot_sendMoveData(MOVE move);


#endif
