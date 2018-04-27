/*
 * animate_LEDs.c
 *
 * Created: 4/27/2018 8:45:08 PM
 * Author: Waqar_107
 */ 


#include <avr/io.h>
#include <util/delay.h>

#define F_CPU 1000000

int main(void)
{
	unsigned char c=0x01;
	DDRA=0xFF;
	
    while(1)
    {
        PORTA=c;
		if(c==1<<7)c=1;
		else c=c<<1;
		_delay_ms(1000);
    }
}