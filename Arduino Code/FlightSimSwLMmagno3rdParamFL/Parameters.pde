


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
  params[LASERPOWERF] = 1;
  params[LASERFDUR] = 800;
  params[LASERDECAY] = 3;
  params[LASERPLATDECAY] = 0;
  params[LASERSWITCHMODE] = 0;
  params[SECTORSARMED] = 0;  
  
  params[OLF1ARMED] = 0;
  params[OLF2ARMED] = 0;
  params[OLF3ARMED] = 0;
  
  params[CENTERMODE] = 0;
  params[TARGETVAR] = 100;
  params[TAUC] = 10000;       // Units in ms

 
  // Initialize the buffer with all the params
  for (i=0; i < NUMPARAMS; i++) {
    bufferParams[i] = params[i];
  }
  
}
