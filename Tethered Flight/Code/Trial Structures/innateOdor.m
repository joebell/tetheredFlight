% innateOdor.m

% Constants
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStim0 = [1, 0,  0, center];
visStimN = [1, 0, -1, center];
laserOn = '0000'; %00ff
laserOff = '0000';
olfOff = '0000';
olf1On = 'ff00'; % 00ff
olf2On = 'ff00'; % ff00

histogramBounds = [1,1*60; 1*60 , 3*60; 3*60 , 5*60];

trialStructureList = [...
        {0,     visStimN,laserOff,olfOff,olfOff};...     %nb. First line is initial settingss
        {1*60,  visStimN,laserOff,olfOff,olfOff};... 
        {3*60,  visStimN,laserOff,olfOff,olf2On};...
        {5*60,  visStim0,laserOff,olfOff,olfOff};...
        
    ];

    