% batchAnimateData

directory = '../Data/Apr21/';
fileStem  = 'RTTF100421-';

fileList = dir([directory,fileStem,'*.mat']);

% for file=1:3
%     
%     load([directory, fileList(file).name]);
%     nSamples = size(data.LAmp,1);
%     endTime = floor(nSamples / daqParams.SampleRate);
%     
%     plotFcn = @grating;
%     animateData([directory,fileList(file).name],1, endTime, plotFcn);
%     
%     close all;
%     clear global;
% end
for file=4:6
    
    load([directory, fileList(file).name]);
    nSamples = size(data.LAmp,1);
    endTime = floor(nSamples / daqParams.SampleRate);
    
    plotFcn = @eightStripe;
    animateData([directory,fileList(file).name],1, endTime, plotFcn);
    
    close all;
    clear global;
end
for file=7:8
    
    load([directory, fileList(file).name]);
    nSamples = size(data.LAmp,1);
    endTime = floor(nSamples / daqParams.SampleRate);
    
    plotFcn = @sixStripe;
    animateData([directory,fileList(file).name],1, endTime, plotFcn);
    
    close all;
    clear global;
end
for file=9:9
    
    load([directory, fileList(file).name]);
    nSamples = size(data.LAmp,1);
    endTime = floor(nSamples / daqParams.SampleRate);
    
    plotFcn = @singleBox;
    animateData([directory,fileList(file).name],1, endTime, plotFcn);
    
    close all;
    clear global;
end

for file=10:12
    
    load([directory, fileList(file).name]);
    nSamples = size(data.LAmp,1);
    endTime = floor(nSamples / daqParams.SampleRate);
    
    plotFcn = @dualTallBox;
    animateData([directory,fileList(file).name],1, endTime, plotFcn);
    
    close all;
    clear global;
end

for file=13:17
    
    load([directory, fileList(file).name]);
    nSamples = size(data.LAmp,1);
    endTime = floor(nSamples / daqParams.SampleRate);
    
    plotFcn = @singleBox;
    animateData([directory,fileList(file).name],1, endTime, plotFcn);
    
    close all;
    clear global;
end
for file=18:56
    
    load([directory, fileList(file).name]);
    nSamples = size(data.LAmp,1);
    endTime = floor(nSamples / daqParams.SampleRate);
    
    plotFcn = @dualBox;
    animateData([directory,fileList(file).name],1, endTime, plotFcn);
    
    close all;
    clear global;
end
