% teleAnalyze3.m

function teleAnalyze3()

settings = tfSettings();

lockDuration = 1;
preOdor =  5;
preTest = 10;
interval = 25;

% comment = '3oct -2';
% fileList = { ...
%      ['RTTF110426-155538.mat'],...
%      ['RTTF110426-163042.mat'],...
%      ['RTTF110426-174900.mat'],...
%      ['RTTF110427-111324.mat'],...
%      ['RTTF110427-124600.mat'],...
%      ['RTTF110427-132618.mat'],... 
% };

comment = '3oct -1';
fileList = { ...
     ['RTTF110427-141706.mat'],... 
     ['RTTF110427-172619.mat'],...
};
        
tOffset = -.429; % Timing offset
rateError = -.43; % Correction for DAQ clock
colorList = ['k','g','b','g','b','y','c','b','m','k','r','g','y','c'];

teleFigure = figure();
traces1 = [];
traces2 = [];
traces3 = [];

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
    for subFig = 1:3
        subplot(3,1,subFig);
        hold on;
        histNum = (subFig-1)*3 + 1;
        traces = [];
        for j=1:2:numParts;
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
                    sinTrace = data.smoothX(sampList);
                end              
                plot(timeSeries,dataTrace);                               
                traces(end+1,:) = sinTrace;
            end
        end
        
        if subFig == 1
            traces1 = cat(1,traces1, traces);
        elseif subFig == 2
            traces2 = cat(1,traces2, traces);
        elseif subFig == 3
            traces3 = cat(1,traces3, traces);
        end

        ylim([0 360]);
        xlim([0 interval+1]);
        set(gca,'YTick',[0 90 180 270 360],'TickDir','out');
    end

end    

    for subFig = 1:3
        subplot(3,1,subFig);
        hold on;
        if subFig == 1
            traces = traces1;
        elseif subFig == 2;
            traces = traces2;
        elseif subFig == 3;
            traces = traces3;
        end
        avgSeries = (mean(-sind(traces))+1)*180;
        binarySeries = mean((sind(traces) < 0))*360;
        avgSeries = avgSeries(:);
        binarySeries = binarySeries(:);
        plot(timeSeries,avgSeries,'k','LineWidth',2);
        plot(timeSeries,binarySeries,'r','LineWidth',1.5); 
    end

    
    subplot(3,1,1);
    if size(fileList,2) == 1
    	preTitle = [comment, ' - ',fileName];
    else
        preTitle = ['Tele-Crunch - ',comment];
    end
    title({preTitle;'Pre-odor'});
    subplot(3,1,2);
    title('Odor only');
    X = [preOdor interval interval preOdor];
    Y = [180 180 360 360];
    fill(X, Y, [.7 .7 1],'EdgeColor','none','FaceAlpha',.5);            
    subplot(3,1,3);
    title('Odor + Laser');
    X = [preOdor interval interval preOdor];
    Y = [180 180 360 360];
    fill(X, Y, [.7 .7 1],'EdgeColor','none','FaceAlpha',.5);            
    X = [preTest interval interval preTest];
    Y = [180 180 360 360];
    fill(X, Y, [1 .7 .7],'EdgeColor','none','FaceAlpha',.5);            
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
            filenameOut = ['Crunch-',comment,'-Tele.pdf'];
        end
        print(gcf, '-dpdf',[settings.dataDir,filenameOut]);
    