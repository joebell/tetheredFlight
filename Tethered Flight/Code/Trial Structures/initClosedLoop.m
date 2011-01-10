
% initClosedLoop.m

% Constants
global ts;

center = 0;

% Format: {time, visStim} 
%          [Mode, K0, K1, K2]
visStim0 = [1, 0,  0, center];
visStimN = [1, 0, -1, center];
%visStimN = [0, 90, 0, 0];
LaserOn  = '0000';
LaserOff = '0000';
olf1 = '0000';
olf2 = '0000';

histogramBounds = [1,3];

trialStructureList = [...
        {0,    visStimN, LaserOff, '0000','0000',''};...     %nb. First line is initial settingss
        {1,    visStimN, LaserOff, olf1,olf2,''};...
        {3,    visStimN, LaserOff, '0000','0000',''};...
    ];

    