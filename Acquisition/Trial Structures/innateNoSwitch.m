

% innateDual.m

% Constants
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStimN = [1, 0, -1, center];
LaserOn  = '0000';
LaserOff = '0000';
front = '3c00';
back  = '003c';
olfOff = '0000';
iv = 20;

histogramBounds = [1,2*60,;...
    2*60,10*60;...
    ]; 

trialStructureList = [...
        {0,      visStimN, LaserOff, olfOff,  olfOff};...     %nb. First line is initial settingss
        {2*60,   visStimN, LaserOff, front,  back};...
        {10*60,  visStimN, LaserOff, olfOff,  olfOff};...
    ];

    