% teleAnalyze9wide.m

function teleAnalyze9wide()

settings = tfSettings();

lockDuration = 1;
preOdor =  6;
preTest = 7;
interval = 12;

comment = 'MeS @ -2, 1 sec delay';

fileList = { ...
    %['RTTF110427-141706.mat'],...
    ['RTTF110728-153857.mat'],...
};

        
tOffset = -.4; % Timing offset
rateError = -.43; % Correction for DAQ clock
colorList = ['k','g','b','g','b','y','c','b','m','k','r','g','y','c'];

teleFigure = figure();
traces1 = [];
traces2 = [];
traces3 = [];
traces4 = [];
traces5 = [];

for i=1:size(fileList,2)
       
    fileName = fileList{i};
    
    load([settings.dataDir,fileName]);
    nSamples = size(data.LAmp,1);
    data.time = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
    [data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
    
    sampleBounds = round((histogramBounds - tOffset) .* (daqParams.SampleRate + rateError));
    numHist = size(histogramBounds,1);
    numParts = size(histogramBounds,2);
    
    figure(teleFigure);
    for subFig = 3:5
        subplot(6,1,subFig*2-4);
        hold on;
        histNum = (subFig-1)*3 + 1;
        traces = [];       
        for j=1:2:numParts;
            subplot(6,1,subFig*2-4);
            hold on;
            if histogramBounds(histNum,j) > 0
                stSamp  = sampleBounds(histNum,j);
                if (size(traces,1) == 0)
                    endSamp = sampleBounds(histNum,j+1)+round(daqParams.SampleRate + rateError);
                    timeSeries = data.time(stSamp:endSamp)-data.time(stSamp);
                else
                    endSamp = stSamp + size(traces,2) - 1;
                end
                if endSamp > size(data.wrappedX,2)
                    sampList = stSamp:endSamp;
                    dataTrace = zeros(1,endSamp - stSamp + 1);
                    sinTrace = zeros(1,endSamp - stSamp + 1);
                    nendSamp = size(data.wrappedX,2);
                    nsampList = stSamp:nendSamp;
                    dataTrace(1:size(nsampList,2)) = data.wrappedX(nsampList);
                    sinTrace(1:size(nsampList,2)) = data.smoothX(nsampList);
                else
                    dataTrace = [];
                    sinTrace = [];
                    sampList = stSamp:endSamp;
                    dataTrace = data.wrappedX(sampList);
                    odorTrace = data.Odor(sampList)-data.Odor(sampList-1);
                    sinTrace = data.smoothX(sampList);
                end              
                plot(timeSeries,dataTrace,'Color',[.5 .5 .7]);
                %plot(timeSeries,odorTrace*15+180,'k');
                offInd = find(odorTrace < -1);
                if ~isempty(offInd)
                    timeTick = timeSeries(offInd(1));
                    yPos = [540 510] - size(traces,1)*6;
                    line([timeTick timeTick],yPos,'Color','r');
                end
                traces(end+1,:) = sinTrace;
                subplot(6,1,subFig*2-5);
                hold on;
                if (sampList(end) < size(data.Freq,1));
                    plot(timeSeries,smooth(data.Freq(sampList),10));
                end
                subplot(6,1,subFig*2-4);
            end
        end
        
        if subFig == 1
            traces1 = cat(1,traces1, traces);
        elseif subFig == 2
            traces2 = cat(1,traces2, traces);
        elseif subFig == 3
            traces3 = cat(1,traces3, traces);
        elseif subFig == 4
            traces4 = cat(1,traces4, traces);   
        elseif subFig == 5
            traces5 = cat(1,traces5, traces); 
        end
        
        subplot(6,1,subFig*2-5);
        xlim([0 interval+1]);
        ylim([150 260]);
        ylabel('Freq. (Hz)');
        subplot(6,1,subFig*2-4);
        ylim([0 540]);
        xlim([0 interval+1]);
        set(gca,'YTick',[0 90 180 270 360],'TickDir','out');
    end

end    

    for subFig = 3:5
        subplot(6,1,subFig*2-4);
        hold on;
        if subFig == 1
            traces = traces1;
        elseif subFig == 2;
            traces = traces2;
        elseif subFig == 3;
            traces = traces3;
        elseif subFig == 4;
            traces = traces4;   
        elseif subFig == 5;
            traces = traces5;  
        end
        avgSeries = (mean(-sind(traces))+1)*180;
        binarySeries = mean((sind(traces) < 0))*360;
        avgSeries = avgSeries(:);
        binarySeries = binarySeries(:);
        % Trim out extra samples
        if size(timeSeries,2) > size(avgSeries,1)
            timeSeries = timeSeries(1:size(avgSeries,1));
        end
        if size(avgSeries,1) > size(timeSeries,2)
            avgSeries = avgSeries(1:size(timeSeries,2));
        end
        if size(timeSeries,2) > size(binarySeries,1)
            timeSeries = timeSeries(1:size(binarySeries,1));
        end
        if size(binarySeries,1) > size(timeSeries,2)
            binarySeries = binarySeries(1:size(timeSeries,2));
        end
        plot(timeSeries,avgSeries,'k','LineWidth',2);
        plot(timeSeries,binarySeries,'r','LineWidth',1.5); 
    end

    
    subplot(6,1,2);
    if size(fileList,2) == 1
    	preTitle = [comment, ' - ',fileName];
    else
        preTitle = ['Tele9-Crunch - ',comment];
    end
    title({preTitle;'Pre-odor'});
%     subplot(2,1,2);
%     title('Odor only');
%     X = [preOdor interval interval preOdor];
%     Y = [0 0 180 180];
%     fill(X, Y, [.5 .5 1],'EdgeColor','none','FaceAlpha',.5);            
%     subplot(2,1,1);
%     title('Odor + Laser');
    X = [preOdor interval interval preOdor];
    Y = [0 0 180 180];
    fill(X, Y, [.5 .5 1],'EdgeColor','none','FaceAlpha',.5);            
    X = [preTest interval interval preTest];
    Y = [0 0 180 180];
    fill(X, Y, [1 .5 .5],'EdgeColor','none','FaceAlpha',.5);            
    xlabel('Time (sec)');
    subplot(6,1,4);
    title('Empty Vial only');
    X = [preOdor interval interval preOdor];
    Y = [0 0 180 180];
    fill(X, Y, [.5 1 .5],'EdgeColor','none','FaceAlpha',.5);
    subplot(6,1,6);
    title('Odor only');
    X = [preOdor interval interval preOdor];
    Y = [0 0 180 180];
    fill(X, Y, [.5 .5 1],'EdgeColor','none','FaceAlpha',.5);
%     X = [preTest interval interval preTest];
%     Y = [0 0 45 45];
%     fill(X, Y, [1 .5 .5],'EdgeColor','none','FaceAlpha',.5);            
%     Y = [135 135 360 360];
%     fill(X, Y, [1 .5 .5],'EdgeColor','none','FaceAlpha',.5);                
    xlabel('Time (sec)');
    
        set(gcf, 'Color', 'white');
        set(gcf, 'InvertHardcopy','off');
        set(gcf,'Units','pixels');
        scnsize = get(0,'ScreenSize');
        set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [11 8.5])
        set(gcf, 'PaperPosition', [0 0 11 8.5]);
        
        if size(fileList,2) == 1
            filenameOut = strrep(fileName,'.mat','-Tele.pdf');
        else
            filenameOut = ['Crunch-',comment,'-Tele5.pdf'];
        end
        print(gcf, '-dpdf',[settings.dataDir,filenameOut]);
    
