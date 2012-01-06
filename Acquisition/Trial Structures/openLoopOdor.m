
% openLoopOdor.m

% Constants
global ts;

center = 0;
 
% Format: {time, visStim} 
%          [Mode, K0, K1, K2]
visStimN = [1, 0,  -4, center];
LaserOn  = '0000';
olf1 = '0000';
olf2 = '0000';
olf3 = '0000';
olfOff = '0000';
LaserOff = '0000';

nTrials = 30;
preRoll = 15;     % Seconds
odorLength = 2;   % Seconds
trialLength = 45; % Seconds

odorSequence = randperm(nTrials);
min = 60;

histogramBounds(1,:) = [5,2*min];
trialStructureList = [...
    {0,         visStimN, LaserOff, olfOff, olfOff, olfOff, 'ardSetBox(6,6,21);ardSetColors(0,4);'};...     %nb. First line is initial settingss
    {2*min,     visStimN, LaserOff, olfOff, olfOff, olfOff, ''}];

for epoch=1:nTrials

    % Determine when each height happens
    if (odorSequence(epoch) <= (nTrials/2))
        % Odor trial
        isOdor = true;
        olf1 = '0000';
        olf2 = 'ffff';
    else
        % EV trial
        isOdor = false;
        olf1 = 'ffff';
        olf2 = '0000';
    end
    
    trialStart= 2*min + (epoch-1)*trialLength;
    odorStart = 2*min + preRoll + (epoch-1)*trialLength;
    odorEnd   = 2*min + preRoll + odorLength + (epoch-1)*trialLength;
    trialEnd  = 2*min + epoch*trialLength;
    
    trialStructureList(3 + 3*(epoch-1),:) = {odorStart, ...
      visStimN, LaserOff, olf1, olf2, olfOff, ''};
    trialStructureList(4 + 3*(epoch-1),:) = {odorEnd, ...
      visStimN, LaserOff, olfOff, olfOff, olfOff, ''};
    trialStructureList(5 + 3*(epoch-1),:) = {trialEnd, ...
      visStimN, LaserOff, olfOff, olfOff, olfOff, ''};
        
    % Histogram time for box
    if isOdor
        histogramBounds(2,end+1:end+2) = [trialStart,odorStart];
        histogramBounds(3,end-1:end) = [odorEnd,trialEnd];
    else
        histogramBounds(4,end+1:end+2) = [trialStart,odorStart];
        histogramBounds(5,end-1:end) = [odorEnd,trialEnd];
    end
end

%disp(histogramBounds);


    