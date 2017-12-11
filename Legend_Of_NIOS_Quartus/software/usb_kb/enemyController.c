#include "system.h"
#include "alt_types.h"
#include "enemyController.h"
#include <stdlib.h>

#define select_addr	(volatile int*)  0x80
#define entity_active_addr (volatile int*) 0x20
#define entity_x_addr (volatile int*) 0x40
#define entity_y_addr (volatile int*) 0x30
#define entity_dir_addr (volatile int*) 0x50
#define entity_read_addr (volatile int*) 0x70
#define entity_write_addr (volatile int*) 0x60
#define entity_type_addr (volatile int*) 0xf0

int enemyCounter[5] = {0,0,0,0,0};


void updateEnemies()
{

	*select_addr = 0;
	*entity_read_addr = 1;
	int player_x = *entity_x_addr;
	int player_y = *entity_y_addr;
	*entity_read_addr = 0;

	int i = 0;
	for(i = 1; i <= 5; i++)
	{
		*select_addr = i;
		*entity_read_addr = 1;
		int enemy_x = *entity_x_addr;
		int enemy_y = *entity_y_addr;
		int enemy_active = *entity_active_addr;
		int enemy_type = *entity_type_addr;
		*entity_read_addr = 0;
		if(enemy_active && enemy_type == 1)
		{
			if( enemyCounter[i-1] >= 3)
			{
				int dir = rand() % 4 + 1;
				*entity_write_addr = 1;
				*entity_dir_addr = dir;
				*entity_write_addr = 0;
				enemyCounter[i-1] = 0;
				printf("\nEnemy direction changed");
			}
		}
		else if(enemy_active && enemy_type == 2)
		{
			if(enemy_x-player_x < -16)
			{
				*entity_write_addr = 1;
				*entity_dir_addr = 2;
				*entity_write_addr = 0;
			}
			else if(enemy_x - player_x > 16)
			{
				*entity_write_addr = 1;
				*entity_dir_addr = 1;
				*entity_write_addr = 0;
			}
			else if(enemy_y - player_y < -16)
			{
				*entity_write_addr = 1;
				*entity_dir_addr = 3;
				*entity_write_addr = 0;
			}
			else if(enemy_y - player_y > 16)
			{
				*entity_write_addr = 1;
				*entity_dir_addr = 4;
				*entity_write_addr = 0;
			}
			else
			{
				*entity_write_addr = 1;
				*entity_dir_addr = 0;
				*entity_write_addr = 0;
			}
		}
		else if(enemy_active && enemy_type == 3)
		{
			if( (((player_x + 32) > enemy_x) && (player_x < enemy_x)) || ((player_x < (enemy_x + 32)) && ((player_x +32) > (enemy_x + 32) )))
			{
				if(player_y > (enemy_y + 32))
				{
					*entity_write_addr = 1;
					*entity_dir_addr = 3;
					*entity_write_addr = 0;
				}
				else if(player_y < (enemy_y - 32))
				{
					*entity_write_addr = 1;
					*entity_dir_addr = 4;
					*entity_write_addr = 0;
				}
				else
				{
					*entity_write_addr = 1;
					*entity_dir_addr = 0;
					*entity_write_addr = 0;
				}
			}
			else
			{
				*entity_write_addr = 1;
				*entity_dir_addr = 0;
				*entity_write_addr = 0;
			}
		}
		enemyCounter[i-1] ++;
	}

}
