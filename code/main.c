#include <mega328p.h>
#include <stdio.h>
#include <delay.h>
#include <alcd.h>

#define ADC_VREF_TYPE 0x40
#define noH 0b00000000
#define noL 0b00000000
#define slowH 0b11110100
#define slowL 0b00011011
#define medH 0b10011000
#define medL 0b10010110  
#define fastH 0b00111101   
#define fastL 0b00001001
#define hiSw PINC.1
#define loSw PINC.2
#define intSw PINC.3
#define autoSw PINC.4
#define wasSw PINC.5
#define On 0
#define Off 1
 

unsigned int rainFall, setTimeButton;

// Timer1 is used to delay, wipe fast or low is depended on OCR1A.
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
    if(wasSw == On)
    {
        PORTD.0 = 1; //Water Jet Motor is actived
    }
    OCR0B = 10;
    delay_ms(2000);
    OCR0B = 5;          
}

// Set time for interrupt mode
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    setTimeButton++;
    if(setTimeButton == 3)
    {
        setTimeButton = 0;
    }                     
}

// Read Rain Sensor
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

void thongBaoLCD(unsigned int x)
{
    if(x > 10 && x < 350)
    {
        lcd_puts("RainFall: Slight");      
    }                            
    else if(x >= 350 && x < 700)
    {
        lcd_puts("RainFall: Medium");
    }                           
    else if(x >= 700)
    {
        lcd_puts("RainFall: Heavy");
    }                        
    else
    {
        lcd_puts("There's no rain");
    }
}

void washer()
{   
    lcd_gotoxy(0,0);
    lcd_puts("Washering");
    PORTD.0 = 0;
    TIMSK1 = 0b00000010;
    OCR1AH = fastH;
    OCR1AL = fastL;    
}

void modeHigh()
{
    lcd_clear();
    lcd_gotoxy(0,0);
    while(wasSw == On)
    {
        washer();
    } 
    lcd_puts("Mode: high");
    TIMSK1 = 0b00000010; 
    OCR1AH = fastH;
    OCR1AL = fastL;     
}

void modeLow()
{
    lcd_clear();
    lcd_gotoxy(0,0);
    while(wasSw == On)
    {
        washer();
    } 
    lcd_puts("Mode: slow"); 
    TIMSK1 = 0b00000010;   
    OCR1AH = slowH;
    OCR1AL = slowL;    
}

void modeInterrupt()
{
    lcd_clear();
    lcd_gotoxy(0,0);
    while(wasSw == On)
    {
        washer();
    }  
    lcd_puts("Mode: Interrupt");  
    lcd_gotoxy(0,1);
    lcd_puts("Period: ");
    TIMSK1 = 0b00000010;
    if(setTimeButton == 0)
    {
        lcd_puts("+");
        OCR1AH = slowH;
        OCR1AL = slowL;      
    } 
    else if(setTimeButton == 1)
    {
        lcd_puts("++");
        OCR1AH = medH;
        OCR1AL = medL;  
    }   
    else if(setTimeButton == 2)
    {
        lcd_puts("+++");
        OCR1AH = fastH;
        OCR1AL = fastL;
    }
}

void modeAuto()
{
    lcd_clear();
    lcd_gotoxy(0,0);
    while(wasSw == On)
    {
        washer();
    }  
    lcd_puts("Mode: Auto");
    rainFall = read_adc(0); 
    lcd_gotoxy(0,1);
    thongBaoLCD(rainFall);   
    //Allow interrup
    if(rainFall > 10) //When rain sensor receive rain sginal -> allow interrupt 
    {                             
        TIMSK1 = 0b00000010;  
    }                    
    else //When there is no rain -> no interrupt -> Servo does not operate 
    {
        TIMSK1 = 0b00000000;   
    }            
        
    //Delay depend on ADC using Timer1
    if(rainFall > 10 && rainFall < 350) // Slight
    {
        OCR1AH = slowH;
        OCR1AL = slowL;        
    }                            
    else if(rainFall >= 350 && rainFall < 700) // Medium
    {
        OCR1AH = medH;
        OCR1AL = medL;  
    }                           
    else if(rainFall >= 700) // Heavy
    {
        OCR1AH = fastH;
        OCR1AL = fastL;  
    }                            
}

void off()
{
    TIMSK1 = 0b00000000;   
    lcd_clear(); 
    lcd_gotoxy(0,0);
}

void main(void)
{

// Timer/Counter 0 initialization
// Mode: fastPWM (Top is OCR0A)
// Prescaler: 1024
TCCR0A=0b00100011;
TCCR0B=0b00001101;
OCR0A=100; 
OCR0B=5;

// Timer/Counter 1 initialization
// Mode: CTC (Top is OCR1A)
// Prescaler: 256 -> f: 256/8 = 32 muys
// Interrupt and top will be set depend on mode
TCCR1A=0b00000000;
TCCR1B=0b00001100; 
TIMSK1=0b00000000; 

// ADC initialization
DIDR0=0x01;
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x81;

// External Interrupt(s) initialization
EICRA=0x02;
EIMSK=0x01;
EIFR=0x01;

DDRD.5 = 1; // Output PWM
DDRD.0 = 1; // Output Motor jet water
PORTC.1 = 1; // Mode High switch
PORTC.2 = 1; // Mode Low switch
PORTC.3 = 1; // Mode Interrupt switch
PORTC.4 = 1; // Mode Auto switch
PORTC.5 = 1; // Washer Switch
PORTD.2 = 1; // Set time for mode interrupt button

// Characters/line: 16
lcd_init(16);

#asm("sei")

while (1)
      {    
        if(autoSw == On && hiSw == Off && loSw == Off && intSw == Off)
        {       
            modeAuto();
        } 
        else if(hiSw == On && loSw == Off && intSw == Off && autoSw == Off)
        {   
            modeHigh(); 
        }     
        else if(loSw == On && hiSw == Off && intSw == Off && autoSw == Off)  
        {                          
            modeLow(); 
        }   
        
        else if(intSw == On && hiSw == Off && loSw == Off && autoSw == Off)
        {
            modeInterrupt();
        }
        else if(wasSw == On)
        {
            washer();
        }     
        else
        {
            off();
        }     
        delay_ms(500);
      }
}
