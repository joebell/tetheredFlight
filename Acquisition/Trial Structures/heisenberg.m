
% sBoxFix.m

% Constants
global ts;

center = 0;

% Format: {time, visStim} 
%          [Mode, K0, K1, K2]
visStim0 = [0, 90,  0, center];
visStimN = [1, 0,  -2, center];
LaserOn  = '3c3c';
olf1 = '0000';
olf2 = '3c3c';
olf3 = '0000';
olfOff = '0000';
LaserOff = '0000';



histogramBounds = [5,1*120;...
                   1*120+5,2*120+5;2*120+10,3*120+10;...
                   3*120+15,4*120+15;4*120+20,5*120+20;...
                   5*120+25,6*120+25;...
                   6*120+30,7*120+30;7*120+35,8*120+35;...
                   8*120+40,9*120+40;9*120+45,10*120+45;...                
                   ];
colorsOff = 'ardSetColors(0,0);';
colorsOn =  'ardSetColors(0,7);';


trialStructureList = [...
    {0,         visStimN,           LaserOff, olfOff, olfOff, olfOff,        ''};...     %nb. First line is initial settingss
    {1*120,     [0,randi(360),0,0], LaserOff, olfOff, olfOff, olfOff, colorsOff};...
    {1*120+5,   visStimN,           LaserOff,   olf1,   olf2,   olf3,  colorsOn};...
    {2*120+5,   [0,randi(360),0,0], LaserOff, olfOff, olfOff, olfOff, colorsOff};...
    {2*120+10,  visStimN,           LaserOff,   olf1,   olf2,   olf3,  colorsOn};...
    {3*120+10,  [0,randi(360),0,0], LaserOff, olfOff, olfOff, olfOff, colorsOff};...
    {3*120+15,  visStimN,           LaserOn,    olf1,   olf2,   olf3,  colorsOn};...
    {4*120+15,  [0,randi(360),0,0], LaserOff, olfOff, olfOff, olfOff, colorsOff};...
    {4*120+20,  visStimN,           LaserOn,    olf1,   olf2,   olf3,  colorsOn};...
    {5*120+20,  [0,randi(360),0,0], LaserOff, olfOff, olfOff, olfOff, colorsOff};...
    {5*120+25,  visStimN,           LaserOff,   olf1,   olf2,   olf3,  colorsOn};...
    {6*120+25,  [0,randi(360),0,0], LaserOff, olfOff, olfOff, olfOff, colorsOff};...
    {6*120+30,  visStimN,           LaserOn,    olf1,   olf2,   olf3,  colorsOn};...
    {7*120+30,  [0,randi(360),0,0], LaserOff, olfOff, olfOff, olfOff, colorsOff};...
    {7*120+35,  visStimN,           LaserOn,    olf1,   olf2,   olf3,  colorsOn};...
    {8*120+35,  [0,randi(360),0,0], LaserOff, olfOff, olfOff, olfOff, colorsOff};...
    {8*120+40,  visStimN,           LaserOff,   olf1,   olf2,   olf3,  colorsOn};...
    {9*120+40,  [0,randi(360),0,0], LaserOff, olfOff, olfOff, olfOff, colorsOff};...
    {9*120+45,  visStimN,           LaserOff,   olf1,   olf2,   olf3,  colorsOn};...
    {10*120+45, visStimN,           LaserOff, olfOff, olfOff, olfOff, colorsOff};...

    
    ];

    