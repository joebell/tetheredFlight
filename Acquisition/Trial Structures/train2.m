% train2.m

% Constants
global ts;

center = 0;
gain   = -1;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStim0 = [1, 0,  0, center];
visStimN = [1, 0, -1, center];
laserOdor1 = '0000'; 
laserOdor2 = '0000'; 
odorOn     = 'ff00';
laserOff = '0000';
odorOff = '0000';

histogramBounds = [1,2*60; 2*60 , 6*60; 6*60 , 10*60];

trialStructureList = [...
        {0,     visStimN,laserOff,odorOff,odorOff};...     %nb. First line is initial settingss
        {2*60,  visStimN,laserOdor1,odorOn,odorOff};... 
        {6*60,  visStimN,laserOdor2,odorOff,odorOn};...
        {10*60,  visStim0,laserOff,odorOff,odorOff};...
        
    ];

    