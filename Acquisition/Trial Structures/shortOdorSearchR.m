
% shortOdorSearchR.m
% Reversed valve assignments

% Constants
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStimN = [1, 0, -2, center];
LaserOn  = '3c00';
LaserOff = '0000';
odorOn = '00ff'; % (front half)
EVOn   = '00ff';
%odorOn = 'c003'; % (right wedge)
%EVOn   = 'c003';
olfOff = '0000'; 

histogramBounds = [1,2*60; 2*60,4*60 ; 4*60,6*60 ; 6*60,8*60 ; 8*60,10*60];

trialStructureList = [...
        {0,      visStimN, LaserOff, olfOff,  olfOff,olfOff};...     %nb. First line is initial settingss
        {2*60,   visStimN, LaserOff,   olfOff,  EVOn,olfOff};...
        {4*60,   visStimN, LaserOff, odorOn, olfOff,olfOff};...
        {6*60,   visStimN, LaserOff,   olfOff,  EVOn,olfOff};...
        {8*60,  visStimN, LaserOff, odorOn, olfOff,olfOff};...
        {10*60,  visStimN, LaserOff,   olfOff,  olfOff,olfOff};...
    ];

    