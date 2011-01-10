
void takeSample() {
  
  
  byte coord;
  int  scaledCoords;
  unsigned long increment;
  
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
    // Commented out to use LASERINDICPIN for olf1On 
    //    if ((1 << ((coord - 1)/6)) & params[SECTORSARMED]) {
    //      digitalWrite(LASERINDICPIN, HIGH);
    //      analogWrite(LASERDRIVEPIN, params[LASERPOWER]);
    //    } else {
    //      digitalWrite(LASERINDICPIN, LOW);
    //      analogWrite(LASERDRIVEPIN, 0);
    //    }
    
    // Update the lockout counter
    increment = micros() - lastTimePoint;
    lastTimePoint = micros(); 
    if ((olf1On == HIGH) || (olf2On == HIGH)) {
      odorElapsed = odorElapsed + increment;
    }
    if (odorElapsed > MAXODORDURATION) {
      lockedOut = true;
    }
    
    // Activate the olfactometer channel 1 
    if (((1 << ((coord - 1)/6)) & params[OLF1ARMED]) && (currentOdor == 1) && (!lockedOut)) {
      digitalWrite(OLF1PIN, HIGH);
      olf1On = HIGH;
    } else {
      digitalWrite(OLF1PIN, LOW);
      olf1On = LOW;
    }
    
    // Activate the olfactometer channel 2
    if (((1 << ((coord - 1)/6)) & params[OLF2ARMED]) && (currentOdor == 2) &&  (!lockedOut)) {
      digitalWrite(OLF2PIN, HIGH);
      olf2On = HIGH;
    } else {
      digitalWrite(OLF2PIN, LOW);
      olf2On = LOW;
    }
    
    // Use laserindicpin for olf1
    // Use olfindicpin for olf2
    digitalWrite(LASERINDICPIN, olf1On);
    digitalWrite(OLFINDICPIN, olf2On);
    digitalWrite(BLUELEDPIN,  (olf1On || olf2On));
    
    // If coordinates change...
    // Prevents extraneous updates
    if (lastCoord != coord) {
      eachCycle(coord);    // Calls a function in PanelPrograms to talk to the panels
      lastCoord = coord;
      
      // If we're at
      if (coord == 24) {
          // Reset the odor lockout clock
          odorElapsed = 0;
          lockedOut = false;
          if ( ODOR1PROB > random(0,200)) {
            currentOdor = 1;
          } else {
            currentOdor = 2;
          }
      }
    }
    
  
  }  
  
  // Write the output to the analog pin
  scaledCoords = ((X >> OVERSAMPLE) - MINX)*255/(MAXX - MINX);
  analogWrite(XOUTPIN, scaledCoords);
  
  
}
