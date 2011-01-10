
% shortOdorSearch.m

% Constants
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStimN = [1, 0, -1, center];
LaserOn  = '3c00';
LaserOff = '0000';
odorOn = '003c'; % (front wedge)
EVOn   = '003c';
%odorOn = 'c003'; % (right wedge)
%EVOn   = 'c003';
olfOff = '0000'; 

histogramBounds = [1,2*60; 2*60,4*60 ; 4*60,6*60 ; 6*60,8*60 ; 8*60,10*60];

trialStructureList = [...
        {0,      visStimN, LaserOff, olfOff,  olfOff,olfOff};...     %nb. First line is initial settingss
        {2*60,   visStimN, LaserOff,   EVOn,  olfOff,olfOff};...
        {4*60,   visStimN, LaserOff, olfOff,  odorOn,olfOff};...
        {6*60,   visStimN, LaserOff,   EVOn,  olfOff,olfOff};...
        {8*60,  visStimN, LaserOff, olfOff,  odorOn,olfOff};...
        {10*60,  visStimN, LaserOff,   olfOff,  olfOff,olfOff};...
    ];

    