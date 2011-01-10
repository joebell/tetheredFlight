%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    Instruction set for panels
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Privliged memory locations
X0 = hex2dec('00');
ONVAL   = hex2dec('01');
OFFVAL  = hex2dec('02');
X1      = hex2dec('03');
Y1		= hex2dec('04');
X2		= hex2dec('05');
Y2		= hex2dec('06');
X3		= hex2dec('07');
Y3 		= hex2dec('08');

FIVECODESTART = hex2dec('00');

CLEARBUFF   = hex2dec('00');
FLIPBUFF    = hex2dec('01');
FIRMWARE    = hex2dec('02');
VERTBAR     = hex2dec('03');
CLEARMEM    = hex2dec('04');
SETDATA     = hex2dec('05');
SETPROG     = hex2dec('06');
ENDPROG     = hex2dec('07');
SETGSBITS   = hex2dec('08');
VERTGRATE   = hex2dec('09');
HORBAR      = hex2dec('0A');
HORGRATE	= hex2dec('0B');
STOREBUFF	= hex2dec('0C');
GETBUFF     = hex2dec('0D');
DISPLAY     = hex2dec('0E');
BOX         = hex2dec('0F');
RUNPROG     = hex2dec('10');

ADD  		= hex2dec('11');
SUBT  		= hex2dec('12');
MULT  		= hex2dec('13');
DIV  		= hex2dec('14');
MOD  		= hex2dec('15');
JUMPIF  	= hex2dec('16');
COPY  		= hex2dec('17');

RCLEARBUFF  = hex2dec('18');
RVERTBAR  	= hex2dec('19');
RVERTGRATE  = hex2dec('1A');
RHORBAR  	= hex2dec('1B');
RHORGRATE  	= hex2dec('1C');  
RBOX  		= hex2dec('1D');       
RADD  		= hex2dec('1E');		
RSUBT  		= hex2dec('1F');
RMULT  		= hex2dec('20');
RDIV  		= hex2dec('21');
RMOD  		= hex2dec('22');	
RJUMPIF  	= hex2dec('23');

ICLEARBUFF  = hex2dec('24'); 
IVERTBAR  	= hex2dec('25');   
IVERTGRATE  = hex2dec('26'); 
IHORBAR  	= hex2dec('27');    
IHORGRATE  	= hex2dec('28'); 
IBOX  		= hex2dec('29'); 

STOREPROG   = hex2dec('2A');
LOADPROG    = hex2dec('2B');

SETFRAMEMEMSTART = hex2dec('2C');
BOXARRAY         = hex2dec('2D');
CHECKER          = hex2dec('2E');

PIXEL            = hex2dec('2F');
DIAGLINE            = hex2dec('30');

RBOXARRAY            = hex2dec('31');
RCHECKER             = hex2dec('32');
RPIXEL               = hex2dec('33');
RDIAGLINE            = hex2dec('34');

FIVECODESTOP = hex2dec('8F');

% One-word codes start at 0x90
ONECODESTART = hex2dec('90');

C1FLIPBUFF      = hex2dec('90');
C1ENDPROG       = hex2dec('91');
C1ICLEARBUFF	= hex2dec('92');
C1IVERTBAR      = hex2dec('93');
C1IVERTGRATE	= hex2dec('94');
C1IHORBAR       = hex2dec('95');
C1IHORGRATE     = hex2dec('96');
C1IBOX          = hex2dec('97');
C1STOREPROG1	= hex2dec('98');
C1STOREPROG2	= hex2dec('99');
C1LOADPROG1		= hex2dec('9A');
C1LOADPROG2		= hex2dec('9B');

C1BOXARRAY		= hex2dec('9C');
C1CHECKER		= hex2dec('9D');
C1PIXEL		    = hex2dec('9E');
C1DIAGLINE		= hex2dec('9F');

ONECODESTOP = hex2dec('AF');

% Two-word codes start at 0xB0
TWOCODESTART = hex2dec('B0');

C2CLEARBUFF     = hex2dec('B0');	
C2FLIPBUFF      = hex2dec('B1');
C2STOREBUFF     = hex2dec('B2');
C2GETBUFF       = hex2dec('B3');
C2SETGSBITS     = hex2dec('B4');
C2ENDPROG       = hex2dec('B5');
C2RUNPROG       = hex2dec('B6');
C2RCLEARBUFF	= hex2dec('B7');
C2ICLEARBUFF	= hex2dec('B8');
C2IVERTBAR      = hex2dec('B9');	
C2IVERTGRATE	= hex2dec('BA');
C2IHORBAR       = hex2dec('BB');
C2IHORGRATE     = hex2dec('BC');
C2IBOX          = hex2dec('BD');

C2SETX1		= hex2dec('BE');
C2SETX2		= hex2dec('BF');
C2SETX3		= hex2dec('C0');
C2SETY1		= hex2dec('C1');
C2SETY2		= hex2dec('C2');
C2SETY3		= hex2dec('C3');
C2SETONVAL	= hex2dec('C4');
C2SETOFFVAL	= hex2dec('C5');

TWOCODESTOP = hex2dec('CF');
