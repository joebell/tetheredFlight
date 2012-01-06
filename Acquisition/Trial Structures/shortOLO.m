
% shortOLO.m

% Constants
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStimN = [1, 0, -6, center];
LaserOn  = '3c00';
LaserOff = '0000';
odorOn = 'ffff'; % (front half)
EVOn   = 'ffff';
%odorOn = 'c003'; % (right wedge)
%EVOn   = 'c003';
olfOff = '0000'; 

setBox = 'ardSetBox(6,6,14);';

histogramBounds = [1,10*60;10*60,12*60; 12*60,14*60 ; 14*60,16*60 ; 16*60,18*60 ; 18*60,20*60];

trialStructureList = [...
        {0,      visStimN, LaserOff, olfOff,  olfOff,olfOff,''};...     %nb. First line is initial settingss
        {10*60,   visStimN, LaserOff,olfOff,  olfOff,olfOff,setBox};...
        {12*60,   visStimN, LaserOff,   EVOn,  olfOff,olfOff,''};...
        {14*60,   visStimN, LaserOff, olfOff,  odorOn,olfOff,''};...
        {16*60,   visStimN, LaserOff,   EVOn,  olfOff,olfOff,''};...
        {18*60,  visStimN, LaserOff, olfOff,  odorOn,olfOff,''};...
        {20*60,  visStimN, LaserOff,   olfOff,  olfOff,olfOff,''};...
    ];

    