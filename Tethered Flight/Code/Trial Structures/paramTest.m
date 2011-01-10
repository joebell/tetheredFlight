% trialStructure.m

% Constants
global ts;


% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStim0 = [0, 45, 0, 0];
visStimR = [1, 90, 0 ,0];
laserOn = '0000';
laserOff = '0000';
olf1 = 'ffff';
olf2 = 'ffff';
olfOff = '0000';

histogramBounds = [1 , 20; 20 , 40];

trialStructureList = [...
        {0,   [1, 90, 0, 0],laserOn,olf1, olf2};...     %nb. First line is initial settingss
        {40,  [1, 90, 0, 0],laserOff,olfOff, olfOff};... 
      

    ];

    