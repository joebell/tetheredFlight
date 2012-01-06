
% probeBoxHeight.m

% Constants
global ts;

center = 0;
 
% Format: {time, visStim} 
%          [Mode, K0, K1, K2]
visStimN = [1, 0,  -2, center];
LaserOn  = '0000';
olf1 = '0000';
olf2 = '0000';
olf3 = '0000';
olfOff = '0000';
LaserOff = '0000';
colorsOff = 'ardSetColors(0,0);';
colorsOn =  'ardSetColors(0,4);';

heightList = [1,5,9,13,17,21,25];
heightSequence = randperm(7);
min = 60;

histogramBounds(1,:) = [5,4*min];
trialStructureList = [...
    {0,         visStimN,           LaserOff, olfOff, olfOff, olfOff, ['ardSetBox(8,32,1);',colorsOn]};...     %nb. First line is initial settingss
    {4*min,     [0,randi(360),0,0], LaserOff, olfOff, olfOff, olfOff, colorsOff}];


for epoch=1:7
    % Determine when each height happens
    heightN = heightSequence(epoch);
    height = heightList(heightN);
    boxStart = 4*min + 5 + (4*min+10)*(epoch-1);
    boxEnd   = boxStart + 2*min;
    stripeStart = boxEnd + 5;
    stripeEnd   = stripeStart + 2*min;
    
    boxSet = ['ardSetBox(8,8,',num2str(height),');',colorsOn];
    stripeSet = ['ardSetBox(8,32,1);',colorsOn];
    
    trialStructureList(3 + 4*(epoch-1),:) = {boxStart, ...
      visStimN, LaserOff, olfOff, olfOff, olfOff,  boxSet};
    trialStructureList(4 + 4*(epoch-1),:) = {boxEnd, ...
      [0,randi(360),0,0], LaserOff, olfOff, olfOff, olfOff,  colorsOff};
    trialStructureList(5 + 4*(epoch-1),:) = {stripeStart, ...
      visStimN, LaserOff, olfOff, olfOff, olfOff,  stripeSet};
    trialStructureList(6 + 4*(epoch-1),:) = {stripeEnd, ...
      [0,randi(360),0,0], LaserOff, olfOff, olfOff, olfOff,  colorsOff};
    
    % Histogram time for box
    histogramBounds(2+2*(heightN-1),:) = [boxStart,boxEnd];
    % Histogram time for stripe after box
    histogramBounds(3+2*(heightN-1),:) = [stripeStart,stripeEnd];
end

trialStructureList(7 + 4*(7-1),:) = {stripeEnd + 5, ...
      visStimN, LaserOff, olfOff, olfOff, olfOff,  colorsOn};



    