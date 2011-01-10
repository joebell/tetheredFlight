% magnetoTfSetup.m

startArd;
disp('Programming panels for 1 stripe 1 box mode...');
pause(3);
progBox;
pause(6);
ardSetBox(6,32,1)
disp('Running X output calibration...');
magnetoCalibrateXOutput();
disp('Running X input calibration...');
magnetoCalibrateXInput();
pause(2);
close(1);
pause(2);
close(2);
startTracking;
