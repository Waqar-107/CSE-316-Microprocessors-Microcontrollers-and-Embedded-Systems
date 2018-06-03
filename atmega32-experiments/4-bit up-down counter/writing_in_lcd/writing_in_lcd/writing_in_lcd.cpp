/*** from dust i have come, dust i will be ***/

#include <avr/io.h>
#include <string.h>

#define F_CPU 1000000
#include <util/delay.h>

//data/control commands
#define lcd_data_port PORTB
#define lcd_control_port PORTD

//controls-
#define lcd_rs PD0		// 0/1: command/data mode
#define lcd_rw PD1		// 0/1: write/read mode
#define lcd_en PD2		// must be high to perform read/write

void lcd_data_write(char data)
{
	lcd_control_port=_BV(lcd_en) | _BV(lcd_rs); //_BV(n) means 1<<n, BV stands for "Bit Value"
	lcd_data_port=data;
	
	_delay_ms(1);
	
	lcd_control_port=_BV(lcd_rs);
	
	_delay_ms(1);
	
}

void lcd_command_write(char command)
{
	lcd_control_port=_BV(lcd_en);
	lcd_data_port=command;
	
	_delay_ms(1);
	
	lcd_control_port=0x00;
	
	_delay_ms(1);
}

void lcd_init()
{
	lcd_command_write(0x38);	// 2 lines and 5×7 matrix
	lcd_command_write(0x01);	// clear display screen
	lcd_command_write(0x06);	// increment cursor (shift cursor to right)
	lcd_command_write(0x0E);	// display ON, cursor blinking
}

void lcd_str_write(char *str)
{
	while(*str)
		lcd_data_write(*str++);
}

int main(void)
{
	DDRD=0b00000111;	// PD0,PD1 and PD1 for controls
    
	char fr[]="CSE'15";
	char sr[]="BUET";
	
	lcd_init();
	lcd_str_write(fr);
	lcd_command_write(0xc0);	//cursor moved to next rowm first col 
	lcd_str_write(sr);
}

/*
https://circuitdigest.com/article/16x2-lcd-display-module-pinout-datasheet
*/