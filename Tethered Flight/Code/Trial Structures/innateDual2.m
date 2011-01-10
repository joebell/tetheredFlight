

% innateDual.m

% Constants
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStimN = [1, 0, -1, center];
LaserOn  = '0000';
LaserOff = '0000';
front = 'ff00';
back  = '00ff';
olfOff = '0000';
iv = 20;

histogramBounds = [1,2,2,2*60,;...
    2*60,4*60,6*60,8*60;...
    4*60,6*60,8*60,10*60;...
    ]; 

trialStructureList = [...
        {0,      visStimN, LaserOff, olfOff,  olfOff};...     %nb. First line is initial settingss
        {2*60,   visStimN, LaserOff, front,  back};...
        {4*60,   visStimN, LaserOff, back,  front};...
        {6*60,   visStimN, LaserOff, front,  back};...
        {8*60,   visStimN, LaserOff, back,  front};...
        {10*60,  visStimN, LaserOff, olfOff,  olfOff};...
    ];

    