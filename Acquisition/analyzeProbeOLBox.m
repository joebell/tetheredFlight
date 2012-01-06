function analyzeProbeOLBox(file)

settings = tfSettings();

comment = '';

fileList = {file};

        
tOffset = -.2; % Timing offset
rateError = -.43; % Correction for DAQ clock
colorList = [[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v')];

figure(2);

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
                if (epoch == 1)
                    subplot(6,2,sfa(6,2,subFig,odorOn));  
                else
                    set(gcf,'CurrentAxes',ax1);
                end

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
                plot(timeSeries,lTrace-rTrace,'b');
                plot([timeSeries(1),timeSeries(end)],[0 0],'k');
                xlim([-4 14]);
                ylim([-250 250]);
                ylabel('WBA (cV)');
                ax1 = gca;
                set(ax1,'Color','none');
                ax2 = axes('Position',get(ax1,'Position'),...
                    'XAxisLocation','bottom',...
                    'YAxisLocation','right',...
                    'Color','none',...
                    'XColor','k','YColor','g');
                 hold on;
                 plot(timeSeries,xTrace,'Color','g','Parent',ax2);
                 hold on;
                 set(ax2,'XTick',[]);
                 xlim([-4 14]);
                 ylim([0 360]);
                 ylabel('Angle (deg)');


                title(stimValues(subFig));
                %ylim([0 360]);
                %set(gca,'YTick',[0 90 180 270 360],'TickDir','out');

                subplot(6,2,sfa(6,2,6,odorOn));

                hold on;
                plot(timeSeries,fTrace,'Color',colorFader(subFig,11));
                xlim([-4 14]);
                ylabel('Freq (Hz)');
                title(fileName);
            end

        end   
    end
end
  

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

 
        
        
   