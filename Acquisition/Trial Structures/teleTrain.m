% closedLoop.m

% Constants
global ts;

center = -100;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStim0 = [1, 0, 0,  center];
visStimN = [1, 0, -1, center];
rand1 = [0, rand(1)*360, 0, 0];
rand2 = [0, rand(1)*360, 0, 0];
rand3 = [0, rand(1)*360, 0, 0];
rand4 = [0, rand(1)*360, 0, 0];
rand5 = [0, rand(1)*360, 0, 0];
rand6 = [0, rand(1)*360, 0, 0];
rand7 = [0, rand(1)*360, 0, 0];
rand8 = [0, rand(1)*360, 0, 0];
rand9 = [0, rand(1)*360, 0, 0];
rand10 = [0, rand(1)*360, 0, 0];
rand11 = [0, rand(1)*360, 0, 0];
rand12 = [0, rand(1)*360, 0, 0];
rand13 = [0, rand(1)*360, 0, 0];
rand14 = [0, rand(1)*360, 0, 0];

LaserOn  = '0000';
LaserOff = '0000';
olf1 = '00ff';
olf2 = '0000';
olfOff = '0000';


histogramBounds = [101, 106, 121, 126, 141, 146, 161, 166, 181, 186, 201, 206, 221, 226, 241, 246, 261, 266, 281, 286, 301, 306, 321, 326 ;...
                   106, 120, 126, 140, 146, 160, 166, 180, 186, 200, 206, 220, 226, 240, 246, 260, 266, 280, 286, 300, 306, 320, 326, 340 ;...
                   1, 10,10, 20, 20, 30, 30, 40, 40, 50,  50,  60,  60,  70,  70,  80,  80,  81,  81,  82,  82,  83,  83, 100];

trialStructureList = [...
        {0,   visStimN, LaserOff,olfOff,'0000'};...     %nb. First line is initial settingss
        {1,   visStimN, LaserOff,'0000','0000'};...
        {100+0,   rand1, LaserOff,olf1,olf2};...
        {100+1,   visStimN, LaserOff,olf1,olf2};...
        {100+6,   visStimN, LaserOn,olf1,olf2};...
        {100+20,  rand2, LaserOff,olf1,olf2};...
        {100+21,  visStimN, LaserOff,olf1,olf2};...
        {100+26,   visStimN, LaserOn,olf1,olf2};...
        {100+40,  rand3, LaserOff,olf1,olf2};...
        {100+41,  visStimN, LaserOff,olf1,olf2};...
        {100+46,   visStimN, LaserOn,olf1,olf2};...
        {100+60,  rand4, LaserOff,olf1,olf2};...
        {100+61,  visStimN, LaserOff,olf1,olf2};...
        {100+66,   visStimN, LaserOn,olf1,olf2};...
        {100+80,  rand5, LaserOff,olf1,olf2};...
        {100+81,  visStimN, LaserOff,olf1,olf2};...
        {100+86,   visStimN, LaserOn,olf1,olf2};...
        {100+100,  rand6, LaserOff,olf1,olf2};...
        {100+101,  visStimN, LaserOff,olf1,olf2};...
        {100+106,   visStimN, LaserOn,olf1,olf2};...
        {100+120,  rand7, LaserOff,olf1,olf2};...
        {100+121,  visStimN, LaserOff,olf1,olf2};...
        {100+126,   visStimN, LaserOn,olf1,olf2};...
        {100+140,  rand8, LaserOff,olf1,olf2};...
        {100+141,  visStimN, LaserOff,olf1,olf2};...
        {100+146,   visStimN, LaserOn,olf1,olf2};...
        {100+160,  rand9, LaserOff,olf1,olf2};...
        {100+161,  visStimN, LaserOff,olf1,olf2};...
        {100+166,   visStimN, LaserOn,olf1,olf2};...
        {100+180,  rand10, LaserOff,olf1,olf2};...
        {100+181,  visStimN, LaserOff,olf1,olf2};...
        {100+186,   visStimN, LaserOn,olf1,olf2};...
        {100+200,  rand11, LaserOff,olf1,olf2};...
        {100+201,  visStimN, LaserOff,olf1,olf2};...
        {100+206,   visStimN, LaserOn,olf1,olf2};...
        {100+220,  rand12, LaserOff,olf1,olf2};...
        {100+221,  visStimN, LaserOff,olf1,olf2};...
        {100+226,   visStimN, LaserOn,olf1,olf2};...
        {100+240, visStim0, LaserOff,olf1,olf2};...
        
    ];

    