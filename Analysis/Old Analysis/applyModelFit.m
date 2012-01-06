function applyModelFit()

settings = tfSettings();

% Get the waveform from here
fileName = 'RTTF111201-100350.mat';
models   = 'DynModels-111215-1631.mat';

tOffset = -.2; % Timing offset
rateError = -.43; % Correction for DAQ clock
colorList = [[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v')];

load([settings.dataDir,models]);
noOdorModel = fitModels{2};
odorModel = fitModels{5};
load([settings.dataDir,fileName]);
nSamples = size(data.LAmp,1);
exptime = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
[data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
    
sampleBounds = round((histogramBounds - tOffset) .* (daqParams.SampleRate + rateError));
numHist = size(histogramBounds,1);
    preStim = 10;
    postStim = 5;

for subFig = 1:5
        
	subplot(5,2,sfa(5,2,subFig,1)); hold on;
    epochList = nonzeros(histogramBounds(subFig+1,:));
    numEpochs = size(epochList,1)/2;
    epochSamples = round((epochList - tOffset) .* (daqParams.SampleRate + rateError));
               
    stSamp = epochSamples(1) ;
    endSamp   = epochSamples(2) ;
    sampList  = stSamp- round(preStim*(daqParams.SampleRate + rateError)):endSamp+ round(postStim*(daqParams.SampleRate + rateError));
    
    smoothX = data.smoothX(sampList);
    time = exptime(1:size(smoothX(:),1)) - exptime(1) - 10; 
    onSamp = dsearchn(time',0);
    offSamp = dsearchn(time',10);
    smoothX = smoothX - round(mean(smoothX(onSamp:offSamp) - 45)/360)*360;
    smoothX(1:onSamp) = 90;
    smoothX(offSamp:end) = 90;
    
    noOdorSim = simulateModel(noOdorModel,smoothX);
%     noOdorSim = noOdorSim - noOdorSim(onSamp-400);
    odorSim = simulateModel(odorModel,smoothX);
%     odorSim = odorSim - odorSim(onSamp-400);
    
   
    subplot(5,2,sfa(5,2,subFig,1)); hold on;
    plot(time,noOdorSim);
%     plot(time,data.wrappedX(sampList));
%     ylim([0 360]);
     xlim([-5,15]);
    ylim([-150 150]);
    plot(xlim(),[0 0],'k');
    
    subplot(5,2,sfa(5,2,subFig,2)); hold on;
  plot(time,odorSim);
%    plot(time,smoothX);
 %    ylim([0 360]);
     xlim([-5,15]);
      ylim([-150 150]);
      plot(xlim(),[0 0],'k');

    disp(['Done ',num2str(subFig)]);
    pause(1);
end