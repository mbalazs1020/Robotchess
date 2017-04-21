#ifndef __MODBUS_DRIVER_H__
#define __MODBUS_DRIVER_H__

// Csatlakozunk
bool robot_connect(char * ip, int port);

// Lekapcsolódunk
void robot_disconnect(void);

// Kiküldjük a parancsot
bool robot_sendCmd(CMD cmd);

// Lépés kiküldés és várás
bool robot_sendMove(MOVE move);

// Kiadott parancs törlése
void modbusClearCommand( void );


#endif
