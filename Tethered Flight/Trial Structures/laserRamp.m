
% laserRamp.m

% Odorized box alternates every minute
% Six 1 minute test segments
% Four 1 minute training segments with an iv second pre-laser
% Six 1 minute post-test segments

% Constants
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStimN = [1, 0, -1, center];
LaserOn  = '0000';
LaserOff = '0000';
front = 'ff00'; % front-back
back  = 'ff00'; % left-right
olfOff = '0000';
iv = 20;

histogramBounds = [0,2*60;2*60,3*60;3*60,4*60;4*60,5*60;5*60,6*60;6*60,7*60;7*60,8*60;8*60,9*60;9*60,10*60;10*60,11*60];

trialStructureList = [...
        {0,      visStimN, LaserOff,  olfOff,   olfOff, ''};...     % nb. First line is initial settingss
        {2*60,   visStimN, front,  olfOff,   olfOff, 'ardSetLaserPower(1);'};...
        {3*60,   visStimN, front,  olfOff,   olfOff, 'ardSetLaserPower(5);'};...
        {4*60,   visStimN, front,  olfOff,   olfOff, 'ardSetLaserPower(15);'};...
        {5*60,   visStimN, front,  olfOff,   olfOff, 'ardSetLaserPower(25);'};...
        {6*60,   visStimN, front,  olfOff,   olfOff, 'ardSetLaserPower(50);'};...
        {7*60,   visStimN, front,  olfOff,   olfOff, 'ardSetLaserPower(100);'};...
        {8*60,   visStimN, front,  olfOff,   olfOff, 'ardSetLaserPower(150);'};...
        {9*60,   visStimN, front,  olfOff,   olfOff, 'ardSetLaserPower(200);'};...
        {10*60,   visStimN, front,  olfOff,   olfOff, 'ardSetLaserPower(255);'};...
        {11*60,  visStimN, LaserOff,  olfOff,  olfOff, ''};...
    ];

    