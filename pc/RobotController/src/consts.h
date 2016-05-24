#ifndef __CONSTS_H__
#define __CONSTS_H__

// PLC kapcsolat
#define PLC_IP "192.168.0.104"
#define PORT 502

// PC debug anan�sz kapcsolat
#define DEBUG_IP "152.66.158.109"

// PLC konstansai

typedef enum // Mem�riac�mek
{
	ADDR_CMD_1       = 540,
	ADDR_CMD_2       = 541,
	ADDR_MOVESOURCE  = 542,
	ADDR_MOVEDEST    = 543,
	ADDR_MOVETYPE    = 544,
	ADDR_CMD_EXIT    = 545
} MEMADDR;
/*
typedef enum // Mem�riac�mek
{
	ADDR_CMD_1       = 500,
	ADDR_CMD_2       = 501,
	ADDR_MOVESOURCE  = 502,
	ADDR_MOVEDEST    = 503,
	ADDR_MOVETYPE    = 504,
	ADDR_CMD_EXIT    = 505
} MEMADDR; */

#define REG16  uint16_t   // PLC-s szavak


#endif //__CONSTS_H__
