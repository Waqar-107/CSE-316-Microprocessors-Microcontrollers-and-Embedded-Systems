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
#include <stdlib.h>
#include <util/delay.h>
#include "lcd.h"

void adc_init()
{
	//0 1- AVCC AND AREF
	ADMUX |= (1<REFS0);
	
	//enabling ADC and clock freq.
	ADCSRA |= (1<<ADEN) | (1<<ADPS2);
	
	SFIOR=0x00;
}

int read_adc_channel(unsigned char channel)
{
	int adc_value;
	
	//select the channel
	ADMUX |= channel;
	
	//start a conversion
	ADCSRA |= (1<<ADSC);
	
	//wait till the conversion is completed
	//when completed ADIF positioned bit will be 1
	while(!(ADCSRA & (1<<ADIF)));
	
	//clear ADIF for next conversion
	ADCSRA |= (1<<ADIF);
	
	//now read ADCW-the result
	adc_value=ADCW;
	
	return adc_value;
}

int main(void)
{
	DDRD=0xFF;
	DDRC=0xFF;
	
	char f[]="0000";
	
	//LCD 
	Lcd4_Init();
	Lcd4_Set_Cursor(1,1);
	Lcd4_Write_String("voltage reading:");
	Lcd4_Set_Cursor(2,1);
	
	int adc_value;
	
    while(1)
    {
		adc_value=read_adc_channel(0);
		
		itoa(adc_value,f,10);
		Lcd4_Write_String(f);
    }
}