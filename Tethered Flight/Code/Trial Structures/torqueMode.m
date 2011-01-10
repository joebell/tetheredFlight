
% torqueMode.m

% Constants
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStim0 = [1, 0, 0,  center];
visStimN = [0, 90, -.7, 235];
LaserOn  = '0000';
LaserOff = '0000';
olf1 = '0000';
olf2 = '0000';

histogramBounds = [1,2*60;2*60,4*60;4*60,6*60;6*60,8*60];

trialStructureList = [...
        {0,    visStimN, LaserOff, '0000','0000'};...     %nb. First line is initial settingss
        {1,    visStimN, LaserOff, '0000','0000'};...
        {2*60,  visStimN, '0ff0', '0000','0000'};...
        {4*60,  visStimN, 'f00f', '0000','0000'};...
        {6*60,  visStimN, '0000', '0000','0000'};...
        {8*60,  visStimN, '0000', '0000','0000'};...
    ];

    