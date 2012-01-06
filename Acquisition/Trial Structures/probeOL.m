
% probeOL.m

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

nPresentations = 3;
nStimuli = 9;
speedList = [-360 -180 -90 -45 0 45 90 180 360]; % Deg/sec
speedSequence = randperm(nStimuli);
olLength = 1;
intervalLength = 10;
for i = 1:(nPresentations-1);
    speedSequence = [speedSequence, randperm(nStimuli)];
end
min = 60;

histogramBounds(1,:) = [5,2*min];
trialStructureList = [...
    {0,         visStimN, LaserOff, olfOff, olfOff, olfOff, colorsOn};...     %nb. First line is initial settingss
    {2*min,     visStimN, LaserOff, olfOff, olfOff, olfOff, colorsOn}];


for epoch=1:(nPresentations*nStimuli)
    % Determine when each height happens
    speedN = speedSequence(epoch);
    speed = speedList(speedN);
    
    olStart = 2*min + intervalLength*epoch + olLength*(epoch-1);
    olEnd   = olStart + olLength;
    
    olCMD = [1, speed, 0, 0];
    
    trialStructureList(3 + 2*(epoch-1),:) = {olStart, ...
      olCMD, LaserOff, olfOff, olfOff, olfOff,  ''};
    trialStructureList(4 + 2*(epoch-1),:) = {olEnd, ...
      visStimN, LaserOff, olfOff, olfOff, olfOff,  ''};
    
    % Histogram time for OL
    histogramBounds(2+(speedN-1),(2*epoch-1):(2*epoch)) = [olStart,olEnd];

end

trialStructureList(5 + 2*(epoch-1),:) = {olEnd + 5, ...
      visStimN, LaserOff, olfOff, olfOff, olfOff,  colorsOn};



    