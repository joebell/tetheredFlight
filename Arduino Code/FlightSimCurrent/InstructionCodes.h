/* *****************************************************************
 * 
 * instructioncodes.h
 *
 * #define's the panel instruction codes so they're human readable
 *
 * Also contains some privlidged memory locations.  
 * 
 * This file should be kept current with the MATLAB utilities to 
 * make writing panel programs easier. 
 * 
 *
 ********************************************************************/


// Privliged memory locations
#define X0      0x00
#define ONVAL   0x01
#define OFFVAL  0x02
#define X1      0x03
#define Y1		0x04
#define X2		0x05
#define Y2		0x06
#define X3		0x07
#define Y3 		0x08

// Five word codes start at 0x00
#define FIVECODESTART 0x00

#define CLEARBUFF   0x00
#define FLIPBUFF    0x01
#define FIRMWARE    0x02
#define VERTBAR     0x03
#define CLEARMEM    0x04
#define SETDATA     0x05
#define SETPROG     0x06
#define ENDPROG     0x07
#define SETGSBITS   0x08
#define VERTGRATE   0x09
#define HORBAR      0x0A
#define HORGRATE	0x0B
#define STOREBUFF	0x0C
#define GETBUFF     0x0D
#define DISPLAY     0x0E
#define BOX         0x0F
#define RUNPROG     0x10

#define ADD  		0x11
#define SUBT  		0x12
#define MULT  		0x13
#define DIV  		0x14
#define MOD  		0x15
#define JUMPIF  	0x16
#define COPY  		0x17	

#define RCLEARBUFF  0x18
#define RVERTBAR  	0x19
#define RVERTGRATE  0x1A
#define RHORBAR  	0x1B   
#define RHORGRATE  	0x1C  
#define RBOX  		0x1D       
#define RADD  		0x1E		
#define RSUBT  		0x1F
#define RMULT  		0x20
#define RDIV  		0x21
#define RMOD  		0x22	
#define RJUMPIF  	0x23

#define ICLEARBUFF  0x24 
#define IVERTBAR  	0x25   
#define IVERTGRATE  0x26 
#define IHORBAR  	0x27    
#define IHORGRATE  	0x28 
#define IBOX  		0x29 

#define STOREPROG	0x2A
#define LOADPROG	0x2B

#define SETFRAMEMEMSTART 0x2C

#define BOXARRAY	0x2D
#define CHECKER		0x2E

#define PIXEL		0x2F
#define DIAGLINE	0x30

#define RBOXARRAY	0x31
#define RCHECKER	0x32
#define RPIXEL		0x33
#define RDIAGLINE	0x34


#define FIVECODESTOP 0x8F







// One-word codes start at 0x90
#define ONECODESTART 0x90

#define C1FLIPBUFF 		0x90
#define C1ENDPROG		0x91
#define C1ICLEARBUFF	0x92
#define C1IVERTBAR		0x93
#define C1IVERTGRATE	0x94
#define C1IHORBAR		0x95
#define C1IHORGRATE		0x96
#define C1IBOX			0x97
#define C1STOREPROG1	0x98
#define C1STOREPROG2	0x99	
#define C1LOADPROG1		0x9A
#define C1LOADPROG2		0x9B
#define C1BOXARRAY		0x9C
#define C1CHECKER		0x9D
#define C1PIXEL			0x9E
#define C1DIAGLINE		0x9F


#define ONECODESTOP 0xAF







// Two-word codes start at 0xB0
#define TWOCODESTART 0xB0

#define C2CLEARBUFF	0xB0	
#define C2FLIPBUFF	0xB1
#define C2STOREBUFF	0xB2
#define C2GETBUFF	0xB3
#define C2SETGSBITS	0xB4
#define C2ENDPROG	0xB5
#define C2RUNPROG	0xB6
#define C2RCLEARBUFF	0xB7
#define C2ICLEARBUFF	0xB8
#define C2IVERTBAR	0xB9	
#define C2IVERTGRATE	0xBA
#define C2IHORBAR	0xBB
#define C2IHORGRATE	0xBC
#define C2IBOX		0xBD

#define C2SETX1		0xBE
#define C2SETX2		0xBF
#define C2SETX3		0xC0
#define C2SETY1		0xC1
#define C2SETY2		0xC2
#define C2SETY3		0xC3
#define C2SETONVAL	0xC4
#define C2SETOFFVAL	0xC5

#define TWOCODESTOP 0xCF
