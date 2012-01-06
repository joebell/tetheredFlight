function analyzeProbeOLBoxSpinBatch()

settings = tfSettings();

comment = '';

filtersOn = true;


fileList = {...
    
% % ACV -2 clean tubing POLBS
'RTTF111229-102516.mat',...
'RTTF111229-141909.mat',...
'RTTF111229-171456.mat',...
'RTTF111230-095137.mat',...
'RTTF120103-094445.mat',...
'RTTF120103-104148.mat',...


% % CL stripe -> OL stripe
%     'RTTF111201-102025.mat',...
%     'RTTF111201-113225.mat',...
%     'RTTF111201-133143.mat',...
%     'RTTF111201-144537.mat',...
%     'RTTF111207-131114.mat',...
%     'RTTF111207-162037.mat',...
%     'RTTF111209-124319.mat',...
%     'RTTF111209-140913.mat',...
%     'RTTF111209-151310.mat',...
%     'RTTF111209-164324.mat',...
%     'RTTF111213-110030.mat',...
%     'RTTF111213-140047.mat',...
%     'RTTF111213-150241.mat',...
        
            };



        
tOffset = -.2; % Timing offset
rateError = -.43; % Correction for DAQ clock
colorList = [[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v')];

meanTraceFig = figure();
meandTraceFig = figure();
byCycleFigure = figure();
byCycleDFigure = figure();
odorOverlayFig = figure();
odorOverlayDFig = figure();


%% Get parameters from first file
    i = 1;
    fileName = fileList{i};   
    load([settings.dataDir,fileName]);
    nSamples = size(data.LAmp,1);
    exptime = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
    [data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
    
    sampleBounds = round((histogramBounds - tOffset) .* (daqParams.SampleRate + rateError));
    numHist = size(histogramBounds,1);
    
    
    preStim = 10;
    postStim = 5;
    stimValues = [720 540 360 180 90 -90 -180 -360 -540 -720];
    
    disp(['Analyzing ',num2str(size(fileList,2)),' files...']);
    
    
%%
for odorOn = 1:2
    for subFig = 1:10
        
        disp(['Subfig: ',num2str(subFig)]);

        nTraces = 0;
        sumTrace = [];
        sumdTrace = [];
        diffHist = zeros(96,1);
        diffDHist = zeros(96,1);
        diffNums = zeros(96,1);
        
        for i=1:size(fileList,2)
  
            % For each file, get the data
            fileName = fileList{i};   
            load([settings.dataDir,fileName]);
            epochList = nonzeros(histogramBounds(subFig+1+(odorOn-1)*12,:));
            numEpochs = size(epochList,1)/2;
            epochSamples = round((epochList - tOffset) .* (daqParams.SampleRate + rateError));

            % For each epoch to align
            for epoch = 1:numEpochs
                
                stSamp = epochSamples(2*epoch - 1) ;
                endSamp   = epochSamples(2*epoch) ;
                preSamp = round(preStim*(daqParams.SampleRate + rateError));
                postSamp = round(postStim*(daqParams.SampleRate + rateError));
                sampList  = stSamp - preSamp:endSamp + postSamp;
                    
                lTrace = data.LAmp(sampList);
                rTrace = data.RAmp(sampList);
                % Filter to generate dWBA/dt
                if filtersOn
                    % Was 1-5
                    h=fdesign.lowpass('Fp,Fst,Ap,Ast',2,10,1,60,1000);
                    db=design(h,'equiripple');         
                    filtDiff = filtfilt(db.Numerator,1,lTrace - rTrace);
                else
                    filtDiff = lTrace - rTrace;
                end
                dWBAdiff = diff(filtDiff) .* 1000; dWBAdiff(end+1) = dWBAdiff(end);
            
                coreSamples = stSamp:endSamp;
                %relCoreSamples = (1+preSamp):(end-postSamp);
                coreDiff = filtDiff((1+preSamp):(end-postSamp));
                coreDDiff = dWBAdiff((1+preSamp):(end-postSamp));
                [smoothX, wrappedX] = smoothUnwrap(data.X(coreSamples), daqParams.xOutputCal, 0);
                histReadyX = histReady(wrappedX);
                coreNX = round(histReadyX./3.75);
                for frame=1:(size(coreSamples,2))
                    diffHist(coreNX(frame)) = diffHist(coreNX(frame)) + coreDiff(frame);
                    diffDHist(coreNX(frame)) = diffDHist(coreNX(frame)) + coreDDiff(frame);
                    diffNums(coreNX(frame)) = diffNums(coreNX(frame)) + 1;
                end
                
%                 figure(byCycleFigure);
%                 subplot(10,2,sfa(10,2,subFig,odorOn)); hold on;
%                 plot(coreDiff,'b');
%                 plot(wrappedX,'g');
                               
                nTraces = nTraces + 1;
                sumTrace = sum(padcat(1, sumTrace, (filtDiff)'));            
                sumdTrace = sum(padcat(1, sumdTrace, (dWBAdiff)')); 
                
            end
            


        end  
        
        figure(byCycleFigure);
        subplot(10,2,sfa(10,2,subFig,odorOn)); hold on;
        plot(3.75:3.75:360,diffHist./diffNums);
        xlim([0 360]);
        set(gca,'XTick',[90 270]);
        
        figure(byCycleDFigure);
        subplot(10,2,sfa(10,2,subFig,odorOn)); hold on;
        plot(3.75:3.75:360,diffDHist./diffNums);
        xlim([0 360]);
        set(gca,'XTick',[90 270]);
        
        figure(odorOverlayFig);
        subplot(10,2,sfa(10,2,subFig,1)); hold on;
        if (odorOn == 1)
            plot(3.75:3.75:360,diffHist./diffNums,'b');
        else
            plot(3.75:3.75:360,diffHist./diffNums,'r');
        end
        xlim([0 360]);
        set(gca,'XTick',[90 270]);
        
        
        figure(odorOverlayDFig); 
        subplot(10,2,sfa(10,2,subFig,1)); hold on;
        if (odorOn == 1)
            plot(3.75:3.75:360,diffDHist./diffNums,'b');
        else
            plot(3.75:3.75:360,diffDHist./diffNums,'r');
        end
        xlim([0 360]);
        set(gca,'XTick',[90 270]);
        
        meanTrace = sumTrace ./ nTraces;
        meandTrace = sumdTrace ./ nTraces;
        % Once all the files are done and the mean is calculated, calculate
        % the stdev
        varTrace = [];
        vardTrace = [];
        for i=1:size(fileList,2)
  
            % For each file, get the data
            fileName = fileList{i};   
            load([settings.dataDir,fileName]);
            epochList = nonzeros(histogramBounds(subFig+1+(odorOn-1)*12,:));
            numEpochs = size(epochList,1)/2;
            epochSamples = round((epochList - tOffset) .* (daqParams.SampleRate + rateError));

            % For each epoch to align
            for epoch = 1:numEpochs
                
                stSamp = epochSamples(2*epoch - 1) ;
                endSamp   = epochSamples(2*epoch) ;
                sampList  = stSamp- round(preStim*(daqParams.SampleRate + rateError)):endSamp+ round(postStim*(daqParams.SampleRate + rateError));
     
                lTrace = data.LAmp(sampList);
                rTrace = data.RAmp(sampList); 
                % Filter to generate dWBA/dt
                if filtersOn
                    % Was 1-5
                    h=fdesign.lowpass('Fp,Fst,Ap,Ast',2,10,1,60,1000);
                    db=design(h,'equiripple');         
                    filtDiff = filtfilt(db.Numerator,1,lTrace - rTrace);
                else
                    filtDiff = lTrace - rTrace;
                end
                dWBAdiff = diff(filtDiff) .* 1000; dWBAdiff(end+1) = dWBAdiff(end);
                
                diffTrace = sum(padcat(1, meanTrace, -(filtDiff)'));
                diffdTrace = sum(padcat(1, meandTrace, -(dWBAdiff)'));
                varTrace = sum(padcat(1,varTrace,diffTrace .* diffTrace));
                vardTrace = sum(padcat(1,vardTrace,diffdTrace .* diffdTrace));
            end
        end
        varTrace = varTrace ./ (nTraces-1);
        semTrace = sqrt(varTrace)./sqrt(nTraces);
        vardTrace = vardTrace ./ (nTraces-1);
        semdTrace = sqrt(vardTrace)./sqrt(nTraces);
        
        % Now plot the values
        figure(meanTraceFig);
        subplot(10,2,sfa(10,2,subFig,odorOn));
        hold on;
        time = exptime(1:size(meanTrace(:),1)) - exptime(1) - 10;
        h = area([time;time]',[(meanTrace-semTrace);(2*semTrace)]',-10000);
        set(h,'EdgeColor','none');
        set(h,'FaceColor','none');
        set(h(2),'FaceColor',[.8 .8 1]);
        plot(time,meanTrace,'b');
        plot([time(1),time(end)],[0 0],'k');
        xlim([-4 14]);
        ylim([-150 150]);
        ylabel('WBA (cV)');
        title(stimValues(subFig));
        pause(1);
        
%         % Now plot the values
        figure(meandTraceFig);
        subplot(10,2,sfa(10,2,subFig,odorOn));
        hold on;
        time = exptime(1:size(meandTrace(:),1)) - exptime(1) - 10;
        h = area([time;time]',[(meandTrace-semdTrace);(2*semdTrace)]',-10000);
        set(h,'EdgeColor','none');
        set(h,'FaceColor','none');
        set(h(2),'FaceColor',[.8 .8 1]);
        plot(time,meandTrace,'b');
        plot([time(1),time(end)],[0 0],'k');
        xlim([-4 14]);
        ylim([-150 150]);
        ylabel('dWBA/dt (cV/sec)');
        title(stimValues(subFig));
        pause(1);
        
        
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

 
        
        
   