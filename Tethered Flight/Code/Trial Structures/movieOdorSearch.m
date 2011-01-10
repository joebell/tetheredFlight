
% shortOdorSearch.m

% Constants 
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStimN = [1, 0, -1, center];
LaserOn  = '0000';
LaserOff = '0000';
odorOn = '3c00'; % (front wedge)
EVOn   = '3c00';
%odorOn = 'c003'; % 
%EVOn   = 'c003';
olfOff = '0000'; 

histogramBounds = [1,30; 30,60; 60,3*60];

trialStructureList = [...
        {0,      visStimN, LaserOff, olfOff,  olfOff};...     %nb. First line is initial settingss
        {30,   visStimN, LaserOff,   EVOn,  olfOff};...
        {60,   visStimN, LaserOff, olfOff,  odorOn};...
        {3*60,   visStimN, LaserOff,   olfOff,  olfOff};...
    ];

    