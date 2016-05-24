#ifndef __TYPES_H__
#define __TYPES_H__

// Bool
typedef enum
{
	false = 0,
	true = 0x53
} bool;

// L�p�s t�pusa
typedef enum
{
	NORMAL_MOVE = 0x21,
	HIT_MOVE    = 0xAD
} MOVE_TYPE;

// Parancs t�pusa
typedef enum
{
	CMD_ALLOW_MOVE_1 = 0x5353,
	CMD_ALLOW_MOVE_2 = 0x1919,
	CMD_EXIT         = 0x3333,
	CMD_CLR_READY    = 0x2,
	CMD_READY        = 0x457
} CMD;


// L�p�s strukt�ra
typedef struct
{
	int source;
	int dest;
	MOVE_TYPE type;
} MOVE;

#endif // __TYPES_H__
