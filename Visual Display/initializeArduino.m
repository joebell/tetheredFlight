% nb. This causes an arduino reset
function [USB,ardVar] = initializeArduino()

global USB;
global ardVar;

% Constants
ardVar.SampleRate = 800;    % Update rate of flight controller box
ardVar.MaxX = 96;           % Highest X coordinate
ardVar.MinX =  1;           % Lowest X coordinate
ardVar.Oversample = 17;     % Bits of position oversampling in controller

% Commands to issue to the flightbox
ardVar.ee = hex2dec('ee');
ardVar.FlipBuffParam = 0;
ardVar.WriteParam = 1;
ardVar.I2Cecho = 2;
ardVar.SerialEcho = 3;
ardVar.DisplayOn = 4;
ardVar.DisplayOff = 5;
ardVar.ProgPanels = 6;
ardVar.LaserSight = 7;
ardVar.LaserOff   = 8;

% Addresses of Parameters on the FlightBox
ardVar.Mode = 0;
ardVar.K0 = 1;
ardVar.K1 = 2;
ardVar.K2 = 3;
ardVar.K3 = 4;
ardVar.K4 = 5;
ardVar.K5 = 6;

ardVar.LaserPower = 7;

ardVar.SectorsArmed = 8;

ardVar.Olf1Armed = 9;
ardVar.Olf2Armed = 10;
ardVar.Olf3Armed = 11;
ardVar.Olf4Armed = 12;

ardVar.CenterMode = 13;
ardVar.TargetVar = 14;
ardVar.Tau = 15;

ardVar.LaserPowerF = 16;
ardVar.LaserFDur = 17;
ardVar.LaserDecay = 18;
ardVar.LaserPlateauDecay = 19;
ardVar.LaserSwitchMode = 20;


if (isempty(instrfind('Status','open')))
    
    USB = serial('COM4');                        
    USB.BaudRate=115200;   
    fopen(USB);
    pause(4);
    % Need to pause for bootloader before MCU starts listening
    % Board resets on opening serial connections.
    disp('Arduino initialized.'); 
    
else
    disp('Arduino already on...');
end

  
% Don't close the serial port!
% fclose(USB);  





        
    




