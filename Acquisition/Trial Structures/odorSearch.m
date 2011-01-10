
% odorSearch.m

% Constants
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStimN = [1, 0, -1, center];
LaserOn  = '0000';
LaserOff = '0000';
odorOn = '3c00';
EVOn   = '3c00';
olfOff = '0000';

histogramBounds = [1,2*60; 2*60,4*60 ; 4*60,6*60 ; 6*60,8*60 ; 8*60,10*60 ; 10*60,12*60 ; 12*60,14*60 ; 14*60,16*60];

trialStructureList = [...
        {0,      visStimN, LaserOff, olfOff,  olfOff};...     %nb. First line is initial settingss
        {2*60,   visStimN, LaserOff,   EVOn,  olfOff};...
        {4*60,   visStimN, LaserOff, olfOff,  odorOn};...
        {6*60,   visStimN, LaserOff,   EVOn,  olfOff};...
        {8*60,  visStimN, LaserOff, olfOff,  odorOn};...
        {10*60,  visStimN, LaserOff,   EVOn,  olfOff};...
        {12*60,  visStimN, LaserOff, olfOff,  odorOn};...
        {14*60,  visStimN, LaserOff,   EVOn,  olfOff};...
        {16*60,  visStimN, LaserOff, olfOff,  olfOff};...
    ];

    