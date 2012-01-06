% tfSetup.m

disp('Starting camera...');
camera();
disp('Starting flight computer...');
startArd;
disp('Programming panels for 1 stripe 1 box mode...');
pause(10);
progBox;
pause(6);
ardSetBox(6,32,1)
disp('Running X output calibration...');
calibrateXOutput();
ardSetArenaBindings([1,0,-1,0]);


disp('----------------------------------');
disp('   Tethered flight ready to run.  ');
disp('----------------------------------');
disp(' ');

aPipeFlusher;

