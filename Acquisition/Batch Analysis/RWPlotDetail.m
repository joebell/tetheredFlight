% Plot for detailed TF data for Rachel's talk
% Scale bars are 500 mV, 90 degrees, and 1 second

tOffset = -.129; % Timing offset
rateError = .36; % Correction for DAQ clock

    load('../Data/Jul16/RTTF100716-105943.mat');
    nSamples = size(data.LAmp,1);
    data.time = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
    [data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
    
    stSample = round(68*(daqParams.SampleRate + rateError));
    endSample = round(73*(daqParams.SampleRate + rateError));
    region = stSample:endSample;
    
    figure(1);
    hold on;
    plot(data.time(region),smooth(data.LAmp(region),20),'b','LineWidth',1.5);
    plot(data.time(region),smooth(data.RAmp(region),20),'r','LineWidth',1.5);
    fill ([68 68 68.1 68.1],[100 150 150 100],'k');
    fill ([68 68 69 69],[40 47 47 40] - 170,'k');
    
    plot(data.time(region),-data.wrappedX(region) + 230,'g','LineWidth',1.5);
    fill ([68 68 68.1 68.1],[0 90 90 0] - 90,'k');