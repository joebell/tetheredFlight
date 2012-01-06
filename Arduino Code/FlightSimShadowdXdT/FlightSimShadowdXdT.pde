
#include <Wire.h>
#include "FlightBoxPins.h"
#include "InstructionCodes.h"
#include "ParamIncludes.h"

#define SAMPLERATE 1250      // Period to run at, in microseconds (limit is about 1250 @ 800 Hz)
#define SAMPPERSEC  800
#define NUMPARAMS    21      // Number of parameters that govern flight
#define BAUDRATE 115200      // Serial baudrate
#define OVERSAMPLE   17      // Bits to oversample position nb. long is 31 bits + sign bit (17)

unsigned long lastMicros;
int toggle;
int params[NUMPARAMS];
int bufferParams[NUMPARAMS];

long avgR;
long avgL;
long sigR;
long sigL;
long avgDiff;
long sigDiff;
int laserSamples;
boolean laserSwitch;


long X;
long sX;
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
   sX = bottomLimitX;
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
          analogWrite(LASERDRIVEPIN, 50);
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


