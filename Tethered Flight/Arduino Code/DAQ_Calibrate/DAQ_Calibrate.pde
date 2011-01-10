#include <Wire.h>

void setup() {
  
  Serial.begin(9600);
}

void loop() {
  
  int r, l, f;
  l = analogRead(1);
  r = analogRead(0);
  f = analogRead(2);

  Serial.print(l);
  Serial.print(' ');
  Serial.print(r);
  Serial.print(' ');
  Serial.println(f);
  delay(1000);
  
}
