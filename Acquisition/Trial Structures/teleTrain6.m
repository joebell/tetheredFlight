% teleTrain6

% Constants
global ts;

center = 0;
gain   = -3;

startTime = 10;

lockDuration = 1;
preOdor =  6;
preTest =  8;
interval = 12;
 
visStimN = [2,90,.7,0, 0, gain, center];
%visStimN = [1, 3, gain, center];

laserOnF  =  '003c';
laserOnR  =  'ffc3';

odor1OnF   = '0000';
odor2OnF   = '003c';
odor3OnF   = '0000';

odor1OnR   = '003c';
odor2OnR   = '0000';
odor3OnR   = '0000';

laserOff = '0000';
odorOff  = '0000';
colorsOff = 'ardSetColors(0,0);';
colorsOn =  'ardSetColors(0,4);';
latchStateSafe = 'ardSetLatchState(false,false,false,false);';
latchArmed = 'ardSetLatchArmed(''ffc3'');';
latchOff   = 'ardSetLatchArmed(''0000'');';

trialStructureList(1,:) = {0, visStimN, laserOff,odorOff,odorOff,odorOff,''};     %nb. First line is initial settingss

% Teleport Only
for i=1:6

    randTime = startTime + (i-1)*interval;
    unlockTime = randTime + lockDuration;
    odorTime   = randTime + preOdor;
    testTime   = randTime + preTest;
    endTime    = randTime + interval;
    startPosition = (randi(2)-1)*180 + 90;
    %visStimLock = [0, startPosition, 0, 0];
    %visStimLock = visStimN;
    visStimLock = [2,270,0,0, 0, gain, center];
    %visStimLock = [0, 90, 0, 0];
                                %--Time------Visual-------Laser-----Odor1----Odor2----Odor3                                   
    trialStructureList(2+(i-1)*4,:) = {randTime,  visStimLock, laserOff, odorOff,odorOff,odorOff,colorsOn};
    trialStructureList(3+(i-1)*4,:) = {unlockTime,   visStimN, laserOff, odorOff,odorOff,odorOff,colorsOn};
    trialStructureList(4+(i-1)*4,:) = {odorTime,     visStimN, laserOff, odorOff,odorOff,odorOff,''};
    trialStructureList(5+(i-1)*4,:) = {testTime,     visStimN, laserOff, odorOff,odorOff,odorOff,''};
   
    % Histogram during whole epoch
    histogramBounds(1, (2*i - 1)) = randTime;
    histogramBounds(1, (2*i - 0)) = endTime;
    % Histogram during odor
    histogramBounds(2, (2*i - 1)) = odorTime;
    histogramBounds(2, (2*i - 0)) = testTime;
    % Histogram during test
    histogramBounds(3, (2*i - 1)) = testTime;
    histogramBounds(3, (2*i - 0)) = endTime;
end

% Odor Only
for i=7:19

    randTime = startTime + (i-1)*interval;
    unlockTime = randTime + lockDuration;
    odorTime   = randTime + preOdor;
    testTime   = randTime + preTest;
    endTime    = randTime + interval;
    startPosition = (randi(2)-1)*180 + 90;
    %visStimLock = [0, startPosition, 0, 0];
    %visStimLock = visStimN;
    visStimLock = [2,270,0,0, 0, gain, center];
    %visStimLock = [0, 90, 0, 0];
    %--Time------Visual-------Laser-----Odor1----Odor2----Odor3                                   
    trialStructureList(2+(i-1)*4,:) = {randTime,  visStimLock, laserOff, odorOff,odorOff,odorOff,latchOff};
    trialStructureList(3+(i-1)*4,:) = {unlockTime,   visStimN, laserOff, odorOff,odorOff,odorOff,latchStateSafe};
    trialStructureList(4+(i-1)*4,:) = {odorTime,     visStimN, laserOff, odor1OnF,odor2OnF,odor3OnF,latchArmed};
    trialStructureList(5+(i-1)*4,:) = {testTime,     visStimN, laserOff, odor1OnF,odor2OnF,odor3OnF,''};
   
    % Histogram during whole epoch
    histogramBounds(4, (2*i - 1)) = randTime;
    histogramBounds(4, (2*i - 0)) = endTime;
    % Histogram during odor
    histogramBounds(5, (2*i - 1)) = odorTime;
    histogramBounds(5, (2*i - 0)) = testTime;
    % Histogram during test
    histogramBounds(6, (2*i - 1)) = testTime;
    histogramBounds(6, (2*i - 0)) = endTime;
end

% Odor + Laser
for i=20:92

    randTime = startTime + (i-1)*interval;
    unlockTime = randTime + lockDuration;
    odorTime   = randTime + preOdor;
    testTime   = randTime + preTest;
    endTime    = randTime + interval;
    startPosition = (randi(2)-1)*180 + 90;
    %visStimLock = [0, startPosition, 0, 0];
    %visStimLock = visStimN;
    visStimLock = [2,270,0,0, 0, gain, center];
    %visStimLock = [0, 90, 0, 0];
    
    % Either give an odor or no-odor trial
    if randi(2) > 1
        % Odor in front Trial
                                        %--Time------Visual-------Laser-----Odor1----Odor2----Odor3                                   
        trialStructureList(2+(i-1)*4,:) = {randTime,  visStimLock, laserOff, odorOff,odorOff,odorOff,latchOff};
        trialStructureList(3+(i-1)*4,:) = {unlockTime,   visStimN, laserOff, odorOff,odorOff,odorOff,latchStateSafe};
        trialStructureList(4+(i-1)*4,:) = {odorTime,     visStimN, laserOff, odor1OnF,odor2OnF,odor3OnF,latchArmed};
        trialStructureList(5+(i-1)*4,:) = {testTime,     visStimN, laserOnF,  odor1OnF,odor2OnF,odor3OnF,''};
   
        % Histogram during whole epoch
        histogramBounds(7, (2*i - 1)) = randTime;
        histogramBounds(7, (2*i - 0)) = endTime;
        % Histogram during odor
        histogramBounds(8, (2*i - 1)) = odorTime;
        histogramBounds(8, (2*i - 0)) = testTime;
        % Histogram during test
        histogramBounds(9, (2*i - 1)) = testTime;
        histogramBounds(9, (2*i - 0)) = endTime;
    else
        % No-Odor behind Trial
                                        %--Time------Visual-------Laser-----Odor1----Odor2----Odor3                                   
        trialStructureList(2+(i-1)*4,:) = {randTime,  visStimLock, laserOff, odorOff,odorOff,odorOff,latchOff};
        trialStructureList(3+(i-1)*4,:) = {unlockTime,   visStimN, laserOff, odorOff,odorOff,odorOff,latchStateSafe};
        trialStructureList(4+(i-1)*4,:) = {odorTime,     visStimN, laserOff, odor1OnR,odor2OnR,odor3OnR,latchArmed};
        trialStructureList(5+(i-1)*4,:) = {testTime,     visStimN, laserOff, odor1OnR,odor2OnR,odor3OnR,''};
   
        % Histogram during whole epoch
        histogramBounds(10, (2*i - 1)) = randTime;
        histogramBounds(10, (2*i - 0)) = endTime;
        % Histogram during odor
        histogramBounds(11, (2*i - 1)) = odorTime;
        histogramBounds(11, (2*i - 0)) = testTime;
        % Histogram during test
        histogramBounds(12, (2*i - 1)) = testTime;
        histogramBounds(12, (2*i - 0)) = endTime;
    end
end


% Add last element
i = 93;
randTime = startTime + (i-1)*interval;
trialStructureList(2+(i-1)*4,:) = {randTime,  visStimN, laserOff, odorOff,odorOff,odorOff,''};
    


    