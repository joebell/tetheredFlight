#include <Wire.h>


//D-Outs
int LedPin = 13;
int sw1 = 2;
int sw2 = 3;
int YledPin =  5;    // LED connected to digital pin 13
int BledPin =  4;
int LaserPin = 6;
int I2CsyncPin = 9;
int AnalogOut1Pin = 10;

    byte i = 0;
    byte j = 0;
    byte k = 0;
    byte loopSize = 8*12;
    
    byte reset[2] = {0, 1};
    byte clearBuffer[5] = {0, 0, 0, 0, 0};
    byte gradient[3] = {240, 204, 170};
    byte setGS[5] = {8,3,0,0,0};
    byte drawLine[5] =  {3, 0, 2, 0, 0};
    byte drawLight[5] = {3, 0, 2, 2, 0};
    byte flip[5] = {1,0,0,0,0};
    byte xRange[5] = {2,1,1,7,1};
    byte dispVal[5] = {0x0E,1,1,0,0};
    byte checker[5] = {0x2E,4,4,3,7};
    byte dataSet[5] = {0x05,1,7,0,0};

void setup()
{
  // Turns off the clock pre-scaler for analog outs.
  TCCR1B = 0x09;
  
  pinMode(YledPin, OUTPUT);    
  pinMode(sw1, INPUT); 
  pinMode(BledPin, OUTPUT);    
  pinMode(sw2, INPUT); 
  
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);


    Wire.begin();
    pinMode(LedPin, OUTPUT);
    // Set baud rate
    // Wait for the computer to write at least one parameter
    // Blink LED to show waiting status
    Serial.begin(9600);
    
    Wire.beginTransmission(0);
    Wire.send(reset,2);
    Wire.endTransmission();
    delay(2000);
    
    Wire.beginTransmission(0);
    Wire.send(setGS,5);
    Wire.endTransmission();
    delay(2000);
    
    Wire.beginTransmission(0);
    Wire.send(dataSet,5);
    Wire.endTransmission();
    delay(2000);
    
   // Wire.beginTransmission(0);
   // Wire.send(gradient, 3);
    // Wire.endTransmission();


}

void loop()
{
  int sw1State;
  int sw2State;
  int thresh;
  
  sw1State = digitalRead(sw1);
  sw2State = digitalRead(sw2);
  //digitalWrite(YledPin, sw1State);   // set the LED on
  digitalWrite(BledPin, sw2State); 
  
  
  /*
    dispVal[3] = j;
    Wire.beginTransmission(0);
    Wire.send(dispVal, 5);
    Wire.endTransmission();
    j++;
    delay(1000);
*/
    Wire.beginTransmission(0);
    Wire.send(clearBuffer, 5);
    Wire.endTransmission();
    
    digitalWrite(LedPin, HIGH);
    drawLine[1] = i;
    drawLine[2] = i + 1;
    drawLight[1] = i-1;
    drawLight[2] = i+2;
//    Wire.beginTransmission(0);
//    Wire.send(drawLight, 5);
//    Wire.endTransmission();
//    Wire.beginTransmission(0);
//    Wire.send(drawLine, 5);
//    Wire.endTransmission();
    
    checker[3] = i;
    checker[4] = k;
    Wire.beginTransmission(0);
    Wire.send(checker, 5);
    Wire.endTransmission();

    digitalWrite(LedPin, LOW);
    
    Wire.beginTransmission(0);
    Wire.send(flip, 5);
    Wire.endTransmission();
    
    if (sw2State == HIGH) {
        thresh = 12;
    } else {
        thresh = 9;
    }
    
    j = j + 1;   
    if (j % thresh == 0) { 
      if (sw1State == HIGH) {
        i = i + 1;
      } else { 
        i = i - 1;
      }
      if (i > loopSize) { 
          i = 1;
      }
      if (i == 0) { i = loopSize; }
      if (j % thresh == 0 && sw2State == HIGH) { k = k + 1; }
    }  
    if (j % 200 == 0) {j = 1;}
    
    analogWrite(5, 0 * 255 / loopSize);
    analogWrite(6, 0 * 255 / loopSize);
    analogWrite(9, 0 * 255 / loopSize);
    analogWrite(10, 0 * 255 / loopSize);
    analogWrite(11, 0 * 255 / loopSize);
   
}


