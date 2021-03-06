% teleTrain3

% Constants
global ts;

center = 0;
gain   = -3;

startTime = 10;

lockDuration = 1;
preOdor =  5;
preTest = 10;
interval = 25;

visStimN = [1, 0, gain, center];

laserOn  =  'ff00';
odor1On   = '0000';
odor2On   = 'ff00';
odor3On   = '0000';
laserOff = '0000';
odorOff  = '0000';
colorsOff = 'ardSetColors(0,0);';
colorsOn =  'ardSetColors(0,4);';

trialStructureList(1,:) = {0, visStimN, laserOff,odorOff,odorOff,odorOff,''};     %nb. First line is initial settingss

% Teleport Only
for i=1:6

    randTime = startTime + (i-1)*interval;
    unlockTime = randTime + lockDuration;
    odorTime   = randTime + preOdor;
    testTime   = randTime + preTest;
    endTime    = randTime + interval;
    startPosition = (randi(2)-1)*180 + 90;
    visStimLock = [0, startPosition, 0, 0];
                                    %--Time------Visual-------Laser-----Odor1----Odor2----Odor3                                   
    trialStructureList(2+(i-1)*4,:) = {randTime,  visStimLock, laserOff, odorOff,odorOff,odorOff,colorsOff};
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
    visStimLock = [0, startPosition, 0, 0];
                                    %--Time------Visual-------Laser-----Odor1----Odor2----Odor3                                   
    trialStructureList(2+(i-1)*4,:) = {randTime,  visStimLock, laserOff, odorOff,odorOff,odorOff,colorsOff};
    trialStructureList(3+(i-1)*4,:) = {unlockTime,   visStimN, laserOff, odorOff,odorOff,odorOff,colorsOn};
    trialStructureList(4+(i-1)*4,:) = {odorTime,     visStimN, laserOff, odor1On,odor2On,odor3On,''};
    trialStructureList(5+(i-1)*4,:) = {testTime,     visStimN, laserOff, odor1On,odor2On,odor3On,''};
   
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
for i=20:56

    randTime = startTime + (i-1)*interval;
    unlockTime = randTime + lockDuration;
    odorTime   = randTime + preOdor;
    testTime   = randTime + preTest;
    endTime    = randTime + interval;
    startPosition = (randi(2)-1)*180 + 90;
    visStimLock = [0, startPosition, 0, 0];
                                    %--Time------Visual-------Laser-----Odor1----Odor2----Odor3                                   
    trialStructureList(2+(i-1)*4,:) = {randTime,  visStimLock, laserOff, odorOff,odorOff,odorOff,colorsOff};
    trialStructureList(3+(i-1)*4,:) = {unlockTime,   visStimN, laserOff, odorOff,odorOff,odorOff,colorsOn};
    trialStructureList(4+(i-1)*4,:) = {odorTime,     visStimN, laserOff, odor1On,odor2On,odor3On,''};
    trialStructureList(5+(i-1)*4,:) = {testTime,     visStimN, laserOn,  odor1On,odor2On,odor3On,''};
   
    % Histogram during whole epoch
    histogramBounds(7, (2*i - 1)) = randTime;
    histogramBounds(7, (2*i - 0)) = endTime;
    % Histogram during odor
    histogramBounds(8, (2*i - 1)) = odorTime;
    histogramBounds(8, (2*i - 0)) = testTime;
    % Histogram during test
    histogramBounds(9, (2*i - 1)) = testTime;
    histogramBounds(9, (2*i - 0)) = endTime;
end


% Add last element
i = 57;
randTime = startTime + (i-1)*interval;
trialStructureList(2+(i-1)*4,:) = {randTime,  visStimN, laserOff, odorOff,odorOff,odorOff,''};
    


    