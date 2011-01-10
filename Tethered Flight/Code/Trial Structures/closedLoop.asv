% closedLoop.m

% Constants
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStim0 = [1, 0, 0,  center];
visStimN = [1, 0, -1, center];
LaserOn  = '0000';
LaserOff = '0000';
olf1 = '0000';
olf2 = '0000';

histogramBounds = [10 ,70; 70, 130];

trialStructureList = [...
        {0,    visStim0, LaserOff,olf1,olf2};...     %nb. First line is initial settingss
        {10,   visStimN, LaserOff,olf1,olf2};...
        {70,   visStimN, LaserOff,olf1,olf2};...
        {130,  visStim0, LaserOff,olf1,olf2};...
        {140,  visStim0, LaserOff,olf1,olf2};...
    ];

    