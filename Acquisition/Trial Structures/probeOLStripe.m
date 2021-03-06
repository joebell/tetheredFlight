
% probeOLStripe.m

% Constants
global ts;

center = 0;
 
% Format: {time, visStim} 
%          [Mode, K0, K1, K2]
visStimN = [1, 0,  -6, center];
%boxOn = 'ardSetBox(6,6,14);';
boxOn = 'ardSetBox(4,32,1);';
stripeOn = 'ardSetBox(4,32,1);';
interStripe = boxOn;
LaserOn  = '0000';
olf1 = 'ffff';
olf2 = 'ffff';
olf3 = '0000';
olfOff = '0000';
LaserOff = '0000';
colorsOff = 'ardSetColors(0,0);';
colorsOn =  'ardSetColors(0,4);';

nPresentations = 3;
nStimuli = 5;
angleList = [330 30 90 150 210]; % Degrees
angleSequence = randperm(nStimuli);
olLength = 10;
intervalLength = 10;  % Before OL
for i = 1:(nPresentations-1);
    angleSequence = [angleSequence, randperm(nStimuli)];
end
min = 60;

% First do 2 min of stripe fixation
histogramBounds(1,:) = [5,2*min];
trialStructureList = [...
    {0,         visStimN, LaserOff, olfOff, olfOff, olfOff, [colorsOn,stripeOn]};...     %nb. First line is initial settingss
    {2*min,     visStimN, LaserOff, olfOff, olfOff, olfOff, interStripe}];

% Second do no odor epochs
nConditions = nPresentations*nStimuli;
for epoch=1:nConditions
    % Determine when each height happens
    angleN = angleSequence(epoch);
    angle = angleList(angleN);
    
    olStart = 2*min + intervalLength*epoch + olLength*(epoch-1);
    olEnd   = olStart + olLength;
    
    % Oscillate with 22.5 deg magnitude at 1 Hz
    % Oscillations always start counter-clockwise
    olCMD = [2,angle,3.75*3,1];
    
    trialStructureList(3 + 2*(epoch-1),:) = {olStart, ...
      olCMD, LaserOff, olfOff, olfOff, olfOff, boxOn};
    trialStructureList(4 + 2*(epoch-1),:) = {olEnd, ...
      visStimN, LaserOff, olfOff, olfOff, olfOff, interStripe};
    
    % Histogram time for OL
    histogramBounds(2+(angleN-1),(2*epoch-1):(2*epoch)) = [olStart,olEnd];

end

% Replace last stripe with box
clStart = 2*min + (intervalLength + olLength)*nConditions;
trialStructureList(3 + 2*nConditions - 1,:) = {clStart, ...
      visStimN, LaserOff, olf1, olfOff, olfOff, boxOn};
% Turn odor on  
trialStructureList(3 + 2*nConditions,:) = {clStart + 2*min, ...
      visStimN, LaserOff, olfOff, olf2, olfOff, boxOn};
% Add odor-off to histogram  
histogramBounds(2+nStimuli,1:2) = [clStart,clStart + 2*min]; 
% Turn stripe back on  
trialStructureList(4 + 2*nConditions,:) = {clStart + 4*min, ...
      visStimN, LaserOff, olfOff, olfOff, olfOff, interStripe};
% Add odor-on to histogram  
histogramBounds(3+nStimuli,1:2) = [clStart + 2*min,clStart + 4*min]; 
  
% Now do odor epochs
batch2EpochStart = clStart + 4*min;
nConditions = nPresentations*nStimuli;
for epoch=1:nConditions
    % Determine when each height happens
    angleN = angleSequence(epoch);
    angle = angleList(angleN);
    
    olStart = batch2EpochStart + intervalLength*epoch + olLength*(epoch-1);
    olEnd   = olStart + olLength;
    
    % Oscillate with 22.5 deg magnitude at 1 Hz
    % Oscillations always start counter-clockwise
    olCMD = [2,angle,3.75*3,1];
    
    trialStructureList(5 + 2*nConditions + 2*(epoch-1),:) = {olStart, ...
      olCMD, LaserOff, olfOff, olf2, olfOff, boxOn};
    trialStructureList(6 + 2*nConditions + 2*(epoch-1),:) = {olEnd, ...
      visStimN, LaserOff, olfOff, olfOff, olfOff, interStripe};
    
    % Histogram time for OL
    histogramBounds(4+nStimuli+(angleN-1),(2*epoch-1):(2*epoch)) = [olStart,olEnd];

end

trialStructureList(7 + 2*nConditions + 2*(epoch-1),:) = {olEnd + 5, ...
      visStimN, LaserOff, olfOff, olfOff, olfOff, stripeOn};



    