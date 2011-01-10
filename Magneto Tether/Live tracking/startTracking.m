% startTracking.m
%
% An example script showing how to start the tracking.
%
% JSB 11/2010

global vid;
global analogOut;

analogOut = setupAnalogOutput();

vid = setupTrackingCamera();
mcam(450);
showAvgView();


