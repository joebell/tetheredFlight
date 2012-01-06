function analyzeProbeOLBoxBatch()

settings = tfSettings();

comment = '';


fileList = {...
    
% % CL stripe -> OL box
    'RTTF111201-100350.mat',...
    'RTTF111201-111609.mat',...
    'RTTF111201-131413.mat',...
    'RTTF111201-142605.mat',...
    'RTTF111130-150114.mat',...
    'RTTF111130-135425.mat',...
    'RTTF111207-125402.mat',...
    'RTTF111207-160215.mat',...
    'RTTF111209-122706.mat',...
    'RTTF111209-134243.mat',...
    'RTTF111209-145648.mat',...
    'RTTF111209-162709.mat',...
    'RTTF111210-143748.mat',...
    'RTTF111213-104411.mat',...
    'RTTF111213-114631.mat',...
    'RTTF111213-134401.mat',...
    'RTTF111213-144541.mat',...
    
    
            };

% % CL stripe -> OL stripe
%     'RTTF111201-102025.mat',...
%     'RTTF111201-113225.mat',...
%     'RTTF111201-133143.mat',...
%     'RTTF111201-144537.mat',...
%     'RTTF111207-131114.mat',...
%     'RTTF111207-162037.mat',...
%             };

        
tOffset = -.2; % Timing offset
rateError = -.43; % Correction for DAQ clock
colorList = [[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v')];

figure(2);

nTraces = 0;
traces = [];


for i=1:size(fileList,2)
  
    fileName = fileList{i};   
    load([settings.dataDir,fileName]);
    nSamples = size(data.LAmp,1);
    data.time = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
    [data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
    
    sampleBounds = round((histogramBounds - tOffset) .* (daqParams.SampleRate + rateError));
    numHist = size(histogramBounds,1);
    
    preStim = 10;
    postStim = 5;

    stimValues = [-120 -60 0 60 120];
    for odorOn = 1:2;
        for subFig = 1:5
            subplot(6,2,sfa(6,2,subFig,odorOn));       
            epochList = nonzeros(histogramBounds(subFig+1+(odorOn-1)*7,:));
            numEpochs = size(epochList,1)/2;
            epochSamples = round((epochList - tOffset) .* (daqParams.SampleRate + rateError));
            for epoch = 1:numEpochs
                subplot(6,2,sfa(6,2,subFig,odorOn));  

                stSamp = epochSamples(2*epoch - 1) ;
                endSamp   = epochSamples(2*epoch) ;
                sampList  = stSamp- round(preStim*(daqParams.SampleRate + rateError)):endSamp+ round(postStim*(daqParams.SampleRate + rateError));

                timeSeries = data.time(sampList)-data.time(stSamp);
                xTrace = data.wrappedX(sampList);
                lTrace = data.LAmp(sampList);
                rTrace = data.RAmp(sampList);
                fTrace = data.Freq(sampList);

                hold on;

                %plot(timeSeries,rTrace,'r'); 
                %plot(timeSeries,lTrace,'b');
                %plot(timeSeries,lTrace-rTrace,'b');
                
                nTraces = nTraces + 1;
                traceIdx(nTraces,:) = [subFig,odorOn,i];
                traces = padcat(1, traces, (lTrace - rTrace)');
                
                    
                plot([timeSeries(1),timeSeries(end)],[0 0],'k');
                xlim([-4 14]);
                ylim([-250 250]);
                ylabel('WBA (cV)');   

                title(stimValues(subFig));
                %ylim([0 360]);
                %set(gca,'YTick',[0 90 180 270 360],'TickDir','out');
                title(stimValues(subFig));
            end

        end   
    end
end

disp(nTraces);

for odorOn = 1:2;
    for subFig = 1:5
        subplot(6,2,sfa(6,2,subFig,odorOn)); 
        idx = find((traceIdx(:,1) == subFig)&(traceIdx(:,2)==odorOn));
        meanDiff = mean(traces(idx,:),1);
        sigDiff = std(traces(idx,:),1)./sqrt(size(idx,2));
        time = data.time(1:size(meanDiff(:),1)) - data.time(1) - 10;
        hold on;
        h = area([time;time]',[(meanDiff-sigDiff);(2*sigDiff)]',-10000);
        set(h,'EdgeColor','none');
        set(h,'FaceColor','none');
        set(h(2),'FaceColor',[.8 .8 1]);
        plot(time,meanDiff,'b');
        
    end
end


% figure(2);
        set(gcf, 'Color', 'white');
        set(gcf, 'InvertHardcopy','off');
        set(gcf,'Units','pixels');
        scnsize = get(0,'ScreenSize');
        set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [11 8.5])
        set(gcf, 'PaperPosition', [0 0 11 8.5]);
        filenameOut = 'OLanalysis.pdf';
        print(gcf, '-dpdf',[settings.dataDir,filenameOut]);

 
        
        
   