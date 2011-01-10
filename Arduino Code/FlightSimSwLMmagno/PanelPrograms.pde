


void InitPanels() {
  
  int i;
  byte reset[2] = {0,1};
  
  // Generic code for intializing panels:
   #define PIPLENGTH 6
   byte PIP[30] = {SETGSBITS, 1,0,0,0,CLEARBUFF, 0,0,0,0,FLIPBUFF, 0,0,0,0,CLEARMEM, 1,1,0,0,SETDATA, ONVAL, 0,0,0,SETDATA, OFFVAL, 1,0,0,};
  
  transI2C(reset,2);        // Reset
  delay(2000);
  
  for (i = 0; i < PIPLENGTH; i++) {

     transI2C(&(PIP[5*i]), 5);
    
  }
}

void ProgramPanels() {

  int i;
  
  // Panel code for vertical stripes and gratings, loaded by default
  #define PANELPROGLENGTH 9
  byte PanelRunProg[9] = {C1ICLEARBUFF,RVERTGRATE, X2, X3, X0, ONVAL,C1FLIPBUFF,C1ENDPROG,ENDPROG}; // Program for vertical stripes
  
  byte instr[5] = {SETPROG, 1, 2 , 0, 0};
  
  for (i=0; i < PANELPROGLENGTH; i++) {
    delayMicroseconds(5000);
    instr[1] = (byte) i;
    instr[2] = PanelRunProg[i];
    transI2C(instr,5);
     
  }
}


void eachCycle(byte coord) {
  
  // Code to run each cycle for generic triggered programs 
  byte instrX[5] = {SETDATA, X0, 1, 1, 0};
  instrX[2] = coord;
  transI2C(instrX, 5);
  
}


