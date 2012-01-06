
% longClosedLoop.m

% Constants
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStim0 = [1, 0, 0,  center];
visStimN = [1, 0, -8, 0];
%visStimN = [2, 90,3,0,0,-3,0];
LaserOn  = '0000';
LaserOff = '0000';
olf1 = '0000';
olf2 = '0000';

histogramBounds = [1,4*60;...
                   4*60,8*60;
                   8*60,12*60;
                   12*60,16*60;
                   16*60,20*60;
                   20*60,24*60];

trialStructureList = [...
        {0,    visStimN, LaserOff, '0000','0000','0000'};...     %nb. First line is initial settingss
        {1,    visStimN, LaserOn,  '0000','0000','0000'};...
        {4*60,  visStimN, LaserOn, '0000','0000','0000'};...
        {8*60,  visStimN, LaserOn, '0000','0000','0000'};...
        {12*60,  visStimN, LaserOn, '0000','0000','0000'};...
        {16*60,  visStimN, LaserOn, '0000','0000','0000'};...
        {20*60,  visStimN, LaserOn, '0000','0000','0000'};...
        {24*60,  visStimN, LaserOn, '0000','0000','0000'};...
    ];

    