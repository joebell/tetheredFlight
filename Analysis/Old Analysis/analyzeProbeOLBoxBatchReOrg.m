function analyzeProbeOLBoxBatchReOrg()

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
    stimValues = [-120 -60 0 60 120];
    
    disp(['Analyzing ',num2str(size(fileList,2)),' files...']);
    
    
%%
for odorOn = 1:2
    for subFig = 1:5
        
        disp(['Subfig: ',num2str(subFig)]);

        nTraces = 0;
        sumTrace = [];
        sumdTrace = [];
        
        for i=1:size(fileList,2)
  
            % For each file, get the data
            fileName = fileList{i};   
            load([settings.dataDir,fileName]);
            epochList = nonzeros(histogramBounds(subFig+1+(odorOn-1)*7,:));
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
                h=fdesign.lowpass('Fp,Fst,Ap,Ast',1,5,1,60,1000);
                db=design(h,'equiripple');         
                filtDiff = filtfilt(db.Numerator,1,lTrace - rTrace);
                dWBAdiff = diff(filtDiff) .* 1000; dWBAdiff(end+1) = dWBAdiff(end);
            
               
                nTraces = nTraces + 1;
                sumTrace = sum(padcat(1, sumTrace, (filtDiff)'));            
                sumdTrace = sum(padcat(1, sumdTrace, (dWBAdiff)')); 
            end
        end  
        
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
            epochList = nonzeros(histogramBounds(subFig+1+(odorOn-1)*7,:));
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
                h=fdesign.lowpass('Fp,Fst,Ap,Ast',1,5,1,60,1000);
                db=design(h,'equiripple');         
                filtDiff = filtfilt(db.Numerator,1,lTrace - rTrace);
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
        subplot(5,2,sfa(5,2,subFig,odorOn));
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
        
        % Now plot the values
        figure(meandTraceFig);
        subplot(5,2,sfa(5,2,subFig,odorOn));
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

 
        
        
   