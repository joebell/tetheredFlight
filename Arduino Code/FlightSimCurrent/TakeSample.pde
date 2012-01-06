
void takeSample() {
  
  
  byte displayCoord;
  int  scaledCoords;
  int  olf1On;
  int  olf2On;
  int  olf3On;
  byte laserValveCoord;
  byte tempCoord;  
  
  int LAmp = analogRead(LAMPPIN); // This also takes the video tracking angle input
  int RAmp = analogRead(RAMPPIN);
  int Freq = analogRead(FREQPIN);  
  long delWBA;
  long limit1;
  long limit2; 

  delWBA = ((long) LAmp) - ((long) RAmp);
  
  
  // Update the X variable
  if (params[MODE] == 0) {
      // Position mode
      X  = (((long) params[K0]) << OVERSAMPLE) + params[K1]*(delWBA - params[K2]);
  } else if (params[MODE] == 1) {
      // Velocity mode
      dXdT = params[K3] + params[K4]*(delWBA - params[K5]);
      X = X + dXdT; 
  } else if (params[MODE] == 2) {
      // OL function generator mode

      limit1 = (((long) (params[K0] + params[K1] + 1)) << OVERSAMPLE);
      limit2 = ((long) (params[K0] - params[K1]));
      if (limit2 < 0) { limit2 += 96; }
      limit2 = (limit2 << OVERSAMPLE);
      //Detect direction switches
      if (limit1 > limit2) {
        if ((X >= limit1) || (X <= limit2)) {
          travelSign = -travelSign;
        }
      } 
      else if (limit2 > limit1) {
        if ((X >= limit1) && (X <= limit2)) {
          travelSign = -travelSign;
        }
      }
      
      dXdT = params[K3];
      X = X + travelSign*dXdT; 
      
  }
  

  //  Handle position wrap-around
  if (X >= topLimitX)   { 
     X -= (topLimitX - bottomLimitX);           
  } else if (X < bottomLimitX) { 
      X += (topLimitX - bottomLimitX); 
  } 
  
  displayCoord = (byte) (X >> OVERSAMPLE);
   

  
  // Activate stored program if the display is turned on.
  if (displayOn) {
    
    tempCoord = displayCoord + 8;    
    if (tempCoord > 96) { tempCoord -= 96; }
    laserValveCoord = (96 - (tempCoord))/6;
    if (laserValveCoord > 15) {laserValveCoord -= 16; }   
    if (laserValveCoord < 0) {laserValveCoord += 16;}
    
    // Activate the laser  
    if ((1 << laserValveCoord) & params[SECTORSARMED]) {
      digitalWrite(LASERINDICPIN, HIGH); 
      analogWrite(LASERDRIVEPIN, params[LASERPOWER]);
    } else {
      digitalWrite(LASERINDICPIN, LOW);
      analogWrite(LASERDRIVEPIN, 0);
    }
    
    // Activate the olfactometer channel 1 
    if ((1 << laserValveCoord) & params[OLF1ARMED]) {
      digitalWrite(OLF1PIN, HIGH);
      olf1On = HIGH;
    } else {
      digitalWrite(OLF1PIN, LOW);
      olf1On = LOW;
    }
    
    // Activate the olfactometer channel 2
    if ((1 << laserValveCoord) & params[OLF2ARMED]) {
      digitalWrite(OLF2PIN, HIGH);
      olf2On = HIGH;
    } else {
      digitalWrite(OLF2PIN, LOW);
      olf2On = LOW;
    }
    
    // Activate the olfactometer channel 3
    if ((1 << laserValveCoord) & params[OLF3ARMED]) {
      digitalWrite(OLF3PIN, HIGH);
      olf3On = HIGH;
    } else {
      digitalWrite(OLF3PIN, LOW);
      olf3On = LOW;
    }
        
    digitalWrite(OLFINDICPIN, (olf1On || olf2On || olf3On));
    digitalWrite(BLUELEDPIN,  (olf1On || olf2On || olf3On));
    
    // Prevents extraneous updates
    if (lastCoord != displayCoord) {
      eachCycle(displayCoord);    // Calls a function in PanelPrograms to talk to the panels
      lastCoord = displayCoord;
    }
     
  }  
  
  // Write the output to the analog pin
  scaledCoords = ((X >> OVERSAMPLE) - MINX)*255/(MAXX - MINX);
  analogWrite(XOUTPIN, scaledCoords);
  
}
