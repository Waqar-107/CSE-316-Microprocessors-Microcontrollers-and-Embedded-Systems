#include <avr/io.h>

#define F_CPU 1000000
#include <util/delay.h> 

int main(void)
{
	//output in PA0,PA1,PA2,PA3
	//input in PB4,PB5
	DDRA=0xFF;
	DDRB=0x00;
    
	unsigned char ma=0b00001111;
	unsigned char mb1=0b00010000;
	unsigned char mb2=0b00100000;
	
	unsigned char cnt=0;
	
	while(1)
    {
		if(PINB & mb1){
			cnt++;
			_delay_ms(1000);
		}
		
		else if(PINB & mb2){
			cnt--;
			_delay_ms(1000);
		}
		
		PORTA=cnt & ma;
	}
}