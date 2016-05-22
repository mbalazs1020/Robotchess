#ifndef __TYPES_H__
#define __TYPES_H__

// Bool
typedef enum
{
	false = 0,
	true = 0x53
} bool;

// Lépés típusa
typedef enum
{
	NORMAL_MOVE = 0x21,
	HIT_MOVE    = 0xAD
} MOVE_TYPE;

// Parancs típusa
typedef enum
{
	CMD_ALLOW_MOVE_1 = 0x5353,
	CMD_ALLOW_MOVE_2 = 0xB9B9,
	CMD_EXIT         = 0x3333
} CMD;


// Lépés struktúra
typedef struct
{
	int source;
	int dest;
	MOVE_TYPE type;
} MOVE;

#endif // __TYPES_H__
