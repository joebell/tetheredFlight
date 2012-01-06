function analyzeBatchDynamical()

settings = tfSettings();

comment = '';


fileList = {...
    
% % ACV -2 clean tubing POLBS
'RTTF111229-102516.mat',...
'RTTF111229-141909.mat',...
'RTTF111229-171456.mat',...
'RTTF111230-095137.mat',...
'RTTF120103-094445.mat',...
'RTTF120103-104148.mat',...

%     % SOS done
%     'RTTF111201-104428.mat',...
%     'RTTF111201-122216.mat',...
%     'RTTF111201-135624.mat',...
%     'RTTF111201-151025.mat',...
%     'RTTF111207-133608.mat',...
%     'RTTF111207-164512.mat',...
%     'RTTF111209-130706.mat',...
%     'RTTF111209-143258.mat',...
%     'RTTF111209-153722.mat',...
%     'RTTF111209-170747.mat',...
%     'RTTF111213-112413.mat',...
%     'RTTF111213-142503.mat',...
%     'RTTF111213-152740.mat',...

% % CL stripe -> OL box
%     'RTTF111201-100350.mat',...
%     'RTTF111201-111609.mat',...
%     'RTTF111201-131413.mat',...
%     'RTTF111201-142605.mat',...
%     'RTTF111130-150114.mat',...
%     'RTTF111130-135425.mat',...
%     'RTTF111207-125402.mat',...
%     'RTTF111207-160215.mat',...
%     'RTTF111209-122706.mat',...
%     'RTTF111209-134243.mat',...
%     'RTTF111209-145648.mat',...
%     'RTTF111209-162709.mat',...
%     'RTTF111210-143748.mat',...
%     'RTTF111213-104411.mat',...
%     'RTTF111213-114631.mat',...
%     'RTTF111213-134401.mat',...
%     'RTTF111213-144541.mat',...

%     % Old SOS done
%             'RTTF100716-115659.mat', ...
%             'RTTF100716-132452.mat', ...
%             'RTTF100716-135907.mat', ...
%             'RTTF100716-155637.mat', ...
%             'RTTF100716-105943.mat', ...
%             'RTTF100716-112325.mat', ...            
%             'RTTF100715-111719.mat', ...
%             'RTTF100715-114354.mat', ...
%             'RTTF100715-134948.mat', ...
%             'RTTF100715-145655.mat', ...
    
            };



        
tOffset = -.2; % Timing offset
rateError = -.43; % Correction for DAQ clock
colorList = [[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v')];


%% Get parameters from first file
    i = 1;
    fileName = fileList{i};   
    load([settings.dataDir,fileName]);
    histogramBounds = [5,120;720,840;840,960];
    nSamples = size(data.LAmp,1);
    expTime = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
    numHist = size(histogramBounds,1);
    
    disp(['Analyzing ',num2str(size(fileList,2)),' files...']);
    
%%
 
% Generate histogram ranges
rangeX = 3.75:3.75:360;
range1 =-1080:3.75:1080;
range2 =-240:2:240;
filterSamplePad = 2000;

histFig = figure();
modelFig = figure();
fitModels = {};

% Do histograms separately
for histN = 1:numHist
    
    disp(['Hist #: ',num2str(histN)]);
    n2byX = zeros(size(rangeX,2),size(range2,2));
    ndXbyX  = zeros(size(rangeX,2),size(range1,2));
    sum2bydXbyX = zeros(size(rangeX,2),size(range1,2),2); % 1 is sum, 2 is count
    sumSq2bydXbyX = zeros(size(rangeX,2),size(range1,2),2);
    
    % Go through once to get the means
	for fileN=1:size(fileList,2)
        
        disp(['File #: ',num2str(fileN),' pass 1.']);
        
        % For each file, get the data
        fileName = fileList{fileN};
        load([settings.dataDir,fileName]);
        histogramBounds = [5,120;720,840;840,960];
        epochList = nonzeros(histogramBounds(histN,:));
        numEpochs = size(epochList,1)/2;
        epochSamples = round((epochList - tOffset) .* (daqParams.SampleRate + rateError));
        % For each epoch to align
        for epoch = 1:numEpochs
            
            % Pad samples to protect against filter transients
            filtStSamp = epochSamples(2*epoch - 1) - filterSamplePad;
            stSamp = epochSamples(2*epoch - 1);
            endSamp   = epochSamples(2*epoch);
            filtEndSamp   = epochSamples(2*epoch) + filterSamplePad;
            if (filtStSamp < 1) filtStSamp = 1; end
            if (filtEndSamp > size(data.LAmp,1)) filtEndSamp = size(data.LAmp,1); end
            sampList  = filtStSamp:filtEndSamp;
            lTrace = data.LAmp(sampList);
            rTrace = data.RAmp(sampList);
            xTrace = data.X(sampList);
            [smoothX, wrappedX] = smoothUnwrap(xTrace, daqParams.xOutputCal, 0);
            
            % Filter to generate smoothed X, dX
            % Was 1,8
            histReadyX = histReady(wrappedX);
            nX = round(histReadyX./3.75);
            h=fdesign.lowpass('Fp,Fst,Ap,Ast',1,8,1,60,1000);
            da=design(h,'equiripple');
            filtX = filtfilt(da.Numerator,1,smoothX);
            filtX = filtX - mean(filtX - smoothX);
            dX = diff(filtX).*1000;    dX(end+1) = dX(end);
            % Filter to generate dWBA/dt
            h=fdesign.lowpass('Fp,Fst,Ap,Ast',2,10,1,60,1000);
            db=design(h,'equiripple');         
            filtDiff = filtfilt(db.Numerator,1,lTrace - rTrace);
            dWBAdiff = diff(filtDiff) .* 1000; dWBAdiff(end+1) = dWBAdiff(end);
            
            % Chop off filter pads
            realStartPad = stSamp - filtStSamp;
            realEndPad = filtEndSamp - endSamp;
            histReadyX = histReadyX((1+realStartPad):(end-realEndPad));
            nX = nX((1+realStartPad):(end-realEndPad));
            dX = dX((1+realStartPad):(end-realEndPad));
            dWBAdiff = dWBAdiff((1+realStartPad):(end-realEndPad));
            ndX = dsearchn(range1(:), dX(:));
            
            % Add to a histogram of dWBA by X
            n2byX = n2byX + hist3([histReadyX(:), dWBAdiff(:)],{rangeX,range2});
            % Add to a histogram of dX by X
            ndXbyX = ndXbyX + hist3([histReadyX(:), dX(:)],{rangeX,range1});
            % Get average dWBA by X and 
            for frame = 1:size(nX,1)
                sum2bydXbyX(nX(frame),ndX(frame),1) = ...
                    sum2bydXbyX(nX(frame),ndX(frame),1) + dWBAdiff(frame);
                sum2bydXbyX(nX(frame),ndX(frame),2) = ...
                    sum2bydXbyX(nX(frame),ndX(frame),2) + 1;
            end
        end
    end
    
    % Calculate the means
    mean2dXbyX = sum2bydXbyX(:,:,1) ./ sum2bydXbyX(:,:,2);
    ind = find(isnan(mean2dXbyX)); mean2dXbyX(ind) = 0;
    
    % Go through again to get the stdev
	for fileN=1:size(fileList,2)
        
        disp(['File #: ',num2str(fileN),' pass 2.']);
        
        % For each file, get the data
        fileName = fileList{fileN};
        load([settings.dataDir,fileName]);
        histogramBounds = [5,120;720,840;840,960];
        epochList = nonzeros(histogramBounds(histN,:));
        numEpochs = size(epochList,1)/2;
        epochSamples = round((epochList - tOffset) .* (daqParams.SampleRate + rateError));
        % For each epoch to align
        for epoch = 1:numEpochs
            
            % Pad samples to protect against filter transients
            filtStSamp = epochSamples(2*epoch - 1) - filterSamplePad;
            stSamp = epochSamples(2*epoch - 1);
            endSamp   = epochSamples(2*epoch);
            filtEndSamp   = epochSamples(2*epoch) + filterSamplePad;
            if (filtStSamp < 1) filtStSamp = 1; end
            if (filtEndSamp > size(data.LAmp,1)) filtEndSamp = size(data.LAmp,1); end
            sampList  = filtStSamp:filtEndSamp;
            lTrace = data.LAmp(sampList);
            rTrace = data.RAmp(sampList);
            xTrace = data.X(sampList);
            [smoothX, wrappedX] = smoothUnwrap(xTrace, daqParams.xOutputCal, 0);
            
            % Filter to generate smoothed X, dX
            % Was 1,8
            histReadyX = histReady(wrappedX);
            nX = round(histReadyX./3.75);
            h=fdesign.lowpass('Fp,Fst,Ap,Ast',1,8,1,60,1000);
            da=design(h,'equiripple');
            filtX = filtfilt(da.Numerator,1,smoothX);
            filtX = filtX - mean(filtX - smoothX);
            dX = diff(filtX).*1000;    dX(end+1) = dX(end);
            % Filter to generate dWBA/dt
            h=fdesign.lowpass('Fp,Fst,Ap,Ast',2,10,1,60,1000);
            db=design(h,'equiripple');         
            filtDiff = filtfilt(db.Numerator,1,lTrace - rTrace);
            dWBAdiff = diff(filtDiff) .* 1000; dWBAdiff(end+1) = dWBAdiff(end);
            
            % Chop off filter pads
            realStartPad = stSamp - filtStSamp;
            realEndPad = filtEndSamp - endSamp;
            histReadyX = histReadyX((1+realStartPad):(end-realEndPad));
            nX = nX((1+realStartPad):(end-realEndPad));
            dX = dX((1+realStartPad):(end-realEndPad));
            dWBAdiff = dWBAdiff((1+realStartPad):(end-realEndPad));
            ndX = dsearchn(range1(:), dX(:));
            
            % Get sum squares dWBA by X and dX
            for frame = 1:size(nX,1)
                
                sumSqFrame = (dWBAdiff(frame) - mean2dXbyX(nX(frame),ndX(frame)))^2;               
                sumSq2bydXbyX(nX(frame),ndX(frame),1) = ...
                    sumSq2bydXbyX(nX(frame),ndX(frame),1) + sumSqFrame;
                sumSq2bydXbyX(nX(frame),ndX(frame),2) = ...
                    sumSq2bydXbyX(nX(frame),ndX(frame),2) + 1;
            end
        end
    end
       

%%    
% Plot histogram
    for angle=1:size(rangeX,2)
        if (sum(n2byX(angle,:)) > 0)
            n2byX(angle,:) = zscore(n2byX(angle,:));
        else
            n2byX(angle,:) = zeros(1,size(range2,2));
        end
    end   
    figure(histFig);
    subplot(3,numHist,histN);
    colormap(jet);
    h = pcolor(rangeX,range2,(n2byX'));
    caxis([-2 2]);
        line(xlim(),[0 0],'Color',[0 0 0]);
        line([90 90],ylim(),'Color',[0 0 0]);
        line([270 270],ylim(),'Color',[0 0 0]);
    set(h,'EdgeColor','none');
    xlabel('Arena angle');
    ylabel('dWBA/dt');
    title('P(dWBA/dt|X)');

    %% Plot mean dWBA/dt
    figure(histFig);
    subplot(3,numHist,numHist*1 + histN); hold on;
        colSum = sum(sum2bydXbyX(:,:,1),2) ./ sum(sum2bydXbyX(:,:,2), 2);
        %colSum = sum(mean2dXbyX,2);
        colStd = sqrt(sum(sumSq2bydXbyX(:,:,1),2) ./ sum(sumSq2bydXbyX(:,:,2),2));
        ind = find(isnan(colStd)); colStd(ind) = 2*(range2(end)-range2(1));
        ind = find(colStd == 0); colStd(ind) = 2*(range2(end)-range2(1));
        plot(rangeX,colSum);
        ind = find(isnan(colSum)); colSum(ind) = 0;
        h = area([rangeX;rangeX]',[(colSum-colStd),(2*colStd)],-1000);
        set(h,'EdgeColor','none');
        set(h,'FaceColor','none');
        set(h(2),'FaceColor',[.8 .8 1]); 
        xlim([3.75 360]);
        ylim([range2(1) range2(end)]);
        line(xlim(),[0 0],'Color',[0 0 0]);
        line([90 90],ylim(),'Color',[0 0 0]);
        line([270 270],ylim(),'Color',[0 0 0]);
        xlabel('Arena angle (deg)');
        ylabel('Mean dWBA/dt +/- stdev');

%% Plot 2D occupancy (log)          
    figure(histFig);
    subplot(3,numHist,numHist*2 + histN); hold on;
        colormap(jet);
        h = pcolor(rangeX,range1,log(ndXbyX'));
        caxis([0 max(log(ndXbyX(:)))]);
        set(h,'EdgeColor','none');
        xlabel('Arena angle');
        ylabel('dX/dt');
        title('log( P( dWBA/dt | X,dX/dt ))');
        line(xlim(),[0 0],'Color',[0 0 0]);
        line([90 90],ylim(),'Color',[0 0 0]);
        line([270 270],ylim(),'Color',[0 0 0]);
        xlim([3.75 360]);
        ylim([range1(1) range1(end)]);
    
    %% Plot avg dWBA/dt    
	figure(modelFig);
    subplot(3,numHist,numHist*0 + histN); hold on;
        colormap(jet);
        meanByTrace = sum2bydXbyX(:,:,1) ./ sum2bydXbyX(:,:,2);
        h = pcolor(rangeX,range1,meanByTrace');
        caxis([range2(1) range2(end)]);
        set(h,'EdgeColor','none');
        xlabel('Arena angle');
        ylabel('dX/dt');
        title('Mean dWBA/dt');
        line(xlim(),[0 0],'Color',[0 0 0]);
        line([90 90],ylim(),'Color',[0 0 0]);
        line([270 270],ylim(),'Color',[0 0 0]);
        xlim([3.75 360]);
        ylim([range1(1) range1(end)]);
    
    %% Plot std dWBA/dt   
    figure(modelFig);
    subplot(3,numHist,numHist*2 + histN); hold on;
        colormap(jet);
        stdByTrace = sqrt(sumSq2bydXbyX(:,:,1) ./ sumSq2bydXbyX(:,:,2));
        h = pcolor(rangeX,range1,stdByTrace');
        caxis([0 range2(end)]);
        set(h,'EdgeColor','none');
        xlabel('Arena angle');
        ylabel('dX/dt');
        title('Std dWBA/dt');
        line(xlim(),[0 0],'Color',[0 0 0]);
        line([90 90],ylim(),'Color',[0 0 0]);
        line([270 270],ylim(),'Color',[0 0 0]);
        xlim([3.75 360]);
        ylim([range1(1) range1(end)]);
    
    %% Do the models
    figure(modelFig);
    subplot(3,numHist,numHist*1 + histN); hold on;
        % Generate the fitting object
        terms = {};
        coeffs = {};
        nc = 1;
        for p= 0:5
            for m= 1:5
                terms{end + 1} = ['(v^',num2str(p),')*sin(x*(2*pi/360)*',num2str(m),')'];
                coeffs{end + 1} = ['c',num2str(nc)];
                nc = nc + 1;
                terms{end + 1} = ['(v^',num2str(p),')*cos(x*(2*pi/360)*',num2str(m),')'];
                coeffs{end + 1} = ['c',num2str(nc)];
                nc = nc + 1;
            end
            terms{end + 1} = ['(v^',num2str(p),')'];
            coeffs{end + 1} = ['c',num2str(nc)];
            nc = nc + 1;
        end
        ffun = fittype(terms,'coefficients',coeffs,'independent',{'x','v'});
        
        [angleFit,speedFit] = meshgrid(rangeX,range1);
        dataToFit = sum2bydXbyX(:,:,1) ./ sum2bydXbyX(:,:,2);
        dataToFit = dataToFit';
        ind = find(isnan(dataToFit)); dataToFit(ind) = 0;
        weights = sum2bydXbyX(:,:,2)';
        ind = find(isnan(weights)); weights(ind) = 0;
        options = fitoptions('Weights',weights(:));
        % Fit to weighted average data (if there's a lot)
        [cfun,gof,output] = fit([angleFit(:),speedFit(:)],dataToFit(:),ffun,options);
        fitModels{histN} = cfun;

        h = plot(cfun,'Style','Contour','XLim',[3.75 360],'YLim',[range1(1) range1(end)]);
        set(h,'EdgeColor','none');
        levelList = range2(1):(range2(end)-range2(1))/20:range2(end);
        set(h,'LevelList',levelList);  
        set(h,'ButtonDownFcn',{@plotTrajectory,cfun});
        line(xlim(),[0 0],'Color',[0 0 0]);
        line([90 90],ylim(),'Color',[0 0 0]);
        line([270 270],ylim(),'Color',[0 0 0]);
        title('Modeled dWBA/dt');
        
        sum2bydXbyXArch{histN} = sum2bydXbyX;
        sumSq2bydXbyXArch{histN} = sumSq2bydXbyX;
        n2byXArch{histN} = n2byX;
        ndXbyXArch{histN} = ndXbyX;
end

% Save models to a file
outputName = [settings.dataDir,'DynModels-',datestr(now,'YYmmDD-HHMM'),'.mat'];
save(outputName,'fitModels','sum2bydXbyXArch','sumSq2bydXbyXArch','n2byXArch','ndXbyXArch');

 
        
        
   