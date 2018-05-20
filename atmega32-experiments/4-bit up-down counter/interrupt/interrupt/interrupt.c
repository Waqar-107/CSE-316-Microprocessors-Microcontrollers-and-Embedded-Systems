#include <avr/io.h>
#include <avr/interrupt.h>

#define F_CPU 1000000
#include <util/delay.h>

unsigned char cnt; 

//masking variable
unsigned char ma=0b00001111;

ISR(INT0_vect)
{
	if(cnt==15)
		cnt=0;
	else
		cnt++;
		
	PORTA=cnt & ma;
	_delay_ms(1000);
}


ISR(INT1_vect)
{
	if(cnt==0)
		cnt=15;
	else
		cnt--;
		
	PORTA=cnt & ma;
	_delay_ms(1000);
}

int main(void)
{
	//output in A
	DDRA=0xFF;
	
	
	
	cnt=0;
	
	GICR=(1<<INT0) | (1<<INT1);	//enable external interrupts INT0 and INT1
	MCUCR=(1<<ISC00) | (1<<ISC10);
	
	sei();
	
    while(1){
		
	}
}