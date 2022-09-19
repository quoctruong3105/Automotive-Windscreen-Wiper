# Automotive-Windscreen-Wiper
+ Note: In fact, the rain sensor on the car is based on the mechanism of detecting the change of light shining through the windshield, so it can return a lot of value. Meanwhile, the rain sensor used in the simulation can only return high or low. Therefore, this project only uses a rheostat to replace the rain sensor.
+ Knowledge used in this project:
    - Microcontroller: External Interrupt, Timer0(fastPWM), Timer1(delays depend on OCR1A)
    - C language: loop, if-else structure.
    - Automotive: working principle of the windscreen wiper.
+ Working principle: The wiper system includes 5 modes: High, Low, Interrupt, Auto, and Washer. The method to control the wipers fast or slow is to change the value on the OCR1A register. In Interrupt mode, the driver will adjust the interrupt time by the "Set time for mode interrupt" button. In Auto mode, the wiper is fast or slow depending on the amount of rain read from the ADC. Washing mode can be done at any time as long as the driver presses the "Washer" button, in this mode the wiper motor and wiper motor will work at the same time.

