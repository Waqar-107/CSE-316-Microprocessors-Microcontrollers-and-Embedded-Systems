/***from dust i have come, dust i will be***/

//need to be defined so that the library works 
#define D4 eS_PORTD4
#define D5 eS_PORTD5
#define D6 eS_PORTD6
#define D7 eS_PORTD7
#define RS eS_PORTC6
#define EN eS_PORTC7

#define F_CPU 1000000

#include <avr/io.h>
#include <util/delay.h>
#include "lcd.h"

void adc_init()
{
	ADMUX |= (1<<REFS0);
	ADCSRA=(1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
	//SFIOR=0x00;
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
	
	//LCD 
	Lcd4_Init();
	Lcd4_Set_Cursor(1,1);
	Lcd4_Write_String("voltage:");
	
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
		//---------------------
		Lcd4_Set_Cursor(2,1);
		Lcd4_Write_Char(d1+48);
		
		Lcd4_Set_Cursor(2,2);
		Lcd4_Write_Char('.');
		
		Lcd4_Set_Cursor(2,3);
		Lcd4_Write_Char(d2+48);
		
		Lcd4_Set_Cursor(2,4);
		Lcd4_Write_Char(d3+48);
    }
}