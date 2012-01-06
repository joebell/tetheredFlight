function analyzeProbeBoxContrast()

settings = tfSettings();

comment = 'test fly 8x8 box contrast';

fileList = { ...
        ['RTTF110818-151727.mat'],...
        ['RTTF110818-160411.mat'],...
        ['RTTF110818-163853.mat'],...
        ['RTTF110819-095807.mat'],...
        ['RTTF110819-105055.mat'],...
        ['RTTF110819-114634.mat'],...
        ['RTTF110819-133203.mat'],...
        ['RTTF110819-142048.mat'],...
        ['RTTF110822-141122.mat'],...
        ['RTTF110822-153705.mat'],...
        ['RTTF110822-164126.mat'],...
        ['RTTF110822-172629.mat'],...
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
    for subFig = 1:8
        subplot(8,1,subFig);
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
        histStSamp = round((histStartTime - tOffset) .* (daqParams.SampleRate + rateError));
        histEndSamp = round((histEndTime - tOffset) .* (daqParams.SampleRate + rateError));
        sampList = stSamp:endSamp;
        histSampList = histStSamp:histEndSamp;
        timeSeries = data.time(sampList)-data.time(stSamp)-5;
        xTrace = data.wrappedX(sampList);
        lTrace = data.LAmp(sampList);
        rTrace = data.RAmp(sampList);
        fTrace = data.Freq(sampList);
        
        LplusRmean{i,subFig} = mean(data.LAmp(histSampList) ...
            + data.RAmp(histSampList));
        LplusRvar{i,subFig} = var(data.LAmp(histSampList) ...
            + data.RAmp(histSampList));
        LminusRmean{i,subFig} = mean(data.LAmp(histSampList) ...
            - data.RAmp(histSampList));
        LminusRvar{i,subFig} = var(data.LAmp(histSampList) ...
            - data.RAmp(histSampList));
        Freqmean{i,subFig} = mean(data.Freq(histSampList));
        Freqvar{i,subFig} = var(data.Freq(histSampList));
        SinXmean{i,subFig} = nanmean(sin(data.wrappedX(histSampList)*2*pi/360));
        SinXvar{i,subFig} = nanvar(sin(data.wrappedX(histSampList)*2*pi/360));
        forwardSamples  = size(find(sin(data.wrappedX(histSampList)*2*pi/360) > 0),2);
        backwardSamples = size(find(sin(data.wrappedX(histSampList)*2*pi/360) <= 0),2);
        PI{i,subFig} = (forwardSamples - backwardSamples)/(forwardSamples + backwardSamples);
        
%         windowSizes = [201,501,1001,2001,5001,10001];
%         %windowSizes = [21,51,101,201,501,1001];
%         for windowN = 1:6
%             %disp(windowN);
%             xList = cos(data.wrappedX(histSampList)*2*pi/360);
%             yList = sin(data.wrappedX(histSampList)*2*pi/360);
%         	xSmooth = smooth(xList,windowSizes(windowN),'moving');
%             ySmooth = smooth(yList,windowSizes(windowN),'moving');
%             magnitude = sqrt(xSmooth.*xSmooth + ySmooth.*ySmooth);
%             straightLine(windowN) = mean(magnitude);
%         end
%         Straightness{i,subFig} = straightLine;
        
%         % Calculate FFT's of X
%         Fs = 1000;
%         dataTrace = smooth(data.wrappedX(histSampList)*2*pi/360,3,'moving');
%         L = size(dataTrace,1);
%         NFFT = 2^nextpow2(L); % Next power of 2 from length of        
%         aFFT = fft(dataTrace,NFFT)/L;
%         aFourier.ampl = 2*abs(aFFT(1:NFFT/2+1));
%         aFourier.freq = Fs/2*linspace(0,1,NFFT/2+1);
%         Fourier{i,subFig} = aFourier;
%         
%         % Calculate FFT's of sin(X)
%         Fs = 1000;
%         dataTrace = smooth(sin(data.wrappedX(histSampList)*2*pi/360),3,'moving');
%         L = size(dataTrace,1);
%         NFFT = 2^nextpow2(L); % Next power of 2 from length of        
%         aFFT = fft(dataTrace,NFFT)/L;
%         aFourier.ampl = 2*abs(aFFT(1:NFFT/2+1));
%         aFourier.freq = Fs/2*linspace(0,1,NFFT/2+1);
%         SinFourier{i,subFig} = aFourier;
        
        
        summaryStats{1} = LplusRmean;
        summaryStats{2} = LplusRvar;
        summaryStats{3} = LminusRmean;
        summaryStats{4} = LminusRvar;
        summaryStats{5} = Freqmean;
        summaryStats{6} = Freqvar;
        summaryStats{7} = SinXmean;
        summaryStats{8} = SinXvar;
        summaryStats{9} = PI;
        
        plot(timeSeries,xTrace,'Color',[0 0 1]);          
        xlim([-5 4*60+10]);
        ylim([0 360]);
        set(gca,'YTick',[0 90 180 270 360],'TickDir','out');
    end

end    

  
    subplot(8,1,1);
    if size(fileList,2) == 1
    	preTitle = [comment, ' - ',fileName];
    else
        preTitle = ['probeBoxContrast-Crunch - ',comment];
    end
    title({preTitle;'Vertical Bar'});
    subplot(8,1,8);
    xlabel('Time (sec)');
    
    heightList = [1,2,3,4,5,6,7];
    for heightN = 1:7
        subplot(8,1,heightN+1);
        title(['Box Contrast: ',num2str(heightList(heightN))]);
    end
    
        set(gcf, 'Color', 'white');
        set(gcf, 'InvertHardcopy','off');
        set(gcf,'Units','pixels');
        scnsize = get(0,'ScreenSize');
        set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [8.5 11])
        set(gcf, 'PaperPosition', [0 0 8.5 11]);
        
        if size(fileList,2) == 1
            filenameOut = strrep(fileName,'.mat','-Tele.pdf');
        else
            filenameOut = ['probeBoxContrast-Crunch-',comment,'-1.pdf'];
        end
        print(gcf, '-dpdf',[settings.dataDir,filenameOut]);
 
        
        
        % Print summary stats
        
        figure();
        for metric = 1:9
            for i=1:size(fileList,2)
                subplot(3,4,metric); hold on;
                dataChunk = summaryStats{metric};
                for j=1:8
                    dataList(j) = dataChunk{i,j};
                end
                plot(1,dataList(1),'-o','Color',colorList(i,:));
                plot(2:8,dataList(2:8),'-o','Color',colorList(i,:));
                set(gca,'XTick',1:8,...
                    'XTickLabel',{'Bar','1','2','3','4','5','6','7'}); 

            end
        end
        
        for metric= 1:9
            subplot(3,4,metric);
            % Fill with bg color
            lims = ylim();
            for heightN=1:8
                fill([heightN-.5 heightN+.5 heightN+.5 heightN-.5],[lims(1) lims(1) lims(2) lims(2)],(colorList(heightN,:)/4)+.75,'FaceAlpha',.5,'EdgeColor','none');
            end
            xlim([.5 8.5]);
        end
                       
        subplot(3,4,1);
        ylabel('mean(L+R)');
        subplot(3,4,2);
        ylabel('var(L+R)');
        subplot(3,4,3);
        ylabel('mean(L-R)');
        subplot(3,4,4);
        ylabel('var(L-R)');
        subplot(3,4,5);
        ylabel('mean(Freq)');
        subplot(3,4,6);
        ylabel('var(Freq)');
        subplot(3,4,7);
        ylabel('mean(sin(angle))');
        subplot(3,4,8);
        ylabel('var(sin(angle))');
        subplot(3,4,9);
        ylabel('PI');
        
%         subplot(3,4,10);
%         ylabel('Straightness');
%         for i=1:size(fileList,2)
%             for subFig = 1:8
%                 straightTrace = Straightness{i,subFig};
%                 hold on;
%                 plot(windowSizes(1:6)/1000,straightTrace,'Color',colorList(subFig,:));
%                 xlabel('Smoothing window size (s)');
%             end    
%         end
%         
%         subplot(3,4,11);
%         ylabel('X FFT Ampl.');
%         for i=1:size(fileList,2)
%             for subFig = 1:8
%                 spectrum = Fourier{i,subFig};
%                 hold on;
%                 plot(1./spectrum.freq,(spectrum.ampl),'Color',colorList(subFig,:));
%             end
%         end
%         xlim([.1 10]);
%         xlabel('Period (s)');
%         
%         subplot(3,4,12);
%         ylabel('sin(X) FFT Ampl.');
%         for i=1:size(fileList,2)
%             for subFig = 1:8
%                 spectrum = SinFourier{i,subFig};
%                 hold on;
%                 plot(1./spectrum.freq,(spectrum.ampl),'Color',colorList(subFig,:));
%             end
%         end
%         xlim([.1 10]);
%         xlabel('Period (s)');

          
        
        subplot(3,4,2);
        if size(fileList,2) == 1
            preTitle = [comment, ' - ',fileName];
        else
            preTitle = ['probeBoxContrast-Crunch - ',comment];
        end
        title({preTitle;'Summary Stats'});
        
        % Output the B-page
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
            filenameOut = ['probeBoxContrast-Crunch-',comment,'-2.pdf'];
        end
        print(gcf, '-dpdf',[settings.dataDir,filenameOut]);