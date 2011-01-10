
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
  
  long subt;
  // Update running averages
  subt = avgR / tau;
  avgR = avgR - subt + RAmp;
  subt = avgL / tau;
  avgL = avgL - subt + LAmp;
    
  // long delWBA = LAmp - RAmp;
  // Implements a high-pass filter on delWBA for auto-centering 
  long delWBA = (LAmp - (avgL/tau)) - (RAmp - (avgR/tau));
  
  
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
