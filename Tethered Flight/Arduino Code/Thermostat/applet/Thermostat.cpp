#include <PID_Beta6.h>
#include <spi.h>

// MAX6675 connected to SPI bus
#define MAX6675_SELECT_PIN 8
#define DESELECT_MAX6675 digitalWrite(MAX6675_SELECT_PIN, HIGH)
#define SELECT_MAX6675 digitalWrite(MAX6675_SELECT_PIN, LOW)

// Pin Defs

#include "WProgram.h"
void setup();
void loop();
void setHeater(double heaterOut);
void setFans();
void checkForModeChange();
void checkTemperature();
void checkButtonPress();
void blinkForMode();
void blinkForStatus(int tempDiff);
const int PWM1pin = 10; 
const int PWM2pin = 9; 
const int PWM3pin = 6;
const int PWM4pin = 5; 

const int ModeLEDpin = 2;
const int StatusLEDpin = 3;
const int ModeSwitchPin = 4;

// Mode parameters
const int numModes = 5;
const int OFF = 0;
const int MODE1 = 1;
const int MODE2 = 2;
const int MODE3 = 3;
const int MODE4 = 4;

int mode = 0;
int modeState = 0;
int statusState = 0;
int heaterState = LOW;
long lastModeMillis = 0;
long lastStatusMillis = 0;
long lastTempMillis = 0;
long lastHeaterMillis = 0;
int LEDState = LOW;
int lastButtonState = HIGH;


// PID variables
double currentTemp = 23.0;
double setTemp = 26.0;
double heaterOut = 0.0;
double P = 50;
double I = 10;
double D = 0;

PID tempPID(&currentTemp, &heaterOut, &setTemp, P, I, D);



//////////////////////////////////////////
// Parameters for running
//////////////////////////////////////////
const double mode1Target = 22.0;
const double mode2Target = 25.0;
const double mode3Target = 32.0;
const double mode4Target = 37.0;

const double calOffset = -2.0;  // Adjust read temp by this much
const double maxHeater = .3;    // Maximum heater duty cycle (out of 1)

const int HeaterPin = PWM4pin;
const int HeaterFanPin = PWM3pin;
const int VentFanPin = PWM2pin;
//////////////////////////////////////////

void setup()
{
  
  // Setup serial and thermometer
  pinMode(MAX6675_SELECT_PIN, OUTPUT);
  DESELECT_MAX6675;
  setup_spi(SPI_MODE_1, SPI_MSB, SPI_NO_INTERRUPT, SPI_MSTR_CLK8);
  Serial.begin(9600);
  
  pinMode(PWM1pin, OUTPUT);
  pinMode(PWM2pin, OUTPUT);
  pinMode(PWM3pin, OUTPUT);
  pinMode(PWM4pin, OUTPUT);
  
  pinMode(StatusLEDpin, OUTPUT);
  pinMode(ModeLEDpin, OUTPUT);
  pinMode(ModeSwitchPin, INPUT);
  
  analogWrite(PWM1pin, 0);
  analogWrite(PWM2pin, 0);
  analogWrite(PWM3pin, 0);
  analogWrite(PWM4pin, 0);
  digitalWrite(StatusLEDpin, LOW);
  digitalWrite(ModeLEDpin, LOW);
  
  // Turn on the fans

  
  tempPID.SetMode(AUTO);

  
}

void loop()
{
   
  checkButtonPress();
  
  checkForModeChange();
  blinkForMode();
  
  checkTemperature();
  blinkForStatus(currentTemp - setTemp);
  tempPID.Compute();
  setFans();
  
  if (mode == OFF) { heaterOut = 0; } 
  setHeater(heaterOut);
}


// This implements a long PWM on heaterPeriod...
void setHeater(double heaterOut) {
  
  long heaterPeriod = 3*1000;  // ms
  long waitFor;
  
  double heatFract = heaterOut*maxHeater/255;
  
  if (heaterState == LOW) {
    waitFor = (1 - heatFract)*heaterPeriod;
  } else if (heaterState == HIGH) {
    waitFor = (heatFract)*heaterPeriod;
  }
  if (millis() > lastHeaterMillis + waitFor) {
    lastHeaterMillis = millis();
    if (heaterState == LOW) { 
      heaterState = HIGH; 
      analogWrite(HeaterPin, 255);
      // digitalWrite(StatusLEDpin, HIGH);
    } else if (heaterState == HIGH) { 
      heaterState = LOW; 
      analogWrite(HeaterPin,0);
      // digitalWrite(StatusLEDpin, LOW);
    }
  }
  
  
}






void setFans() {
  if (currentTemp - setTemp > 0 & mode != OFF) {
      analogWrite(HeaterFanPin, 255);
      analogWrite(VentFanPin, 255);
  } else if (currentTemp - setTemp <= 0 & mode != OFF) {
      analogWrite(HeaterFanPin, 255);
      analogWrite(VentFanPin, 255);
  } else { 
      analogWrite(HeaterFanPin, 0);
      analogWrite(VentFanPin, 0);
  }
}




void checkForModeChange() {
  
  switch(mode) {
    case OFF:
      break;
    case MODE1:
      setTemp = mode1Target;
      break;
    case MODE2:
      setTemp = mode2Target;
      break;
    case MODE3:
      setTemp = mode3Target;
      break;
    case MODE4:
      setTemp = mode4Target;
      break;
  }
  
}

void checkTemperature() {
  long tempPeriod = 500;
  
  // Every tempPeriod (ms), get a temp reading and store it to currentTemp
  if (millis() > lastTempMillis + tempPeriod) {
     lastTempMillis = millis(); 
     
     // select the device, wait > 100nS, read two bytes, deselect, write to serial
     SELECT_MAX6675;
     delay(1);
     unsigned char highByte = send_spi(0);
     unsigned char lowByte = send_spi(0);
     delay(1);
     DESELECT_MAX6675;
     
   
     // if bit 3 is high thermocouple is unconnected
     if (lowByte & (1<<2)) {
     //  if (true) {
       Serial.print("Not connected ");
       Serial.print(highByte, HEX); Serial.print(" ");
       Serial.println(lowByte, HEX);
     } else {
       // temperature value is in bits 6-0 of highByte and 7-2 of lowByte
       short value = (highByte << 5 | lowByte>>3);
       // 1 bit is 0.25 degree 'divide' by 4 to show degrees
       Serial.print("Temp: ");
       currentTemp = (value/4) + ((double) (value%4 *.25)) + calOffset;
       Serial.println(currentTemp); 
     }
     
       
     Serial.print("Heater: ");
     Serial.println(heaterOut, DEC);

  }
}

void checkButtonPress() {
  
  long debounceDelay = 500; 
  int reading = digitalRead(ModeSwitchPin);
  
  if (reading != lastButtonState) {
    lastButtonState = reading;
    // Any code here...
    //////////////////////////////////////
    mode++;
    if (mode >= numModes) { mode = 0; }   
    ////////////////////////////////////// 
    delay(debounceDelay);
  }
  lastButtonState = digitalRead(ModeSwitchPin); 
}


// The mode LED blinks along
void blinkForMode() {
  
  const long modePeriod = 250;
  const int numModeFrames = 8;
  const int modePatterns[numModes][numModeFrames] = {{LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW},{HIGH, LOW, LOW, LOW, LOW, LOW, LOW, LOW},{HIGH, LOW, HIGH, LOW, LOW, LOW, LOW, LOW},{HIGH, LOW, HIGH, LOW, HIGH, LOW, LOW, LOW},{HIGH, LOW, HIGH, LOW, HIGH, LOW, HIGH, LOW}};

  // If a modePeriod has elapsed, reset the timer, increment the modeState, and Flip the LED
  if (millis() > lastModeMillis + modePeriod) {
    lastModeMillis = millis();
    modeState++;
    if (modeState >= numModeFrames) {modeState = 0;}
    digitalWrite(ModeLEDpin, modePatterns[mode][modeState]);
  }
    
}



// When tempDiff = +n (sample is too hot) then the light is tonically on and winks out n times
// When tempDiff = -n (sample is too cold) then the light is tonically off and winks on n times
void blinkForStatus(int tempDiff) {
  
  const int statusPause = 5;
  long statusPeriod = 150;
  long tempCorrectPeriod = 50; 
  
  int tonicState;
  int notTonicState;
   
  if (tempDiff > 1) {
    tonicState = HIGH;
    notTonicState = LOW;
  } else if (tempDiff < -1) {
    tonicState = LOW;
    notTonicState = HIGH;
  }  else if (abs(tempDiff) <= 1) {
    tonicState = LOW;
    notTonicState = HIGH;
    statusPeriod = tempCorrectPeriod;
  }
  
  if (millis() > lastStatusMillis + statusPeriod &&  abs(tempDiff) > 1) {
    lastStatusMillis = millis();
    statusState++;
    // If we're still counting the difference...
    if (statusState < abs(tempDiff)*2) {    
      // If it's an even status
      if (statusState % 2 == 0) {
        digitalWrite(StatusLEDpin, tonicState);
      } else {
        digitalWrite(StatusLEDpin, notTonicState);
      }
    // If we've counted but aren't done pausing...
    } else if (2*(abs(tempDiff) + statusPause) >= statusState && statusState >= 2*abs(tempDiff)) {
      digitalWrite(StatusLEDpin, tonicState);
    // If we're done pausing...  
    } else if (statusState > 2*(abs(tempDiff) + statusPause)) {
      statusState = 0;
      digitalWrite(StatusLEDpin, tonicState);
    }
    
    if (mode == OFF) { digitalWrite(StatusLEDpin, LOW); }
    
  } else if (millis() > lastStatusMillis + statusPeriod &&  abs(tempDiff) <= 1) {
    lastStatusMillis = millis();
    statusState++;
    if (statusState % 2 == 0) {
      digitalWrite(StatusLEDpin, tonicState);
    } else {
      digitalWrite(StatusLEDpin, notTonicState);
    }
    if (mode == OFF) { digitalWrite(StatusLEDpin, LOW); }
  
  } 
}




int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

