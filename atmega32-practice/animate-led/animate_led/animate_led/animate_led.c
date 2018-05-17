/***from dust i have come, dust i will be***/


#include <avr/io.h>

#define F_CPU 1000000
#include <util/delay.h>

int main(void)
{
	unsigned char cnt=1;
	unsigned char mask=0b00001111;
	
	DDRA=0xFF;				//set for output
	
    while(1)
    {
		//PORTA=0b00001111;
		PORTA=cnt & mask;
		_delay_ms(1000);

		cnt=cnt<<1;
		
		if(cnt==16)
			cnt=1;  
    }
}