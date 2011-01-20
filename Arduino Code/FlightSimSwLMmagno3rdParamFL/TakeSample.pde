
void takeSample() {
  
  
  byte displayCoord;
  int  scaledCoords;
  int  olf1On;
  int  olf2On;
  int  olf3On;
  byte laserValveCoord;
  byte tempCoord;
  long magnoCoord;
  

  
//  if (toggle == HIGH) {toggle = LOW;} else {toggle = HIGH;}
//  digitalWrite(TOGGLEPIN, toggle);
  
  int LAmp = analogRead(LAMPPIN); // This also takes the video tracking angle input
  int RAmp = analogRead(RAMPPIN);
  int Freq = analogRead(FREQPIN);  
  
  long tau = ((long) params[TAUC])*800/1000;
  // long tau = 10*800;
  long subt;
  // Update running averages
  subt = avgR / tau;
  avgR = avgR - subt + RAmp;
  subt = avgL / tau;
  avgL = avgL - subt + LAmp;
  subt = sigR / tau;
  sigR = sigR - subt + abs(RAmp - (avgR/tau));
  subt = sigL / tau;
  sigL = sigL - subt + abs(LAmp - (avgL/tau));
  // For threshold
  subt = avgDiff / tau;
  avgDiff = avgDiff - subt + (LAmp - RAmp);
  subt = sigDiff / tau;
  sigDiff = sigDiff - subt + abs((LAmp - RAmp) - (avgDiff/tau));
  
    
  // long delWBA = LAmp - RAmp;
  // Implements a high-pass filter on delWBA for auto-centering 
  long delWBA;
  // Straight-up mode
  if (params[CENTERMODE] == 0) {
     delWBA = LAmp - RAmp;
  // Auto-center mode
  } else if (params[CENTERMODE] == 1) {
     delWBA = (LAmp - (avgL/tau)) - (RAmp - (avgR/tau));
  // Auto-center + auto-gain mode
  } else if (params[CENTERMODE] == 2) {
     delWBA = (LAmp - (avgL/tau))*(params[TARGETVAR]*tau)/sigL - (RAmp - (avgR/tau))*(params[TARGETVAR]*tau)/sigR;
  // Saccade mode
  } else if (params[CENTERMODE] == 3) {
     delWBA = (LAmp - RAmp) - avgDiff/tau;
     if (abs(delWBA) < params[TARGETVAR]*sigDiff/(tau*100)) {
       delWBA = 0;
     } 
  // Low-pass mode
  } else if (params[CENTERMODE] == 4) {
     delWBA = avgDiff / tau;
  // Magneto-tether modes:
  // 5 makes drum and fly independent, outputs drum on X line
  // 6 mirrors fly position with stripe position and outputs on X line
  // 7 makes drum and fly independent, outputs fly on X line
  } else if ((params[CENTERMODE] == 5) || (params[CENTERMODE] == 6) || (params[CENTERMODE] == 7)) {
     delWBA = LAmp;
     magnoCoord = ((((long) LAmp) * ((long) 96))/((long) 800)) + 1;
  } 
  
  // Update the X variable
  if (params[MODE] == 0) {
      // Position mode
      X  = (((long) params[K0]) << OVERSAMPLE) + params[K1]*(delWBA - params[K2]);
  } else if (params[MODE] == 1) {
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
  
   // Deal with magno-mirror mode (6)
   if (params[CENTERMODE] == 6) {
      X = (magnoCoord << OVERSAMPLE);
   } 
   
   displayCoord = (byte) (X >> OVERSAMPLE);
   

  
  // Activate stored program if the display is turned on.
  if (displayOn) {
    
    // If we're in magneto tether, use the magneto coordinates for activating the laser.
    // nb. That the arena still runs off of 'coord'
    if ((params[CENTERMODE] == 5) ||  (params[CENTERMODE] == 6) ||  (params[CENTERMODE] == 7)) {
      tempCoord = (byte) magnoCoord + 8;
    } else {
      tempCoord = displayCoord + 8;    
    }
    if (tempCoord > 96) { tempCoord -= 96; }
    laserValveCoord = (96 - (tempCoord))/6;
    if (laserValveCoord > 15) {laserValveCoord -= 16; }   
    if (laserValveCoord < 0) {laserValveCoord += 16;}
    
    // Activate the laser  
    if ((1 << laserValveCoord) & params[SECTORSARMED]) {
      digitalWrite(LASERINDICPIN, HIGH); 
      if (laserSamples < params[LASERFDUR]*10) {
        analogWrite(LASERDRIVEPIN, params[LASERPOWERF]);
        laserSamples += 10;
      } else {
        analogWrite(LASERDRIVEPIN, params[LASERPOWER]);
        if (laserSamples > 0) { laserSamples -= params[LASERPLATDECAY]; }
      }
    } else {
      digitalWrite(LASERINDICPIN, LOW);
      analogWrite(LASERDRIVEPIN, 0);
      if (laserSamples > 0) { laserSamples -= params[LASERDECAY]; }
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
    
    // Activate the olfactometer channel 2
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
   if (params[CENTERMODE] == 7) {
      scaledCoords = ((magnoCoord) - MINX)*255/(MAXX - MINX);
   } else {
      scaledCoords = ((X >> OVERSAMPLE) - MINX)*255/(MAXX - MINX);
   }
  analogWrite(XOUTPIN, scaledCoords);
  
}
