function analyzeDynamical()

settings = tfSettings(); 

comment = '';

fileList = {...
    
% 'RTTF111201-104428.mat',...
% 'RTTF111201-122216.mat',...
% 'RTTF111201-135624.mat',...
% 'RTTF111201-151025.mat',...
% 'RTTF111207-133608.mat',...
'RTTF111207-164512.mat',...

%             'RTTF111201-100104.mat',...
%            'RTTF111201-111359.mat',...
%             'RTTF111201-131145.mat',...
%             'RTTF111201-142355.mat',...
%             'RTTF111207-125135.mat',...
%             'RTTF111207-160003.mat',...

%     'RTTF111117-094814.mat',...
%     'RTTF111121-152906.mat',...
%     'RTTF111121-155951.mat',...
%     'RTTF111121-163530.mat',...
%     'RTTF111122-103438.mat',...
%     'RTTF111122-122752.mat',...
%     'RTTF111122-133315.mat',...
%     'RTTF111122-140326.mat',...
%     'RTTF111128-150604.mat',...
%     'RTTF111128-164458.mat',...
%     'RTTF111129-103038.mat',...
%     'RTTF111129-125504.mat',...
%     'RTTF111129-135021.mat',...
%             'RTTF111201-151025.mat',...
%             'RTTF111201-135624.mat',...
%             'RTTF111201-122216.mat',...
%             'RTTF111201-104428.mat',...

%     'RTTF111122-101353.mat',...
%     'RTTF111122-122544.mat',...
%     'RTTF111122-133106.mat',...
%     'RTTF111128-123539.mat',...
%     'RTTF111128-135155.mat',...
%     'RTTF111128-150351.mat',...
%     'RTTF111128-164236.mat',...
%     'RTTF111129-101059.mat',...
%     'RTTF111129-122357.mat',...
%     'RTTF111129-124509.mat',...
%     'RTTF111129-133946.mat',...    
%             'RTTF111130-104832.mat',...
%             'RTTF111130-123255.mat',...
%             'RTTF111130-135218.mat',...
%             'RTTF111130-145908.mat',...
%             'RTTF111201-100104.mat',...
%             'RTTF111201-111359.mat',...
%             'RTTF111201-131145.mat',...
%             'RTTF111201-142355.mat',...
    };

        
tOffset = -.2; % Timing offset
rateError = -.43; % Correction for DAQ clock
colorList = [[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v')];

cursor(1:10) = 1;
for i=1:size(fileList,2)
  
    fileName = fileList{i};   
    load([settings.dataDir,fileName]);
    nSamples = size(data.LAmp,1);
    data.time = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
    [data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
    
    h=fdesign.lowpass('Fp,Fst,Ap,Ast',1,8,1,60,1000);
    d=design(h,'equiripple');
    data.filtX = filtfilt(d.Numerator,1,data.smoothX);
    data.filtX = data.filtX - mean(data.filtX - data.smoothX);
    
    data.dX = diff(data.filtX).*1000;     data.dX(end+1) = data.dX(end);
    data.d2X = diff(data.dX) .* 1000; data.d2X(end+1) = data.d2X(end);
       
%     figure(1);
%     subplot(3,1,1);
%     plot(data.time,mod(data.smoothX,360),'b'); hold on;
%     plot(data.time,mod(data.filtX,360),'r');
%     ylabel('Smoothed Arena Angle X (degrees)');
%     subplot(3,1,2);
%     plot(data.time,data.dX);
%     ylabel('dX/dt (deg/sec)');
%     subplot(3,1,3);
%     plot(data.time,data.d2X);
%     ylabel('d^2X/dt^2 (deg/sec^2)');
       
    data.histReadyX = data.wrappedX;
    ind = find(data.histReadyX == 0); data.histReadyX(ind) = 360;
    ind = find(isnan(data.histReadyX)); data.histReadyX(ind) = 360;
    data.histReadyX = data.histReadyX';
    

    
%      figure(2);
%      subplot(3,1,1);
%      hist(data.histReadyX,rangeX);
%      xlabel('Angle histogram');
%      subplot(3,1,2);
%      hist(data.dX,range1);
%      xlabel('dX/dt histogram');
%      subplot(3,1,3);
%      hist(data.d2X,range2);
%      xlabel('d^2X/dt^2 histogram');

   
    % Plot a histogram for each epoch
    numHist = size(histogramBounds,1);
    for histN = 1:numHist

        startTime = histogramBounds(histN,1);
        endTime = histogramBounds(histN,2);
        startSample = dsearchn(data.time',startTime);
        endSample = dsearchn(data.time',endTime);
        sampleRange = startSample:endSample;
        numSamples = size(sampleRange,2);
        
        
        st = cursor(histN);
        en = cursor(histN) + numSamples - 1;
        XInRange(histN,st:en) = data.histReadyX(sampleRange);
        d1InRange(histN,st:en) = data.dX(sampleRange);
        d2InRange(histN,st:en) = data.d2X(sampleRange);
        cursor(histN) = cursor(histN) + numSamples;        
        
    end
    
end    

% Generate ranges
     rangeX = 3.75:3.75:360;
     dXstd = std(d1InRange(:));
     range1 =-3*dXstd:6*dXstd/100:3*dXstd;
     d2Xstd = std(d2InRange(:));
     range2 =-3*d2Xstd:6*d2Xstd/100:3*d2Xstd;
     
% Generate plots
sumFig = figure();
    for histN = 1:numHist
        
        n = hist3([XInRange(histN,:)', d2InRange(histN,:)'],{rangeX,range2});        
        % normalize histogram along axis1
        for angle=1:size(rangeX,2)
            if (sum(n(angle,:)) > 0)
                %n(angle,:) = n(angle,:)./sum(n(angle,:));
                zn(angle,:) = zscore(n(angle,:));
            else
                zn(angle,:) = zeros(1,size(range2,2));
            end
        end   
        
        figure(sumFig);
        subplot(4,numHist,histN);
        colormap(jet);
        h = pcolor(rangeX,range2,(zn'));
        caxis([-2 2]);
        set(h,'EdgeColor','none');
        xlabel('Arena angle');
        ylabel('d^2X/dt^2');
        
        subplot(4,numHist,histN+numHist);     
        for angle = 1:size(rangeX,2)
            ind = find(XInRange(histN,:)==rangeX(angle));
            sigResp(angle) = std(d2InRange(histN,ind));% ./sqrt(size(ind,2));
            avgResp(angle) = mean(d2InRange(histN,ind));
        end
        hold on;
        plot(rangeX,avgResp,'b');
        ylims = ylim();
        zavg = avgResp;
        ind = find(isnan(avgResp));
        zavg(ind) = 0;
        zsig = sigResp;
        ind = find(isnan(sigResp));
        zsig(ind) = 0;
        h = area([rangeX;rangeX]',[(zavg-zsig);(2*zsig)]',-1000);
        set(h,'EdgeColor','none');
        set(h,'FaceColor','none');
        set(h(2),'FaceColor',[.8 .8 1]); 
        ylim(ylims);
        line(xlim(),[0 0],'Color',[0 0 0]);
        line([90 90],ylim(),'Color',[0 0 0]);
        xlabel('Arena angle (deg)');
        ylabel('Mean d^2X/dt^2 +/- stdev');
        
        subplot(4,numHist,histN+2*numHist);
        indX = dsearchn(rangeX(:),XInRange(histN,:)');
        inddX = dsearchn(range1(:),d1InRange(histN,:)');
        dataToFit = [];
        angleFit = [];
        speedFit = [];
        weights = [];
        for angleN = 1:size(rangeX,2);
            for speedN = 1:size(range1,2);
                matches = find((indX == angleN) & (inddX == speedN));
                meanAccel = mean(d2InRange(histN,matches));
                d2Means(angleN,speedN) = meanAccel;
                d2Std(angleN,speedN) = std(d2InRange(histN,matches));
                if ~isnan(meanAccel)
                    dataToFit(end+1) = meanAccel;
                    weights(end+1) = size(matches,2);
                    angleFit(end+1) = rangeX(angleN);
                    speedFit(end+1) = range1(speedN);
                else
%                     dataToFit(end+1) = 0;
%                     angleFit(end+1) = rangeX(angleN);
%                     speedFit(end+1) = range1(speedN);
                end
                    
                
            end
        end       
        colormap(jet);
%         ind = find(isnan(d2Means));
%         d2Means(ind) = 0;
        h = pcolor(rangeX,range1,d2Means');
        caxis([range2(1) range2(end)]);
        set(h,'EdgeColor','none');
        xlabel('Arena angle');
        ylabel('dX/dt');
        title('Mean d^2X/dt^2');
        % colorbar();
        
        
        

%          subplot(4,numHist,histN+3*numHist);
%          colormap(jet);
%          h = pcolor(rangeX,range1,d2Std');
%          caxis([0 range2(end)/2]);
%          set(h,'EdgeColor','none');
%          xlabel('Arena angle');
%          ylabel('dX/dt');
%          title('Std d^2X/dt^2');

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
        options = fitoptions('Weights',weights(:));
        % Fit to weighted average data (if there's a lot)
        [cfun,gof,output] = fit([angleFit(:),speedFit(:)],dataToFit(:),ffun,options);
        % Fit to raw data
        %[cfun,gof,output] = fit([XInRange(histN,:)',d1InRange(histN,:)'],d2InRange(histN,:)',ffun);
        subplot(4,numHist,histN+3*numHist);
        h = plot(cfun,'Style','Contour','XLim',[0 360],'YLim',[range1(1) range1(end)]);
        % colorbar();
        set(h,'EdgeColor','none');
        levelList = range2(1):(range2(end)-range2(1))/20:range2(end);
        set(h,'LevelList',levelList);  
        set(h,'ButtonDownFcn',{@plotTrajectory,cfun});
        
    end
    
%     figure(sumFig);
%     filenameOut = 'DynAnalysis.pdf';
%         set(gcf, 'Color', 'white');
%         set(gcf, 'InvertHardcopy','off');
%         set(gcf,'Units','pixels');
%         scnsize = get(0,'ScreenSize');
%         set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
%         set(gcf, 'PaperUnits', 'inches');
%         set(gcf, 'PaperSize', [11 8.5])
%         set(gcf, 'PaperPosition', [0 0 11 8.5]);
%         print(gcf, '-dpdf',[settings.dataDir,filenameOut]);
    