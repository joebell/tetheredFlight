#include <Wire.h>
#include "FlightBoxPins.h"
#include "InstructionCodes.h"
#include "ParamIncludes.h"

#define SAMPLERATE 1250      // Period to run at, in microseconds (limit is about 1250 @ 800 Hz)
#define NUMPARAMS    15      // Number of parameters that govern flight
#define BAUDRATE 115200      // Serial baudrate
#define OVERSAMPLE   17      // Bits to oversample position nb. long is 31 bits + sign bit (17)

#include "WProgram.h"
void setup();
void loop();
void setupPins();
void transI2C(byte *data, int size);
void receiveSerial();
void flipParams();
void InitPanels();
void ProgramPanels();
void eachCycle(byte coord);
void setupParams();
void takeSample();
unsigned long lastMicros;
int toggle;
int params[NUMPARAMS];
int bufferParams[NUMPARAMS];

long X;
long dXdT;
long topLimitX;
long bottomLimitX;
boolean displayOn;
byte flipB[5] =  {FLIPBUFF, 0,0,0,0};
byte clearB[5] = {CLEARBUFF, 0, 0, 0, 0};
byte lastCoord;


void setup()
{  
   // Turns off the clock pre-scaler for analog outs.  Runs highest at 60 kHz, laser @ 500 Hz
   TCCR1B = 0x09;
   
   // Start the serial port connection
   Serial.begin(BAUDRATE);
      
   setupPins();
   setupParams();   


   // Start the I2C and load default code onto the panels
   // nb. I've tried to get I2C to run faster, but can't get it to work.
   //  There's room for improvement here.
   Wire.begin();    
   InitPanels();
   ProgramPanels();
   
   lastMicros = micros();
   toggle = LOW;
   displayOn = false;
   
   bottomLimitX = ((MINX) << OVERSAMPLE);
   topLimitX = ((MAXX + 1) << OVERSAMPLE);
   
   X = bottomLimitX;
   dXdT = 0;
   lastCoord = -1;
}

void loop() {
   
  unsigned long now = micros();
    
  if ( (now - lastMicros) >= SAMPLERATE) {

      lastMicros = now;
      takeSample();  
      
      if (Serial.available() >= 9) {
        receiveSerial();      
      } 
  }
  
  
  
}

void setupPins() {
  
  pinMode(TOGGLEPIN, OUTPUT);
  pinMode(LASERDRIVEPIN, OUTPUT);
  pinMode(LASERINDICPIN, OUTPUT);
  pinMode(XOUTPIN, OUTPUT);
  pinMode(YOUTPIN, OUTPUT);
  pinMode(SW1PIN, INPUT);
  pinMode(SW2PIN, INPUT);
  pinMode(BLUELEDPIN, OUTPUT);
  pinMode(OLF1PIN, OUTPUT);
  pinMode(OLF2PIN, OUTPUT);
  pinMode(OLF3PIN, OUTPUT);
  pinMode(OLF4PIN, OUTPUT);
  
  digitalWrite(LASERDRIVEPIN, LOW);
  digitalWrite(LASERINDICPIN, LOW);
  digitalWrite(OLF1PIN, LOW);
  digitalWrite(OLF2PIN, LOW);
  digitalWrite(OLF3PIN, LOW);
  digitalWrite(OLF4PIN, LOW);
  digitalWrite(BLUELEDPIN,LOW);
  digitalWrite(OLFINDICPIN, LOW);
  
}

void transI2C(byte *data, int size) {
   Wire.beginTransmission(0);
   Wire.send(data,size);
   Wire.endTransmission();
}

void receiveSerial() {
  
    int i;
    byte instr[5] = {0,0,0,0,0};
    
    int numBytes = Serial.read();
    byte data[24]; 
    for (i=0; i < numBytes; i++) {
      data[i] = Serial.read();
    }
    
    byte r1 = data[0];
    byte r2 = data[1];
    byte r3 = data[2];
    byte r4 = data[3];
    byte r5 = data[4];
    byte r6 = data[5];
    byte r7 = data[6];
    byte r8 = data[7];
          
    // Look for an ee-ee box to make sure it's a valid serial transfer.
    // r2: 0- flip, 1- write, 2- I2C echo, 3- Serial echo
    if (r1 == 0xee && r8 == 0xee) {          
      
      if (r2 == 0) {
        // Flip the buffered parameters
        flipParams();
        lastCoord = -1;
        if (toggle == HIGH) {toggle = LOW;} else {toggle = HIGH;}
        digitalWrite(TOGGLEPIN, toggle);

      } else if (r2 == 1) {
        // Write to buffered parameter at r3 with value r4,r5
        bufferParams[r3] = r4 + (r5 << 8);
        
      } else if (r2 == 2) {
        // I2C echo r3,r4,r5,r6,r7
        instr[0] = r3; instr[1] = r4; instr[2] = r5; instr[3] = r6; instr[4] = r7;
        transI2C(instr,5);        
      } else if (r2 == 3) {
         // Serial echo
         data[0] =  params[r3] & 0x00FF;
         data[1] = (params[r3] & 0xFF00) >> 8;
         Serial.write(data, 2);
      } else if (r2 == 4) {
         // Display ON
         displayOn = true;
         lastCoord = -1;
      } else if (r2 == 5) {
         // Display OFF
         displayOn = false;
         transI2C(clearB, 5);
         transI2C(flipB, 5);
      } else if (r2 == 6) {
          // Reprogram panels
          InitPanels();
          ProgramPanels();
      } else if (r2 == 7) {
          // Laser sight
          digitalWrite(LASERINDICPIN, HIGH);
          analogWrite(LASERDRIVEPIN, 1);
      } else if (r2 == 8) {
          // Laser off
          digitalWrite(LASERINDICPIN, LOW);
          analogWrite(LASERDRIVEPIN, 0);
      }
         
         
      
    }    
}

void flipParams() {
    int i;
    for (i=0; i < NUMPARAMS; i++) {
          params[i] = bufferParams[i];
    }
}





void InitPanels() {
  
  int i;
  byte reset[2] = {0,1};
  
  // Generic code for intializing panels:
   #define PIPLENGTH 6
   byte PIP[30] = {SETGSBITS, 1,0,0,0,CLEARBUFF, 0,0,0,0,FLIPBUFF, 0,0,0,0,CLEARMEM, 1,1,0,0,SETDATA, ONVAL, 0,0,0,SETDATA, OFFVAL, 1,0,0,};
  
  transI2C(reset,2);        // Reset
  delay(2000);
  
  for (i = 0; i < PIPLENGTH; i++) {

     transI2C(&(PIP[5*i]), 5);
    
  }
}

void ProgramPanels() {

  int i;
  
  // Panel code for vertical stripes and gratings, loaded by default
  #define PANELPROGLENGTH 9
  byte PanelRunProg[9] = {C1ICLEARBUFF,RVERTGRATE, X2, X3, X0, ONVAL,C1FLIPBUFF,C1ENDPROG,ENDPROG}; // Program for vertical stripes
  
  byte instr[5] = {SETPROG, 1, 2 , 0, 0};
  
  for (i=0; i < PANELPROGLENGTH; i++) {
    delayMicroseconds(5000);
    instr[1] = (byte) i;
    instr[2] = PanelRunProg[i];
    transI2C(instr,5);
     
  }
}


void eachCycle(byte coord) {
  
  // Code to run each cycle for generic triggered programs 
  byte instrX[5] = {SETDATA, X0, 1, 1, 0};
  instrX[2] = coord;
  transI2C(instrX, 5);
  
}





void setupParams() {
  
  int i;
  
  // Mode1 Position = K0 + K1(delWBA)
  // Model Velocity = K2 + K3(delWBA - K4) 
  
  params[MODE] = 1;    // 0 is position mode, 1 is velocity mode
  params[K0] = 1;
  params[K1] = 0; 
  params[K2] = 0;
  
  params[K3] = 2000;
  params[K4] = 0;
  params[K5] = 0;
  
  params[LASERPOWER] = 1;
  params[SECTORSARMED] = 0;   
  
  params[OLF1ARMED] = 0;
  params[OLF2ARMED] = 0;

 
  // Initialize the buffer with all the params
  for (i=0; i < NUMPARAMS; i++) {
    bufferParams[i] = params[i];
  }
  
}

void takeSample() {
  
  
  byte coord;
  int  scaledCoords;
  int  olf1On;
  int  olf2On;
  
//  if (toggle == HIGH) {toggle = LOW;} else {toggle = HIGH;}
//  digitalWrite(TOGGLEPIN, toggle);
  
  int LAmp = analogRead(LAMPPIN);
  int RAmp = analogRead(RAMPPIN);
  int Freq = analogRead(FREQPIN);
  long delWBA = LAmp - RAmp;
  
  // Update the X variable
  if (params[MODE] == 0) {
      // Position mode
      X  = (((long) params[K0]) << OVERSAMPLE) + params[K1]*(delWBA - params[K2]);
  } else {
      // Velocity mode
      dXdT = params[K3] + params[K4]*(delWBA - params[K5]);
      X = X + dXdT; 
  }

  //  Handle position wrap-around
  if (X >= topLimitX)   { 
     X -= (topLimitX - bottomLimitX);           
  } else if (X < bottomLimitX) { 
      X += (topLimitX - bottomLimitX); 
  } 
  
  coord = (byte) (X >> OVERSAMPLE);
  
  // Activate stored program if the display is turned on.
  if (displayOn) {
       
    // Activate the laser  
    if ((1 << ((coord - 1)/6)) & params[SECTORSARMED]) {
      digitalWrite(LASERINDICPIN, HIGH);
      analogWrite(LASERDRIVEPIN, params[LASERPOWER]);
    } else {
      digitalWrite(LASERINDICPIN, LOW);
      analogWrite(LASERDRIVEPIN, 0);
    }
    
    // Activate the olfactometer channel 1 
    if ((1 << ((coord - 1)/6)) & params[OLF1ARMED]) {
      digitalWrite(OLF1PIN, HIGH);
      olf1On = HIGH;
    } else {
      digitalWrite(OLF1PIN, LOW);
      olf1On = LOW;
    }
    
    // Activate the olfactometer channel 2
    if ((1 << ((coord - 1)/6)) & params[OLF2ARMED]) {
      digitalWrite(OLF2PIN, HIGH);
      olf2On = HIGH;
    } else {
      digitalWrite(OLF2PIN, LOW);
      olf2On = LOW;
    }
    
    digitalWrite(OLFINDICPIN, (olf1On || olf2On));
    digitalWrite(BLUELEDPIN,  (olf1On || olf2On));
    
    // Prevents extraneous updates
    if (lastCoord != coord) {
      eachCycle(coord);    // Calls a function in PanelPrograms to talk to the panels
      lastCoord = coord;
    }
    
  
  }  
  
  // Write the output to the analog pin
  scaledCoords = ((X >> OVERSAMPLE) - MINX)*255/(MAXX - MINX);
  analogWrite(XOUTPIN, scaledCoords);
  
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

