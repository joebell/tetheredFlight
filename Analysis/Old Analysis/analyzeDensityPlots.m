function analyzeDensityPlots()

settings = tfSettings();

comment = 'test fly box extent';

fileList = { ...
        ['RTTF110829-140455.mat'],...
        ['RTTF110829-144713.mat'],...
        ['RTTF110829-165851.mat'],...
        ['RTTF110829-174226.mat'],...
        ['RTTF110830-102220.mat'],...
        ['RTTF110830-125157.mat'],...
        ['RTTF110830-133359.mat'],...
        ['RTTF110830-143104.mat'],...
        ['RTTF110830-151435.mat'],...
        ['RTTF110831-094652.mat'],...
        ['RTTF110831-103012.mat'],...
};

        
tOffset = -.4; % Timing offset
rateError = -.43; % Correction for DAQ clock
colorList = [[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v')];


for i=1:size(fileList,2)
  
    fileName = fileList{i};   
    load([settings.dataDir,fileName]);
    nSamples = size(data.LAmp,1);
    data.time = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
    [data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
    
    sampleBounds = round((histogramBounds - tOffset) .* (daqParams.SampleRate + rateError));
    numHist = size(histogramBounds,1);
    
    for subFig = 1:8
    %for subFig = 5
        figure(subFig);
        subplot(2,1,1);
        %subplot(8,1,subFig);
        hold on;
        if subFig > 1
            histStN = 2+2*(subFig-2);
            histEndN = 3+2*(subFig-2);
            startTime = histogramBounds(histStN,1) - 5;
            histStartTime = histogramBounds(histStN,1);
            histEndTime = histogramBounds(histStN,2);
            endTime = histogramBounds(histEndN,2)  + 5;
        else
            startTime = histogramBounds(1,1)-5;
            histStartTime = histogramBounds(1,1);
            histEndTime = histogramBounds(1,2);
            endTime =   histogramBounds(1,2)+5;
        end

        stSamp  = round((startTime - tOffset) .* (daqParams.SampleRate + rateError));
        endSamp = round((endTime - tOffset) .* (daqParams.SampleRate + rateError));
        sampList = stSamp:endSamp;
        timeSeries = data.time(sampList)-data.time(stSamp)-5;
        xTrace = data.wrappedX(sampList);
               
        plot(timeSeries,xTrace,'Color',[0 0 1]);
        if exist('aN')
            clear N;
            N(:,:) = aN(subFig,:,:);
            N = N + hist3([xTrace',timeSeries'],[8,50]);
            aN(subFig,:,:) = N;
        else
            aN = zeros(8,8,50);
            [N,C] = hist3([xTrace',timeSeries'],[8,50]);
            aN(subFig,:,:) = N;
        end
        xlim([-5 4*60+10]);
        ylim([0 360]);
        set(gca,'YTick',[0 90 180 270 360],'TickDir','out');
    end

end    

  
    for subPlot = 1:8
        figure(subPlot);
        subplot(2,1,1);
        if size(fileList,2) == 1
            preTitle = [comment, ' - ',fileName];
        else
            preTitle = ['Flight-Density-Crunch - ',comment];
        end
        if subPlot == 1
            title({preTitle;'Vertical Bar'});
        else
            heightList = [2,6,8,12,16,20,24];
            title({preTitle;['Box extent: ',num2str(heightList(subPlot-1))]});
        end
    end
    
    
%     heightList = [2,4,6,8,10,12,14];
%     for heightN = 1:7
%         figure(heightN);
%         %title(['Box size: ',num2str(heightList(heightN))]);
%     end
    
    for subFig = 1:8
        figure(subFig);
        subplot(2,1,2);
        colormap(hot);
        clear N;
        N(:,:) = aN(subFig,:,:);
        N(9,51) = 0; % Add an extra row/column to get pcolor to plot them all
        pcolor(N);
        set(gca,'YTick',[],'TickDir','out');
        set(gca,'XTick',[],'TickDir','out');
        
        
        set(gcf, 'Color', 'white');
        set(gcf, 'InvertHardcopy','off');
        set(gcf,'Units','pixels');
        scnsize = get(0,'ScreenSize');
        set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [11 8.5])
        set(gcf, 'PaperPosition', [0 0 11 8.5]);
        
        if size(fileList,2) == 1
            filenameOut = strrep(fileName,'.mat','-DensityPlots.pdf');
        else
            filenameOut = ['Density-Plots-',comment,'-',num2str(subFig),'.pdf'];
        end
        print(gcf, '-dpdf',[settings.dataDir,filenameOut]);
        
        
    end
    
