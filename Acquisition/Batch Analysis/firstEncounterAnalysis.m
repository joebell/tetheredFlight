% batchAnalyzeRTTF.m

clear all;

% fileList = {'../Data/Apr25/RTTF100425-115040.mat'};

fileList = {'../Data/Jul16/RTTF100716-115659.mat', ...
            '../Data/Jul16/RTTF100716-132452.mat', ...
            '../Data/Jul16/RTTF100716-135907.mat', ...
            '../Data/Jul16/RTTF100716-155637.mat', ...
            '../Data/Jul16/RTTF100716-105943.mat', ...
            '../Data/Jul16/RTTF100716-112325.mat', ...            
            '../Data/Jul15/RTTF100715-111719.mat', ...
            '../Data/Jul15/RTTF100715-114354.mat', ...
            '../Data/Jul15/RTTF100715-134948.mat', ...
            '../Data/Jul15/RTTF100715-145655.mat'};
% fileList = {'../Data/Jul16/RTTF100716-115659.mat'};
        
% fileList = filesIndirectory('../Data/Apr25/batch/');
smoothingWindow = 4; % Boxcar window, in seconds
        
tOffset = -.129; % Timing offset
rateError = .36; % Correction for DAQ clock

preStimulus = 15; % Pre-stimulus to plot in seconds
postStimulus = 30; % Post-stimulus to plot in seconds

totEVX = 0;
totOdX = 0;
totEVdiffX = 0;
totOddiffX = 0;
totEVSum = 0;
totOdSum = 0;
totEVDiff = 0;
totOdDiff = 0;
totEVFreq = 0;
totOdFreq = 0;
    
for file=1:size(fileList,2)
    
    
    load(fileList{file});
    nSamples = size(data.LAmp,1);
    data.time = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
    [data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
    
    data.diffX = diff(data.smoothX)*daqParams.SampleRate;
    data.diffX(end+1) = 0;
    data.diffX = smooth(data.diffX, daqParams.SampleRate*2);

    % Find time of first EV encounter
    [C, evStartSample] = min(abs(data.time - 60));
    [C, evEndSample] = min(abs(data.time - 180));
    evOdors = data.Odor;
    evOdors(1:evStartSample) = 0;
    evOdors(evEndSample:end) = 0;
    firstEV = find(evOdors./5 > .5, 1, 'first');

    % Find time of first Odor encounter
    [C, odStartSample] = min(abs(data.time - 180));
    [C, odEndSample] = min(abs(data.time - 300));
    odOdors = data.Odor;
    odOdors(1:odStartSample) = 0;
    odOdors(odEndSample:end) = 0;
    firstOd = find(odOdors./5 > .5, 1, 'first');
    
    % Find samples from odor to plot
    preSamples = round(preStimulus * (daqParams.SampleRate + rateError));
    postSamples = round(postStimulus * (daqParams.SampleRate + rateError));
    EVRegion = (firstEV - preSamples):(firstEV + postSamples);
    OdRegion = (firstOd - preSamples):(firstOd + postSamples);
    alignedTime = -preStimulus:(preStimulus+postStimulus)/(preSamples+postSamples) :postStimulus;

    % Plot the pattern angle
    figure(1);
    subplot(2,1,1);
    hold on;
    plot(alignedTime, data.wrappedX(EVRegion),'b');
    xlabel('Time from first EV onset');
    ylabel('Pattern angle (deg.)')
    ylim([0 360]);
    subplot(2,1,2);
    hold on;
    plot(alignedTime, data.wrappedX(OdRegion),'r');
    xlabel('Time from first odor onset');
    ylabel('Pattern angle (deg.)');    
    ylim([0 360]);
    totEVX = totEVX + data.wrappedX(EVRegion);
    totOdX = totOdX + data.wrappedX(OdRegion);
    
    % Plot the pattern angle speed
    figure(2);
    subplot(2,1,1);
    hold on;
    plot(alignedTime, abs(data.diffX(EVRegion)),'b');
    xlabel('Time from first EV onset');
    ylabel('Pattern angle speed (deg./sec)')
    subplot(2,1,2);
    hold on;
    plot(alignedTime, abs(data.diffX(OdRegion)),'r');
    xlabel('Time from first odor onset');
    ylabel('Pattern angle speed (deg./sec)');
    totEVdiffX = totEVdiffX + data.diffX(EVRegion);
    totOddiffX = totOddiffX + data.diffX(OdRegion);
    
    % Plot the WBA sum
    wbaSum = smooth(data.LAmp + data.RAmp,100,'moving');
    figure(3);
    subplot(2,1,1);
    hold on;
    plot(alignedTime, wbaSum(EVRegion),'b');
    xlabel('Time from first EV onset');
    ylabel('WBA Sum (cV)')
    subplot(2,1,2);
    hold on;
    plot(alignedTime, wbaSum(OdRegion),'r');
    xlabel('Time from first odor onset');
    ylabel('WBA Sum (cV)');
    totEVSum = totEVSum + wbaSum(EVRegion);
    totOdSum = totOdSum + wbaSum(OdRegion);
    
    % Plot the WBA diff
    wbaDiff = smooth(abs(data.LAmp - data.RAmp),100,'moving');
    figure(4);
    subplot(2,1,1);
    hold on;
    plot(alignedTime, wbaDiff(EVRegion),'b');
    xlabel('Time from first EV onset');
    ylabel('Absolute WBA Difference (cV)')
    subplot(2,1,2);
    hold on;
    plot(alignedTime, wbaDiff(OdRegion),'r');
    xlabel('Time from first odor onset');
    ylabel('Absolute WBA Difference (cV)');
    totEVDiff = totEVDiff + wbaDiff(EVRegion);
    totOdDiff = totOdDiff + wbaDiff(OdRegion);
    
    % Plot the WBA freq
    figure(5);
    subplot(2,1,1);
    hold on;
    plot(alignedTime, abs(data.Freq(EVRegion)),'b');
    xlabel('Time from first EV onset');
    ylabel('WBA Freq (Hz)')
    ylim([175 275]);
    subplot(2,1,2);
    hold on;
    plot(alignedTime, abs(data.Freq(OdRegion)),'r');
    xlabel('Time from first odor onset');
    ylabel('WBA Freq (Hz)');
    ylim([175 275]);
    totEVFreq = totEVFreq + abs(data.Freq(EVRegion));
    totOdFreq = totOdFreq + abs(data.Freq(OdRegion));

    
    disp(['Analyzed file ',num2str(file),'.']);
end

% figure(6);
% plot(alignedTime, totEVX ./ size(fileList,2),'b');
% hold on;
% plot(alignedTime, totOdX ./ size(fileList,2),'r');
% xlabel('Time from first encounter (s)');
% ylabel('Mean pattern angle (deg)');
% 
% figure(7);
% plot(alignedTime, totEVdiffX ./ size(fileList,2),'b');
% hold on;
% plot(alignedTime, totOddiffX ./ size(fileList,2),'r');
% xlabel('Time from first encounter (s)');
% ylabel('Mean pattern angle speed (deg/sec)');

figure(8);
plot(alignedTime, totEVSum ./ size(fileList,2),'b');
hold on;
plot(alignedTime, totOdSum ./ size(fileList,2),'r');
xlabel('Time from first encounter (s)');
ylabel('Mean WBA Sum (cV)');

figure(9);
plot(alignedTime, totEVDiff ./ size(fileList,2),'b');
hold on;
plot(alignedTime, totOdDiff ./ size(fileList,2),'r');
xlabel('Time from first encounter (s)');
ylabel('Mean Abs. WBA Diff (cV)');

figure(10);
plot(alignedTime, totEVFreq ./ size(fileList,2),'b');
hold on;
plot(alignedTime, totOdFreq ./ size(fileList,2),'r');
xlabel('Time from first encounter (s)');
ylabel('Mean WBA Freq (Hz)');
