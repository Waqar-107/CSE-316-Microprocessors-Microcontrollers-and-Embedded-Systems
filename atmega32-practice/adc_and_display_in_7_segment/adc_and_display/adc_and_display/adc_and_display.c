/***from dust i have come, dust i will be***/

#define F_CPU 1000000

#include <avr/io.h>
#include <util/delay.h>

void adc_init()
{
	ADMUX |= (1<<REFS0);
	ADCSRA=(1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
}

uint16_t read_adc_channel(uint8_t channel)
{
	channel = channel & 0b00000111;
	ADMUX |= channel;
	
	//start conversion
	ADCSRA |= (1<<ADSC);
	
	//wait for the conversion to complete
	while(!(ADCSRA & (1<<ADIF)));
	
	//clear ADIF
	ADCSRA |= (1<<ADIF);
	
	return ADCW;
}

int main(void)
{
	DDRD=0xFF;
	DDRC=0xFF;
	DDRA=0x00;
	
	int d1,d2,d3;
	float pv,dv;
	
	adc_init();
    while(1)
    {
		
		/*  V=(Vmax*ADC_VALUE)/2^n
		*    =(5*ADC_VALUE)/1023
		*/
		
		dv=read_adc_channel(0);
		pv=(5*dv)/1023;
		
		//---------------------
		//display the float in a.bc format
		d1=pv;
		pv-=d1;
		pv*=10;
		
		d2=pv;
		pv-=d2;
		pv*=10;
		
		d3=pv;
		
		PORTC=(d2<<4)|(d1);
		PORTD=d3;
    }
}