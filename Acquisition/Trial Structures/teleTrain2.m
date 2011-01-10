% teleTrain2

% Constants
global ts;

center = 0;
gain   = -1;

startTime = 10;
interval = 30;
lockDuration = 1;
preTest = 10;

visStimN = [1, 0, gain, center];
odor1Laser  = '003c';
odor2Laser  = '003c';
%odor1Laser  = '0000';
%odor2Laser  = '0000';

odor1On   = '3c00';
odor2On   = '003c';
laserOff = '0000';
odorOff  = '0000';

trialStructureList(1,:) = {0, visStimN, laserOff,odorOff,odorOff};     %nb. First line is initial settingss

% Teleport Only
for i=1:6

    randTime = startTime + (i-1)*interval;
    unlockTime = randTime + lockDuration;
    testTime = randTime + preTest;
    endTime  = randTime + interval;
    visStimLock = [0, rand(1)*360, 0, 0];
                                    %--Time------Visual-------Laser-----Odor1----Odor2--                                   
    trialStructureList(2+(i-1)*3,:) = {randTime,  visStimLock, laserOff, odorOff,odorOff};
    trialStructureList(3+(i-1)*3,:) = {unlockTime,   visStimN, laserOff, odorOff,odorOff};
    trialStructureList(4+(i-1)*3,:) = {testTime,     visStimN, laserOff, odorOff,odorOff};
   
%     % Histogram for Unlocking
%     histogramBounds(1, (2*i - 1)) = randTime;
%     histogramBounds(1, (2*i - 0)) = unlockTime;
%     % Histogram for pre-Test
%     histogramBounds(2, (2*i - 1)) = unlockTime;
%     histogramBounds(2, (2*i - 0)) = testTime;
    % Histogram during test
    histogramBounds(1, (2*i - 1)) = testTime;
    histogramBounds(1, (2*i - 0)) = endTime;
end

% Odor1
for i=7:18

    randTime = startTime + (i-1)*interval;
    unlockTime = randTime + lockDuration;
    testTime = randTime + preTest;
    endTime  = randTime + interval;
    visStimLock = [0, rand(1)*360, 0, 0];
                                    %--Time------Visual-------Laser-----Odor1----Odor2--                                   
    trialStructureList(2+(i-1)*3,:) = {randTime,  visStimLock, laserOff, odor1On,odor2On};
    trialStructureList(3+(i-1)*3,:) = {unlockTime,   visStimN, laserOff, odor1On,odor2On};
    trialStructureList(4+(i-1)*3,:) = {testTime,     visStimN, odor1Laser, odor1On,odor2On};
   
%     % Histogram for Unlocking
%     histogramBounds(1, (2*i - 1)) = randTime;
%     histogramBounds(1, (2*i - 0)) = unlockTime;
%     % Histogram for pre-Test
%     histogramBounds(2, (2*i - 1)) = unlockTime;
%     histogramBounds(2, (2*i - 0)) = testTime;
    % Histogram during test
    histogramBounds(2, (2*(i-6) - 1)) = testTime;
    histogramBounds(2, (2*(i-6) - 0)) = endTime;
end

% Odor2
for i=19:30

    randTime = startTime + (i-1)*interval;
    unlockTime = randTime + lockDuration;
    testTime = randTime + preTest;
    endTime  = randTime + interval;
    visStimLock = [0, rand(1)*360, 0, 0];
                                    %--Time------Visual-------Laser-----Odor1----Odor2--                                   
    trialStructureList(2+(i-1)*3,:) = {randTime,  visStimLock, laserOff, odor1On,odor2On};
    trialStructureList(3+(i-1)*3,:) = {unlockTime,   visStimN, laserOff, odor1On,odor2On};
    trialStructureList(4+(i-1)*3,:) = {testTime,     visStimN, odor2Laser, odor1On,odor2On};
   
%     % Histogram for Unlocking
%     histogramBounds(1, (2*i - 1)) = randTime;
%     histogramBounds(1, (2*i - 0)) = unlockTime;
%     % Histogram for pre-Test
%     histogramBounds(2, (2*i - 1)) = unlockTime;
%     histogramBounds(2, (2*i - 0)) = testTime;
    % Histogram during test
    histogramBounds(3, (2*(i-18) - 1)) = testTime;
    histogramBounds(3, (2*(i-18) - 0)) = endTime;
end

% Add last element
i = 31;
randTime = startTime + (i-1)*interval;
trialStructureList(2+(i-1)*3,:) = {randTime,  visStimN, laserOff, odorOff,odorOff};
    


    