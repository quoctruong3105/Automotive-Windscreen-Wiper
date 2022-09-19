# Automotive-Windscreen-Wiper
Knowledge used in this project:
Microcontroller: External Interrupt, Timer0(fastPWM), Timer1(delay),
Electronic: Ultrasonic Sensor, Voltage Divider.
C language: loop, if-else structure.
Automotive: working principle of the power side-view mirror.
Working principle:
Basic functions: fold/unfold, adjust left/right, up/down.
Smart function: automatically folds when there is a possibility of a mirror collision at high speed. When the mirror is in open mode, if the ultrasonic sensor detects an object 100 cm away from the mirror, the system will alert the driver. If the distance from the mirror to the object is less than 40 cm and the vehicle continues to move at a speed greater than 20 km/h, the system will automatically fold the mirror for protection. When the object has been passed, the mirror will automatically be opened again. However, if the distance from the object to the mirror is less than 40cm and the vehicle moves at a speed of less than 20 km/h, the system will understand that the driver has actively slowed down to control a collision or is adjusting the car in a parking lot, the system will only warn but not automatically fold the mirrors. Another noteworthy point is that the mirror will automatically reopen if it is closed automatically for protection, this is different from the mirror being closed by the driver pressing the folding button.
