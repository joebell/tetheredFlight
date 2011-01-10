% plotRingBuffer.m
%
% Utility function to inspect the last few seconds of tracked frames.
%
% JSB 11/2010
function plotRingBuffer()

    global trackingParams;
    
    ringBuffer = trackingParams.ringBuffer;
    
    figure(2);
    scatter(ringBuffer.buffer(:,1),ringBuffer.buffer(:,2));
    figure(3);
    hist(ringBuffer.time*1000,(0:1:100));
    disp(['Mean: ',num2str(mean(ringBuffer.time*1000))]);
    disp(['Median: ',num2str(median(ringBuffer.time*1000))]);
    xlim([20,100])
    xlabel('Tracking interval (ms)');
    
    figure(trackingParams.previewFigure);
