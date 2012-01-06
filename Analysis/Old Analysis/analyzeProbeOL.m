function analyzeProbeOL(file)

settings = tfSettings();

comment = '';

fileList = {file};

        
tOffset = -.2; % Timing offset
rateError = -.43; % Correction for DAQ clock
colorList = [[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v')];

for i=1:size(fileList,2)
  
    fileName = fileList{i};   
    load([settings.dataDir,fileName]);
    nSamples = size(data.LAmp,1);
    data.time = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
    [data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
    
    sampleBounds = round((histogramBounds - tOffset) .* (daqParams.SampleRate + rateError));
    numHist = size(histogramBounds,1);
    
    preStim = 2;
    postStim = 2;
    
    stimValues = [-360 -180 -90 -45 0 45 90 180 360];
    for subFig = 1:9
        subplot(6,2,subFig);       
        epochList = nonzeros(histogramBounds(subFig+1,:));
        numEpochs = size(epochList,1)/2;
        epochSamples = round((epochList - tOffset) .* (daqParams.SampleRate + rateError));
    
        for epoch = 1:numEpochs
            subplot(6,2,subFig);  
            stSamp = epochSamples(2*epoch - 1) ;
            endSamp   = epochSamples(2*epoch) ;
            sampList  = stSamp- round(preStim*(daqParams.SampleRate + rateError)):endSamp+ round(postStim*(daqParams.SampleRate + rateError));

            stBaselineWindowSamp = stSamp - round(2*(daqParams.SampleRate + rateError));
            endBaselineWindowSamp = stSamp;
            stMeasureWindowSamp = stSamp + round(.5*(daqParams.SampleRate + rateError));
            endMeasureWindowSamp = endSamp;
            baselineWindow = stBaselineWindowSamp:endBaselineWindowSamp;
            measureWindow = stMeasureWindowSamp:endMeasureWindowSamp;
            baselineTimes = data.time([baselineWindow(1) baselineWindow(end)])-data.time(stSamp);
            measureTimes = data.time([measureWindow(1) measureWindow(end)])-data.time(stSamp);

            
            baselineL = mean(data.LAmp(baselineWindow));
            baselineR = mean(data.RAmp(baselineWindow));
            baselineF = mean(data.Freq(baselineWindow));
            measureL = mean(data.LAmp(measureWindow));
            measureR = mean(data.RAmp(measureWindow));
            measureF = mean(data.Freq(measureWindow));
            
 
            baseL(subFig,epoch) = baselineL;
            baseR(subFig,epoch) = baselineR;
            baseF(subFig,epoch) = baselineF;
            measL(subFig,epoch) = measureL;
            measR(subFig,epoch) = measureR;
            measF(subFig,epoch) = measureF;
            
            timeSeries = data.time(sampList)-data.time(stSamp);
            xTrace = data.wrappedX(sampList);
            lTrace = data.LAmp(sampList);
            rTrace = data.RAmp(sampList);
            fTrace = data.Freq(sampList);
            
            hold on;
            plot(timeSeries,rTrace,'r'); 
            plot(timeSeries,lTrace,'b');
            plot(baselineTimes,[baselineL baselineL],'Color',[.8 .8 1]);
            plot(baselineTimes,[baselineR baselineR],'Color',[1 .8 .8]);
            plot(measureTimes,[measureL measureL],'Color',[.8 .8 1]);
            plot(measureTimes,[measureR measureR],'Color',[1 .8 .8]);
            xlim([-2 3]);
            ylim([0 400]);
            ylabel('WBA');
            title(stimValues(subFig));
            %ylim([0 360]);
            %set(gca,'YTick',[0 90 180 270 360],'TickDir','out');
            
            subplot(6,2,12);
            hold on;
            plot(timeSeries,fTrace,'Color',colorFader(subFig,11));
            xlim([-2 3]);
            ylabel('Freq (Hz)');
            title(fileName);
        end

    end    
end
  
figure();
numX = size(measL,1);
numReps = size(measL,2);
for stim = 1:numX
    for rep = 1:numReps
        subplot(3,2,1);
        hold on;    
        scatter(stimValues(stim),measL(stim,rep)-baseL(stim,rep),'b');
        scatter(stimValues(stim),measR(stim,rep)-baseR(stim,rep),'r');
        subplot(3,2,2);
        hold on;    
        scatter(stimValues(stim),baseL(stim,rep),'b');
        scatter(stimValues(stim),baseR(stim,rep),'r');
        subplot(3,2,3);
        hold on;    
        scatter(stimValues(stim),measL(stim,rep),'b');
        scatter(stimValues(stim),measR(stim,rep),'r');
        subplot(3,2,4);
        hold on;    
        scatter(stimValues(stim),measL(stim,rep)-measR(stim,rep),'g');
        scatter(stimValues(stim),(measL(stim,rep)-baseL(stim,rep))-(measR(stim,rep)-baseR(stim,rep)),'k');
        subplot(3,2,5);
        hold on;    
        scatter(stimValues(stim),measF(stim,rep),'g');
        scatter(stimValues(stim),baseF(stim,rep),'k');
        subplot(3,2,6);
        hold on;    
        scatter(stimValues(stim),measF(stim,rep)-baseF(stim,rep),'k');
    end
end

subplot(3,2,1);
title(fileName);
xlabel('Angular velocity (deg/sec)');
ylabel('WBA response over baseline');
line(xlim(),[0 0],'Color',[0 0 0]);
line([0 0],ylim(),'Color',[0 0 0]);
subplot(3,2,2);
xlabel('Angular velocity (deg/sec)');
ylabel('WBA baseline');
line([0 0],ylim(),'Color',[0 0 0]);
subplot(3,2,3);
xlabel('Angular velocity (deg/sec)');
ylabel('WBA response');
line([0 0],ylim(),'Color',[0 0 0]);
subplot(3,2,4);
xlabel('Angular velocity (deg/sec)');
ylabel('Green = WBA diff || Black = (WBA - baseline) diff');
line(xlim(),[0 0],'Color',[0 0 0]);
line([0 0],ylim(),'Color',[0 0 0]);
subplot(3,2,5);
xlabel('Angular velocity (deg/sec)');
ylabel('Measured (green) and Baseline (black) Frequency (Hz)');
line([0 0],ylim(),'Color',[0 0 0]);
subplot(3,2,6);
xlabel('Angular velocity (deg/sec)');
ylabel('Freq over baseline (Hz)');
line(xlim(),[0 0],'Color',[0 0 0]);
line([0 0],ylim(),'Color',[0 0 0]);

figure(1);
        set(gcf, 'Color', 'white');
        set(gcf, 'InvertHardcopy','off');
        set(gcf,'Units','pixels');
        scnsize = get(0,'ScreenSize');
        set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [11 8.5])
        set(gcf, 'PaperPosition', [0 0 11 8.5]);
        filenameOut = strrep(fileName,'.mat','a.pdf');
        print(gcf, '-dpdf',[settings.dataDir,filenameOut]);
 figure(2);
        set(gcf, 'Color', 'white');
        set(gcf, 'InvertHardcopy','off');
        set(gcf,'Units','pixels');
        scnsize = get(0,'ScreenSize');
        set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [11 8.5])
        set(gcf, 'PaperPosition', [0 0 11 8.5]);
        filenameOut = strrep(fileName,'.mat','b.pdf');
        print(gcf, '-dpdf',[settings.dataDir,filenameOut]);
 
        
        
   