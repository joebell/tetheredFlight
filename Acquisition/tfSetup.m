% tfSetup.m

disp('Starting camera...');
uprightVid = setupCamera();
cam(500);
set(gcf, 'Position',[1198 384 480 640]);
vid2 = setupCamera2();
set(gcf, 'Position',[1037 36 640 480]);
cam2(300);
disp('Starting flight computer...');
startArd;
disp('Programming panels for 1 stripe 1 box mode...');
pause(3);
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

