function analyzeOpenLoopOdor()

settings = tfSettings();

comment = 'ACV-2';

fileList = { ...
  ['RTTF111128-170324.mat'],...

};

        
tOffset = -.4; % Timing offset
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
    
%     disp(histogramBounds);
%     disp('--');


    % Run though each epoch
    for epoch = 3:2:size(histogramBounds,2)
        if (histogramBounds(2,epoch) > 0)
            % Odor condition
            isOdor = true;
            startTime =  histogramBounds(2,epoch);
            odorTime  = histogramBounds(2,epoch+1);
            endTime = histogramBounds(3,epoch+1);
            subplot(2,1,1); hold on;
        elseif (histogramBounds(4,epoch) > 0)
            % EV condition
            isOdor = false;
            startTime =  histogramBounds(4,epoch);
            odorTime  = histogramBounds(4,epoch+1);
            endTime = histogramBounds(5,epoch+1);
            subplot(2,1,2); hold on;
        else
            disp('Error: Not Odor or EV!?!');
            return;
        end

        stSamp  = round((startTime - tOffset) .* (daqParams.SampleRate + rateError));
        odorSamp = round((odorTime - tOffset) .* (daqParams.SampleRate + rateError));
        endSamp = round((endTime - tOffset) .* (daqParams.SampleRate + rateError));
        sampList = stSamp:endSamp;
        timeSeries = data.time(sampList)-data.time(odorSamp);
        xTrace = data.wrappedX(sampList);
        lTrace = data.LAmp(sampList);
        rTrace = data.RAmp(sampList);
        fTrace = data.Freq(sampList);
        oTrace = data.Odor(sampList);

        plot(timeSeries,xTrace,'Color',[0 0 1]);
        plot(timeSeries,oTrace*10,'c');
        xlim([-15 45]);
        ylim([0 360]);
        set(gca,'YTick',[0 90 180 270 360],'TickDir','out');
    end

end

    if size(fileList,2) == 1
    	preTitle = [comment, ' - ',fileName];
    else
        preTitle = ['openLoopOdor - ',comment];
    end
    subplot(2,1,1);
    title({preTitle;'Odor'});
    xlim([-15 30]);
    subplot(2,1,2);
    title('EV');
    xlim([-15 30]);
    xlabel('Time (sec)');
    
    set(gcf, 'Color', 'white');
    set(gcf, 'InvertHardcopy','off');
    set(gcf,'Units','pixels');
    scnsize = get(0,'ScreenSize');
    set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [8.5 11])
    set(gcf, 'PaperPosition', [0 0 8.5 11]);
    
    if size(fileList,2) == 1
        filenameOut = strrep(fileName,'.mat','-OLO.pdf');
    else
        filenameOut = ['openLoopOdor-Crunch-',comment,'-1.pdf'];
    end
    print(gcf, '-dpdf',[settings.dataDir,filenameOut]);
 
 