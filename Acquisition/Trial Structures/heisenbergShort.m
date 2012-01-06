
% heisenbergShort.m

% Constants
global ts;

center = 0;

% Format: {time, visStim} 
%          [Mode, K0, K1, K2]
visStim0 = [0, 90,  0, center];
visStimN = [1, 0,  -2, center];
LaserOn  = 'c3c3';
LaserOff = '0000';
olf1 = '0000';
olf2 = '0000';

histogramBounds = [5,1*120;1*120+5,2*120+5;2*120+10,3*120+10;3*120+15,4*120+15;4*120+20,5*120+20];
colorsOff = 'ardSetColors(0,0);';
colorsOn =  'ardSetColors(0,7);';
randoms = randi(360,4,1);

trialStructureList = [...
        {0,        visStimN, LaserOff, '0000','0000','0000',''};...     %nb. First line is initial settingss
        {1*120,[0,randoms(1),0,0], LaserOff, '0000','0000','0000',colorsOff};...
        {1*120+5,    visStimN, LaserOff, '0000','0000','0000',colorsOn};...
        {2*120+5,[0,randoms(2),0,0], LaserOff, '0000','0000','0000',colorsOff};...
        {2*120+10,    visStimN, LaserOn, '0000','0000','0000',colorsOn};...
        {3*120+10,[0,randoms(3),0,0], LaserOff, '0000','0000','0000',colorsOff};...
        {3*120+15,    visStimN, LaserOn, '0000','0000','0000',colorsOn};...
        {4*120+15,[0,randoms(4),0,0], LaserOff, '0000','0000','0000',colorsOff};...
        {4*120+20,    visStimN, LaserOff, '0000','0000','0000',colorsOn};...
        {5*120+20,visStimN, LaserOff, '0000','0000','0000',''};...
    ];

    