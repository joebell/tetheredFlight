function analyzePhasePlot(file)

settings = tfSettings();

comment = '';

fileList = {file};

        
tOffset = -.2; % Timing offset
rateError = -.43; % Correction for DAQ clock
colorList = [[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v');[0,0,0];pretty('r');pretty('q');pretty('h');pretty('g');pretty('b');pretty('i');pretty('v')];


for i=1:size(fileList,2)
  
    fileName = fileList{i};   
    load([settings.dataDir,fileName]);
    nSamples = size(data.LAmp,1);
    data.time = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
    [data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
    
    h=fdesign.lowpass('Fp,Fst,Ap,Ast',1,5,1,60,1000);
    d=design(h,'equiripple');
    data.filtX = filtfilt(d.Numerator,1,data.smoothX);
    % data.filtX = smooth(data.smoothX,501);
    data.dX = diff(data.filtX);     data.dX(end+1) = 0;
    data.intX = cumsum(data.dX);
    data.intX = data.intX + mean(data.filtX(:)) - mean(data.intX(:));
    data.dX = data.dX .* 1000;  % Makes units degrees per second.
    
    data.smoothDiff = filtfilt(d.Numerator,1,data.LAmp - data.RAmp);
    
%     figure(1);
%     subplot(2,1,1);
%     plot(data.time,data.smoothX,'b'); hold on;
%     plot(data.time,data.intX-1,'g');
%     plot(data.time,data.filtX,'r');
%     subplot(2,1,2);
%     plot(data.time,data.dX);
       
    data.histReadyX = data.wrappedX;
    ind = find(data.histReadyX == 0); data.histReadyX(ind) = 360;
    ind = find(isnan(data.histReadyX)); data.histReadyX(ind) = 360;
    data.histReadyX = data.histReadyX';
    
%      figure(2);
%      subplot(2,1,1);
%      hist(data.dX,-80:1:80);
%      subplot(2,1,2);
%      hist(data.smoothDiff,-20:1:20);

    % Find lagging dX's
    lagTime = .3*1000; % 50 ms
    lagWindow = .200*1000; % 500 ms
    data.dXlag = zeros(size(data.dX,1),1);
    for t=1:(size(data.dX,1) - lagTime - lagWindow)
        data.dXlag(t) = mean(data.smoothDiff((t+lagTime):(t+lagTime+lagWindow)));
    end
    
    % Plot a histogram for each epoch
    numHist = size(histogramBounds,1);
    for histN = 1:numHist

        startTime = histogramBounds(histN,1);
        endTime = histogramBounds(histN,2);
        startSample = dsearchn(data.time',startTime);
        endSample = dsearchn(data.time',endTime);
        sampleRange = startSample:endSample;
        
        range1 = 3.75:3.75:360;
        range2 = -250:1:250;
        n = hist3([data.histReadyX(sampleRange), data.dXlag(sampleRange)],{range1,range2});
    
        % normalize histogram along axis1
        for angle=1:size(range1,2)
            if (sum(n(angle,:)) > 0)
                n(angle,:) = n(angle,:)./sum(n(angle,:));
            end
        end   
    %     limit = .06;
    %     ind = find(n > limit);
    %     n(ind) = limit;

        figure(1);
        subplot(2,numHist,histN);
        colormap(jet);
        h = pcolor(range1,range2,log(n'));
        set(h,'EdgeColor','none');
        %xlabel('WBA Sum');
        %ylabel('Freq (Hz)');
        
        figure(1);
        subplot(2,numHist,histN+numHist);
        lagInRange = data.dXlag(sampleRange);
        for angle = 1:size(range1,2)
            ind = find(data.histReadyX(sampleRange)==range1(angle));
            sigResp(angle) = std(lagInRange(ind))/sqrt(size(ind,2));
            avgResp(angle) = mean(lagInRange(ind));
        end
        plot(range1,avgResp,'b'); hold on;
        plot(range1,avgResp+sigResp,'g');
        plot(range1,avgResp-sigResp,'g');
        line(xlim(),[0 0],'Color',[0 0 0]);
        line([90 90],ylim(),'Color',[0 0 0]);
        
        
    end
    
end    
%                 xTrace = data.wrappedX(sampList);
%                 lTrace = data.LAmp(sampList);
%                 rTrace = data.RAmp(sampList);
%                 fTrace = data.Freq(sampList);