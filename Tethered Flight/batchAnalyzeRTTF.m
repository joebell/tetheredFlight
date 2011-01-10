% batchAnalyzeRTTF.m

clear all;

% fileList = {'../Data/Apr25/RTTF100425-115040.mat'};

% fileList = {'../Data/Jul16/RTTF100716-115659.mat', ...
%             '../Data/Jul16/RTTF100716-132452.mat', ...
%             '../Data/Jul16/RTTF100716-135907.mat', ...
%             '../Data/Jul16/RTTF100716-155637.mat', ...
%             '../Data/Jul16/RTTF100716-105943.mat', ...
%             '../Data/Jul16/RTTF100716-112325.mat', ...            
%             '../Data/Jul15/RTTF100715-111719.mat', ...
%             '../Data/Jul15/RTTF100715-114354.mat', ...
%             '../Data/Jul15/RTTF100715-134948.mat', ...
%             '../Data/Jul15/RTTF100715-145655.mat'};
fileList = {'../Data/RTTF101102-125652.mat'};
        
% fileList = filesIndirectory('../Data/Apr25/batch/');
smoothingWindow = 4; % Boxcar window, in seconds
        
tOffset = -.129; % Timing offset
rateError = .36; % Correction for DAQ clock
    
for file=1:size(fileList,2)
    
    
    load(fileList{file});
    nSamples = size(data.LAmp,1);
    data.time = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
    [data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
    
    sampleBounds = round(histogramBounds * daqParams.SampleRate) + 1;
    numHist = size(histogramBounds,1);
    numParts = size(histogramBounds,2);

    for i=numHist:-1:1
        partsList = [];
        for j=1:2:numParts
            partsList = cat(2, partsList, sampleBounds(i,j):sampleBounds(i,j+1));
        end
        % 2 second boxcar filter on angle data
        smoothX = smooth(cos(data.wrappedX(:)*2*pi/360),daqParams.SampleRate*smoothingWindow,'moving');
        smoothY = smooth(sin(data.wrappedX(:)*2*pi/360),daqParams.SampleRate*smoothingWindow,'moving');
        
        % Append additional datapoints
        if (file == 1)
            Xvector{i} = smoothX(partsList);
            Yvector{i} = smoothY(partsList);
        else
            Xvector{i} = cat(1,Xvector{i},smoothX(partsList));
            Yvector{i} = cat(1,Yvector{i},smoothY(partsList));
        end
    end 
    
    %% Plot the angle histogram
 
figure();

sampleBounds = round(histogramBounds * daqParams.SampleRate) + 1;
numHist = size(histogramBounds,1);
numParts = size(histogramBounds,2);

clear('bins','n');

for i=numHist:-1:1
    partsList = [];
    for j=1:2:numParts
        partsList = cat(2, partsList, sampleBounds(i,j):sampleBounds(i,j+1));
    end
    [bins(i,:), n(i,:)] = rose((data.wrappedX(partsList)+1.8)*2*pi/360,96); 
    %was smoothX
    %[n(i,:), bins(i,:)] = hist(data.wrappedX(partsList)*2*pi/360,96);
    maxN(i) = max(n(i,:));
end

[B, IX] = sort(maxN,'descend');
totMax = max(maxN);

for plotNum = 1:size(histogramBounds,1)
    subplot(2,( size(histogramBounds,1)), plotNum);
    for i=plotNum
        polar(bins(i,:),n(i,:)./maxN(plotNum),colorList(i));
        hold on;
    end
    lims = ylim();
    maxR = 1;


    for i=1:size(trialStructureList,1)
        time(i) = trialStructureList{i,1};
        laser(i,:) = trialStructureList{i,3}; 
        odor1(i,:) = trialStructureList{i,4}; 
        odor2(i,:) = trialStructureList{i,5}; 
    end
    for i = 2:size(trialStructureList,1)
        for j=1:16
            if (  bitand( hex2dec(laser(i-1,:)), bitshift(1,j-1))  > 0)
                interval = -2*pi/16;
                angles = (j-1)*interval:interval/15:j*interval;
                Rmaxes = 1*ones(16,1);
                [X, Y] = pol2cart([(j-1)*interval angles j*interval],[0 Rmaxes' 0]);
                fill(X, Y, [1 .7 .7],'EdgeColor','none','FaceAlpha',.5);
                hold on;
            end
            if (  bitand( hex2dec(odor1(i-1,:)), bitshift(1,j-1))  > 0)
                interval = -2*pi/16;
                angles = (j-1)*interval:interval/15:j*interval;
                Rmaxes = .8*ones(16,1);
                [X, Y] = pol2cart([(j-1)*interval angles j*interval],[0 Rmaxes' 0]);
                fill(X, Y, [.7 1 .7],'EdgeColor','none','FaceAlpha',.5);
                hold on;
            end
            if (  bitand( hex2dec(odor2(i-1,:)), bitshift(1,j-1))  > 0)
                interval = -2*pi/16;
                angles = (j-1)*interval:interval/15:j*interval;
                Rmaxes = .6*ones(16,1);
                [X, Y] = pol2cart([(j-1)*interval angles j*interval],[0 Rmaxes' 0]);
                fill(X, Y, [.7 .7 1],'EdgeColor','none','FaceAlpha',.5);
                hold on;
            end
        end
    end

    hline = findobj(gca,'Type','line');
    set(hline,'LineWidth',1);
    axis equal;
    title(comment);
end
out = n;
    
    
%%    
    disp(['Analyzed file ',num2str(file),'.']);
end

figure();
load(fileList{1});
 for plotNum = 1:size(histogramBounds,1)
        clear('bins','n');
        subplot(1,size(histogramBounds,1),plotNum);  
        N = hist3([Xvector{plotNum},Yvector{plotNum}],{[-1.2:.05:1.2],[-1.2:.05:1.2]});
        % N = hist3(randn(10000,2),[20,20]);       
        myMap = hot;
        % colormap(myMap(end:-1:1,:));  % Inverts colormap...
        colormap(hot);
        h = pcolor( N' / sum(N(:)));
        set(h,'EdgeColor','none');
        % colorbar;
        axis square;
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
 end
 
 