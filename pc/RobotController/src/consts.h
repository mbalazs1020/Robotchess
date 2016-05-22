#ifndef __CONSTS_H__
#define __CONSTS_H__

// PLC kapcsolat
#define PLC_IP "192.168.0.104"
#define PORT 502

// PC debug ananász kapcsolat
#define DEBUG_IP "192.168.1.65"

// PLC konstansai

typedef enum // Memóriacímek
{
	ADDR_CMD_1       = 540,
	ADDR_CMD_2       = 541,
	ADDR_MOVESOURCE  = 542,
	ADDR_MOVEDEST    = 543,
	ADDR_MOVETYPE    = 544
} MEMADDR;

#define REG16  uint16_t   // PLC-s szavak


#endif //__CONSTS_H__
