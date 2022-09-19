
;CodeVisionAVR C Compiler V2.05.0 Advanced
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega328P
;Program type             : Application
;Clock frequency          : 1,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2303
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rainFall=R3
	.DEF _setTimeButton=R5
	.DEF __lcd_x=R8
	.DEF __lcd_y=R7
	.DEF __lcd_maxx=R10

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x52,0x61,0x69,0x6E,0x46,0x61,0x6C,0x6C
	.DB  0x3A,0x20,0x53,0x6C,0x69,0x67,0x68,0x74
	.DB  0x0,0x52,0x61,0x69,0x6E,0x46,0x61,0x6C
	.DB  0x6C,0x3A,0x20,0x4D,0x65,0x64,0x69,0x75
	.DB  0x6D,0x0,0x52,0x61,0x69,0x6E,0x46,0x61
	.DB  0x6C,0x6C,0x3A,0x20,0x48,0x65,0x61,0x76
	.DB  0x79,0x0,0x54,0x68,0x65,0x72,0x65,0x27
	.DB  0x73,0x20,0x6E,0x6F,0x20,0x72,0x61,0x69
	.DB  0x6E,0x0,0x57,0x61,0x73,0x68,0x65,0x72
	.DB  0x69,0x6E,0x67,0x0,0x4D,0x6F,0x64,0x65
	.DB  0x3A,0x20,0x68,0x69,0x67,0x68,0x0,0x4D
	.DB  0x6F,0x64,0x65,0x3A,0x20,0x73,0x6C,0x6F
	.DB  0x77,0x0,0x4D,0x6F,0x64,0x65,0x3A,0x20
	.DB  0x49,0x6E,0x74,0x65,0x72,0x72,0x75,0x70
	.DB  0x74,0x0,0x50,0x65,0x72,0x69,0x6F,0x64
	.DB  0x3A,0x20,0x0,0x2B,0x0,0x2B,0x2B,0x0
	.DB  0x2B,0x2B,0x2B,0x0,0x4D,0x6F,0x64,0x65
	.DB  0x3A,0x20,0x41,0x75,0x74,0x6F,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x11
	.DW  _0xD
	.DW  _0x0*2

	.DW  0x11
	.DW  _0xD+17
	.DW  _0x0*2+17

	.DW  0x10
	.DW  _0xD+34
	.DW  _0x0*2+34

	.DW  0x10
	.DW  _0xD+50
	.DW  _0x0*2+50

	.DW  0x0A
	.DW  _0x15
	.DW  _0x0*2+66

	.DW  0x0B
	.DW  _0x1B
	.DW  _0x0*2+76

	.DW  0x0B
	.DW  _0x1F
	.DW  _0x0*2+87

	.DW  0x10
	.DW  _0x23
	.DW  _0x0*2+98

	.DW  0x09
	.DW  _0x23+16
	.DW  _0x0*2+114

	.DW  0x02
	.DW  _0x23+25
	.DW  _0x0*2+123

	.DW  0x03
	.DW  _0x23+27
	.DW  _0x0*2+125

	.DW  0x04
	.DW  _0x23+30
	.DW  _0x0*2+128

	.DW  0x0B
	.DW  _0x2C
	.DW  _0x0*2+132

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <stdio.h>
;#include <delay.h>
;#include <alcd.h>
;
;#define ADC_VREF_TYPE 0x40
;#define noH 0b00000000
;#define noL 0b00000000
;#define slowH 0b11110100
;#define slowL 0b00011011
;#define medH 0b10011000
;#define medL 0b10010110
;#define fastH 0b00111101
;#define fastL 0b00001001
;#define hiSw PINC.1
;#define loSw PINC.2
;#define intSw PINC.3
;#define autoSw PINC.4
;#define wasSw PINC.5
;#define On 0
;#define Off 1
;
;
;unsigned int rainFall, setTimeButton;
;
;// Timer1 is used to delay, wipe fast or low is depended on OCR1A.
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 001C {

	.CSEG
_timer1_compa_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 001D     if(wasSw == On)
	SBIS 0x6,5
; 0000 001E     {
; 0000 001F         PORTD.0 = 1; //Water Jet Motor is actived
	SBI  0xB,0
; 0000 0020     }
; 0000 0021     OCR0B = 10;
	LDI  R30,LOW(10)
	OUT  0x28,R30
; 0000 0022     delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x0
; 0000 0023     OCR0B = 5;
	LDI  R30,LOW(5)
	OUT  0x28,R30
; 0000 0024 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Set time for interrupt mode
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0028 {
_ext_int0_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0029     setTimeButton++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
; 0000 002A     if(setTimeButton == 3)
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R5
	CPC  R31,R6
	BRNE _0x6
; 0000 002B     {
; 0000 002C         setTimeButton = 0;
	CLR  R5
	CLR  R6
; 0000 002D     }
; 0000 002E }
_0x6:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;// Read Rain Sensor
;unsigned int read_adc(unsigned char adc_input)
; 0000 0032 {
_read_adc:
; 0000 0033 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	STS  124,R30
; 0000 0034 // Delay needed for the stabilization of the ADC input voltage
; 0000 0035 delay_us(10);
	__DELAY_USB 3
; 0000 0036 // Start the AD conversion
; 0000 0037 ADCSRA|=0x40;
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 0038 // Wait for the AD conversion to complete
; 0000 0039 while ((ADCSRA & 0x10)==0);
_0x7:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ _0x7
; 0000 003A ADCSRA|=0x10;
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 003B return ADCW;
	LDS  R30,120
	LDS  R31,120+1
	JMP  _0x2080001
; 0000 003C }
;
;void thongBaoLCD(unsigned int x)
; 0000 003F {
_thongBaoLCD:
; 0000 0040     if(x > 10 && x < 350)
;	x -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,11
	BRLO _0xB
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x15E)
	LDI  R30,HIGH(0x15E)
	CPC  R27,R30
	BRLO _0xC
_0xB:
	RJMP _0xA
_0xC:
; 0000 0041     {
; 0000 0042         lcd_puts("RainFall: Slight");
	__POINTW1MN _0xD,0
	RJMP _0x5E
; 0000 0043     }
; 0000 0044     else if(x >= 350 && x < 700)
_0xA:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x15E)
	LDI  R30,HIGH(0x15E)
	CPC  R27,R30
	BRLO _0x10
	CPI  R26,LOW(0x2BC)
	LDI  R30,HIGH(0x2BC)
	CPC  R27,R30
	BRLO _0x11
_0x10:
	RJMP _0xF
_0x11:
; 0000 0045     {
; 0000 0046         lcd_puts("RainFall: Medium");
	__POINTW1MN _0xD,17
	RJMP _0x5E
; 0000 0047     }
; 0000 0048     else if(x >= 700)
_0xF:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x2BC)
	LDI  R30,HIGH(0x2BC)
	CPC  R27,R30
	BRLO _0x13
; 0000 0049     {
; 0000 004A         lcd_puts("RainFall: Heavy");
	__POINTW1MN _0xD,34
	RJMP _0x5E
; 0000 004B     }
; 0000 004C     else
_0x13:
; 0000 004D     {
; 0000 004E         lcd_puts("There's no rain");
	__POINTW1MN _0xD,50
_0x5E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 004F     }
; 0000 0050 }
	JMP  _0x2080002

	.DSEG
_0xD:
	.BYTE 0x42
;
;void washer()
; 0000 0053 {

	.CSEG
_washer:
; 0000 0054     lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 0055     lcd_puts("Washering");
	__POINTW1MN _0x15,0
	CALL SUBOPT_0x2
; 0000 0056     PORTD.0 = 0;
	CBI  0xB,0
; 0000 0057     TIMSK1 = 0b00000010;
	CALL SUBOPT_0x3
; 0000 0058     OCR1AH = fastH;
; 0000 0059     OCR1AL = fastL;
	RJMP _0x2080003
; 0000 005A }

	.DSEG
_0x15:
	.BYTE 0xA
;
;void modeHigh()
; 0000 005D {

	.CSEG
_modeHigh:
; 0000 005E     lcd_clear();
	CALL SUBOPT_0x4
; 0000 005F     lcd_gotoxy(0,0);
; 0000 0060     while(wasSw == On)
_0x18:
	SBIC 0x6,5
	RJMP _0x1A
; 0000 0061     {
; 0000 0062         washer();
	RCALL _washer
; 0000 0063     }
	RJMP _0x18
_0x1A:
; 0000 0064     lcd_puts("Mode: high");
	__POINTW1MN _0x1B,0
	CALL SUBOPT_0x2
; 0000 0065     TIMSK1 = 0b00000010;
	CALL SUBOPT_0x3
; 0000 0066     OCR1AH = fastH;
; 0000 0067     OCR1AL = fastL;
	RJMP _0x2080003
; 0000 0068 }

	.DSEG
_0x1B:
	.BYTE 0xB
;
;void modeLow()
; 0000 006B {

	.CSEG
_modeLow:
; 0000 006C     lcd_clear();
	CALL SUBOPT_0x4
; 0000 006D     lcd_gotoxy(0,0);
; 0000 006E     while(wasSw == On)
_0x1C:
	SBIC 0x6,5
	RJMP _0x1E
; 0000 006F     {
; 0000 0070         washer();
	RCALL _washer
; 0000 0071     }
	RJMP _0x1C
_0x1E:
; 0000 0072     lcd_puts("Mode: slow");
	__POINTW1MN _0x1F,0
	CALL SUBOPT_0x2
; 0000 0073     TIMSK1 = 0b00000010;
	LDI  R30,LOW(2)
	STS  111,R30
; 0000 0074     OCR1AH = slowH;
	CALL SUBOPT_0x5
; 0000 0075     OCR1AL = slowL;
_0x2080003:
	STS  136,R30
; 0000 0076 }
	RET

	.DSEG
_0x1F:
	.BYTE 0xB
;
;void modeInterrupt()
; 0000 0079 {

	.CSEG
_modeInterrupt:
; 0000 007A     lcd_clear();
	CALL SUBOPT_0x4
; 0000 007B     lcd_gotoxy(0,0);
; 0000 007C     while(wasSw == On)
_0x20:
	SBIC 0x6,5
	RJMP _0x22
; 0000 007D     {
; 0000 007E         washer();
	RCALL _washer
; 0000 007F     }
	RJMP _0x20
_0x22:
; 0000 0080     lcd_puts("Mode: Interrupt");
	__POINTW1MN _0x23,0
	CALL SUBOPT_0x2
; 0000 0081     lcd_gotoxy(0,1);
	CALL SUBOPT_0x6
; 0000 0082     lcd_puts("Period: ");
	__POINTW1MN _0x23,16
	CALL SUBOPT_0x2
; 0000 0083     TIMSK1 = 0b00000010;
	LDI  R30,LOW(2)
	STS  111,R30
; 0000 0084     if(setTimeButton == 0)
	MOV  R0,R5
	OR   R0,R6
	BRNE _0x24
; 0000 0085     {
; 0000 0086         lcd_puts("+");
	__POINTW1MN _0x23,25
	CALL SUBOPT_0x2
; 0000 0087         OCR1AH = slowH;
	CALL SUBOPT_0x5
; 0000 0088         OCR1AL = slowL;
	RJMP _0x5F
; 0000 0089     }
; 0000 008A     else if(setTimeButton == 1)
_0x24:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R5
	CPC  R31,R6
	BRNE _0x26
; 0000 008B     {
; 0000 008C         lcd_puts("++");
	__POINTW1MN _0x23,27
	CALL SUBOPT_0x2
; 0000 008D         OCR1AH = medH;
	LDI  R30,LOW(152)
	STS  137,R30
; 0000 008E         OCR1AL = medL;
	LDI  R30,LOW(150)
	RJMP _0x5F
; 0000 008F     }
; 0000 0090     else if(setTimeButton == 2)
_0x26:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R5
	CPC  R31,R6
	BRNE _0x28
; 0000 0091     {
; 0000 0092         lcd_puts("+++");
	__POINTW1MN _0x23,30
	CALL SUBOPT_0x2
; 0000 0093         OCR1AH = fastH;
	LDI  R30,LOW(61)
	STS  137,R30
; 0000 0094         OCR1AL = fastL;
	LDI  R30,LOW(9)
_0x5F:
	STS  136,R30
; 0000 0095     }
; 0000 0096 }
_0x28:
	RET

	.DSEG
_0x23:
	.BYTE 0x22
;
;void modeAuto()
; 0000 0099 {

	.CSEG
_modeAuto:
; 0000 009A     lcd_clear();
	CALL SUBOPT_0x4
; 0000 009B     lcd_gotoxy(0,0);
; 0000 009C     while(wasSw == On)
_0x29:
	SBIC 0x6,5
	RJMP _0x2B
; 0000 009D     {
; 0000 009E         washer();
	RCALL _washer
; 0000 009F     }
	RJMP _0x29
_0x2B:
; 0000 00A0     lcd_puts("Mode: Auto");
	__POINTW1MN _0x2C,0
	CALL SUBOPT_0x2
; 0000 00A1     rainFall = read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	__PUTW1R 3,4
; 0000 00A2     lcd_gotoxy(0,1);
	CALL SUBOPT_0x6
; 0000 00A3     thongBaoLCD(rainFall);
	ST   -Y,R4
	ST   -Y,R3
	RCALL _thongBaoLCD
; 0000 00A4     //Allow interrup
; 0000 00A5     if(rainFall > 10) //When rain sensor receive rain sginal -> allow interrupt
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R3
	CPC  R31,R4
	BRSH _0x2D
; 0000 00A6     {
; 0000 00A7         TIMSK1 = 0b00000010;
	LDI  R30,LOW(2)
	RJMP _0x60
; 0000 00A8     }
; 0000 00A9     else //When there is no rain -> no interrupt -> Servo does not operate
_0x2D:
; 0000 00AA     {
; 0000 00AB         TIMSK1 = 0b00000000;
	LDI  R30,LOW(0)
_0x60:
	STS  111,R30
; 0000 00AC     }
; 0000 00AD 
; 0000 00AE     //Delay depend on ADC using Timer1
; 0000 00AF     if(rainFall > 10 && rainFall < 350) // Slight
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R3
	CPC  R31,R4
	BRSH _0x30
	LDI  R30,LOW(350)
	LDI  R31,HIGH(350)
	CP   R3,R30
	CPC  R4,R31
	BRLO _0x31
_0x30:
	RJMP _0x2F
_0x31:
; 0000 00B0     {
; 0000 00B1         OCR1AH = slowH;
	CALL SUBOPT_0x5
; 0000 00B2         OCR1AL = slowL;
	RJMP _0x61
; 0000 00B3     }
; 0000 00B4     else if(rainFall >= 350 && rainFall < 700) // Medium
_0x2F:
	LDI  R30,LOW(350)
	LDI  R31,HIGH(350)
	CP   R3,R30
	CPC  R4,R31
	BRLO _0x34
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CP   R3,R30
	CPC  R4,R31
	BRLO _0x35
_0x34:
	RJMP _0x33
_0x35:
; 0000 00B5     {
; 0000 00B6         OCR1AH = medH;
	LDI  R30,LOW(152)
	STS  137,R30
; 0000 00B7         OCR1AL = medL;
	LDI  R30,LOW(150)
	RJMP _0x61
; 0000 00B8     }
; 0000 00B9     else if(rainFall >= 700) // Heavy
_0x33:
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CP   R3,R30
	CPC  R4,R31
	BRLO _0x37
; 0000 00BA     {
; 0000 00BB         OCR1AH = fastH;
	LDI  R30,LOW(61)
	STS  137,R30
; 0000 00BC         OCR1AL = fastL;
	LDI  R30,LOW(9)
_0x61:
	STS  136,R30
; 0000 00BD     }
; 0000 00BE }
_0x37:
	RET

	.DSEG
_0x2C:
	.BYTE 0xB
;
;void off()
; 0000 00C1 {

	.CSEG
_off:
; 0000 00C2     TIMSK1 = 0b00000000;
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 00C3     lcd_clear();
	CALL SUBOPT_0x4
; 0000 00C4     lcd_gotoxy(0,0);
; 0000 00C5 }
	RET
;
;void main(void)
; 0000 00C8 {
_main:
; 0000 00C9 
; 0000 00CA // Timer/Counter 0 initialization
; 0000 00CB // Mode: fastPWM (Top is OCR0A)
; 0000 00CC // Prescaler: 1024
; 0000 00CD TCCR0A=0b00100011;
	LDI  R30,LOW(35)
	OUT  0x24,R30
; 0000 00CE TCCR0B=0b00001101;
	LDI  R30,LOW(13)
	OUT  0x25,R30
; 0000 00CF OCR0A=100;
	LDI  R30,LOW(100)
	OUT  0x27,R30
; 0000 00D0 OCR0B=5;
	LDI  R30,LOW(5)
	OUT  0x28,R30
; 0000 00D1 
; 0000 00D2 // Timer/Counter 1 initialization
; 0000 00D3 // Mode: CTC (Top is OCR1A)
; 0000 00D4 // Prescaler: 256 -> f: 256/8 = 32 muys
; 0000 00D5 // Interrupt and top will be set depend on mode
; 0000 00D6 TCCR1A=0b00000000;
	LDI  R30,LOW(0)
	STS  128,R30
; 0000 00D7 TCCR1B=0b00001100;
	LDI  R30,LOW(12)
	STS  129,R30
; 0000 00D8 TIMSK1=0b00000000;
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 00D9 
; 0000 00DA // ADC initialization
; 0000 00DB DIDR0=0x01;
	LDI  R30,LOW(1)
	STS  126,R30
; 0000 00DC ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 00DD ADCSRA=0x81;
	LDI  R30,LOW(129)
	STS  122,R30
; 0000 00DE 
; 0000 00DF // External Interrupt(s) initialization
; 0000 00E0 EICRA=0x02;
	LDI  R30,LOW(2)
	STS  105,R30
; 0000 00E1 EIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x1D,R30
; 0000 00E2 EIFR=0x01;
	OUT  0x1C,R30
; 0000 00E3 
; 0000 00E4 DDRD.5 = 1; // Output PWM
	SBI  0xA,5
; 0000 00E5 DDRD.0 = 1; // Output Motor jet water
	SBI  0xA,0
; 0000 00E6 PORTC.1 = 1; // Mode High switch
	SBI  0x8,1
; 0000 00E7 PORTC.2 = 1; // Mode Low switch
	SBI  0x8,2
; 0000 00E8 PORTC.3 = 1; // Mode Interrupt switch
	SBI  0x8,3
; 0000 00E9 PORTC.4 = 1; // Mode Auto switch
	SBI  0x8,4
; 0000 00EA PORTC.5 = 1; // Washer Switch
	SBI  0x8,5
; 0000 00EB PORTD.2 = 1; // Set time for mode interrupt button
	SBI  0xB,2
; 0000 00EC 
; 0000 00ED // Characters/line: 16
; 0000 00EE lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 00EF 
; 0000 00F0 #asm("sei")
	sei
; 0000 00F1 
; 0000 00F2 while (1)
_0x48:
; 0000 00F3       {
; 0000 00F4         if(autoSw == On && hiSw == Off && loSw == Off && intSw == Off)
	LDI  R26,0
	SBIC 0x6,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x4C
	SBIS 0x6,1
	RJMP _0x4C
	SBIS 0x6,2
	RJMP _0x4C
	SBIC 0x6,3
	RJMP _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
; 0000 00F5         {
; 0000 00F6             modeAuto();
	RCALL _modeAuto
; 0000 00F7         }
; 0000 00F8         else if(hiSw == On && loSw == Off && intSw == Off && autoSw == Off)
	RJMP _0x4E
_0x4B:
	LDI  R26,0
	SBIC 0x6,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x50
	SBIS 0x6,2
	RJMP _0x50
	SBIS 0x6,3
	RJMP _0x50
	SBIC 0x6,4
	RJMP _0x51
_0x50:
	RJMP _0x4F
_0x51:
; 0000 00F9         {
; 0000 00FA             modeHigh();
	RCALL _modeHigh
; 0000 00FB         }
; 0000 00FC         else if(loSw == On && hiSw == Off && intSw == Off && autoSw == Off)
	RJMP _0x52
_0x4F:
	LDI  R26,0
	SBIC 0x6,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x54
	SBIS 0x6,1
	RJMP _0x54
	SBIS 0x6,3
	RJMP _0x54
	SBIC 0x6,4
	RJMP _0x55
_0x54:
	RJMP _0x53
_0x55:
; 0000 00FD         {
; 0000 00FE             modeLow();
	RCALL _modeLow
; 0000 00FF         }
; 0000 0100 
; 0000 0101         else if(intSw == On && hiSw == Off && loSw == Off && autoSw == Off)
	RJMP _0x56
_0x53:
	LDI  R26,0
	SBIC 0x6,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x58
	SBIS 0x6,1
	RJMP _0x58
	SBIS 0x6,2
	RJMP _0x58
	SBIC 0x6,4
	RJMP _0x59
_0x58:
	RJMP _0x57
_0x59:
; 0000 0102         {
; 0000 0103             modeInterrupt();
	RCALL _modeInterrupt
; 0000 0104         }
; 0000 0105         else if(wasSw == On)
	RJMP _0x5A
_0x57:
	SBIC 0x6,5
	RJMP _0x5B
; 0000 0106         {
; 0000 0107             washer();
	RCALL _washer
; 0000 0108         }
; 0000 0109         else
	RJMP _0x5C
_0x5B:
; 0000 010A         {
; 0000 010B             off();
	RCALL _off
; 0000 010C         }
_0x5C:
_0x5A:
_0x56:
_0x52:
_0x4E:
; 0000 010D         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x0
; 0000 010E       }
	RJMP _0x48
; 0000 010F }
_0x5D:
	RJMP _0x5D
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x5,3
	RJMP _0x2020005
_0x2020004:
	CBI  0x5,3
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x5,4
	RJMP _0x2020007
_0x2020006:
	CBI  0x5,4
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x5,5
	RJMP _0x2020009
_0x2020008:
	CBI  0x5,5
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x5,6
	RJMP _0x202000B
_0x202000A:
	CBI  0x5,6
_0x202000B:
	__DELAY_USB 1
	SBI  0x5,2
	__DELAY_USB 2
	CBI  0x5,2
	__DELAY_USB 2
	RJMP _0x2080001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 17
	RJMP _0x2080001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R8,Y+1
	LDD  R7,Y+0
_0x2080002:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x7
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x7
	LDI  R30,LOW(0)
	MOV  R7,R30
	MOV  R8,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	CP   R8,R10
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R7
	ST   -Y,R7
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x2080001
_0x2020013:
_0x2020010:
	INC  R8
	SBI  0x5,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x5,0
	RJMP _0x2080001
_lcd_puts:
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x4,3
	SBI  0x4,4
	SBI  0x4,5
	SBI  0x4,6
	SBI  0x4,2
	SBI  0x4,0
	SBI  0x4,1
	CBI  0x5,2
	CBI  0x5,0
	CBI  0x5,1
	LDD  R10,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x0
	CALL SUBOPT_0x8
	CALL SUBOPT_0x8
	CALL SUBOPT_0x8
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 33
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.DSEG
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(2)
	STS  111,R30
	LDI  R30,LOW(61)
	STS  137,R30
	LDI  R30,LOW(9)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	CALL _lcd_clear
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(244)
	STS  137,R30
	LDI  R30,LOW(27)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G101
	__DELAY_USB 33
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
