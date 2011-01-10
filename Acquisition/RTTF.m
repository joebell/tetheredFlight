% Realtime tethered flight controller

function RTTF(trialStructureName, comment, recVideo) 

global analogIn;
global digitalIO;
global ardVar;
global USB;
global daqParams;


% Load the parameters onto the board
[USB, ardVar] = initializeArduino();
% Intitialize the DAQ
daqSettings();

% Setup the arduino
disp('Running a trial...');

% Invokes a trial structure
path('./Trial Structures/',path);
eval([trialStructureName,';']);

% Make timers for all the events in the trial structure
numEvents = size(trialStructureList,1) - 1; % Disregard first event
for event = 1:numEvents
    newState = trialStructureList(event + 1,:);
    preTimerArray(event) = timer('ExecutionMode','singleShot',...
        'StartDelay',newState{1} - .5 - daqParams.offsetTime,...
        'TimerFcn', {'preUpdateArduino', newState});
    timerArray(event) = timer('ExecutionMode','singleShot',...
        'StartDelay',newState{1} - daqParams.offsetTime,...
        'TimerFcn', {'changeState', newState});
end
wholeTime = newState{1}+1;
sampleRate = get(analogIn, 'SampleRate');
set(analogIn, 'SamplesPerTrigger',uint32(wholeTime*sampleRate));

preUpdateArduino(0,0,trialStructureList(1,:));   % Load the initial settings
ardFlip();                                       % Flip the initial settings
ardDispOn();                                     % Turn the display on

TimeRun = now;
time = datestr(TimeRun, 'yymmdd-HHMMSS');
filename = ['RTTF',time];

start(analogIn);
for event = 1:numEvents
    start(preTimerArray(event));
    start(timerArray(event));
end


waitTimer = timerArray(numEvents);
finishUpTimer = timer('ExecutionMode','singleShot',...
        'StartDelay',wholeTime,...
        'TimerFcn', {@finishUpRTTF, wholeTime, waitTimer, trialStructureName, trialStructureList,histogramBounds,TimeRun, filename, comment});

start(finishUpTimer);
    
% If the user passed a video object in, record the video.
if (~isempty(recVideo))
    recordVideo(recVideo,filename,timerArray(numEvents));
end   
  


%%
% This function catches the end of an RTTF to allow command line access
% during data acquisition
function finishUpRTTF(obj, event, wholeTime, waitTimer, trialStructureName, trialStructureList,histogramBounds,TimeRun, filename, comment)

global analogIn;
global digitalIO;
global ardVar;
global USB;
global daqParams;

    wait(analogIn,wholeTime+1);
    wait(waitTimer);

    ardDispOff();

    acquiredData = getdata(analogIn);

    data.LAmp  = acquiredData(:,1)*100;
    data.RAmp  = acquiredData(:,2)*100;
    data.Freq  = acquiredData(:,3)*100;
    data.Laser = acquiredData(:,4);
    data.Rcv   = acquiredData(:,5);
    data.X     = acquiredData(:,6);
    data.Odor  = acquiredData(:,7);

    settings = tfSettings();
    save([settings.dataDir,filename,'.mat'],'data', 'daqParams', 'trialStructureName','trialStructureList','histogramBounds','TimeRun');
    disp('... Finished trial.');
    disp(['Wrote: ',filename,'.mat']);
    analyzeRTTF([settings.dataDir,filename,'.mat'],comment);

    disp('----------------------------------------------------------');
    disp(['WBA Diff Mean:    ', num2str(mean(data.LAmp - data.RAmp))]);
    disp(['WBA Diff Std Dev: ', num2str(std(data.LAmp - data.RAmp))]);
    disp('----------------------------------------------------------');



















