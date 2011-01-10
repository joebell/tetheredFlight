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

    save(['../Data/',filename,'.mat'],'data', 'daqParams', 'trialStructureName','trialStructureList','histogramBounds','TimeRun');
    disp('... Finished trial.');
    disp(['Wrote: ','../Data/',filename,'.mat']);
    analyzeRTTF(['../Data/',filename,'.mat'],comment);

    disp('----------------------------------------------------------');
    disp(['WBA Diff Mean:    ', num2str(mean(data.LAmp - data.RAmp))]);
    disp(['WBA Diff Std Dev: ', num2str(std(data.LAmp - data.RAmp))]);
    disp('----------------------------------------------------------');