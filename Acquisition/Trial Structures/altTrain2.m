% teleTrain2

% Constants
global ts;

center = 0;
gain   = -1;

startTime = 10;
interval = 30;
lockDuration = 1;
preTest = 16;

visStimN = [1, 0, gain, center];
odor1Laser  = '0000';
odor2Laser  = '0000';

odorOn   = 'ff00';
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
   
    histogramBounds(1, (2*i - 1)) = testTime;
    histogramBounds(1, (2*i - 0)) = endTime;
end

% Odor1
for i=7:2:30

    % Odor 1
    randTime = startTime + (i-1)*interval;
    unlockTime = randTime + lockDuration;
    testTime = randTime + preTest;
    endTime  = randTime + interval;
    visStimLock = [0, rand(1)*360, 0, 0];
                                    %--Time------Visual-------Laser-----Odor1----Odor2--                                   
    trialStructureList(2+(i-1)*3,:) = {randTime,  visStimLock, laserOff, odorOn,odorOff};
    trialStructureList(3+(i-1)*3,:) = {unlockTime,   visStimN, laserOff, odorOn,odorOff};
    trialStructureList(4+(i-1)*3,:) = {testTime,     visStimN, odor1Laser, odorOn,odorOff};
    
    histogramBounds(2, (2*(i-6) - 1)) = testTime;
    histogramBounds(2, (2*(i-6) - 0)) = endTime;
    
    j = i + 1;
    
    % Odor 2
    randTime = startTime + (j-1)*interval;
    unlockTime = randTime + lockDuration;
    testTime = randTime + preTest;
    endTime  = randTime + interval;
    visStimLock = [0, rand(1)*360, 0, 0];
                                    %--Time------Visual-------Laser-----Odor1----Odor2--                                   
    trialStructureList(2+(j-1)*3,:) = {randTime,  visStimLock, laserOff, odorOff,odorOn};
    trialStructureList(3+(j-1)*3,:) = {unlockTime,   visStimN, laserOff, odorOff,odorOn};
    trialStructureList(4+(j-1)*3,:) = {testTime,     visStimN, odor2Laser, odorOff,odorOn};
   
    histogramBounds(3, (2*(j-6) - 1)) = testTime;
    histogramBounds(3, (2*(j-6) - 0)) = endTime;
   

end


% Add last element
i = 31;
randTime = startTime + (i-1)*interval;
trialStructureList(2+(i-1)*3,:) = {randTime,  visStimLock, laserOff, odorOff,odorOff};
    


    