


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
