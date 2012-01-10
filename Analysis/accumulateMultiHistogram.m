% Accumulates a histogram from file in fileList and epochs in epochRanges
%
% Epoch start times can be adjusted +preTime, and end times +postTime
%
% Specify X bins with rangeX
function [ns, rangeX] = accumulateMultiHistogram(fileList,epochRanges, preTime, postTime, rangeX)

    ns = [];

    for fileN = 1:size(fileList,2)
        
        loadData(fileList(fileN));
        for epochN = 1:size(epochRanges,2)
            epoch = epochRanges(epochN);
            
            timeList = nonzeros(histogramBounds(epoch,:));
            for pair=1:2:size(timeList,1)
                timeList(pair+1) = timeList(pair) + postTime;
                timeList(pair) = timeList(pair) + preTime; 
            end
            sampleBounds = convertToSamples(timeList);
                        
            for pair=1:2:size(sampleBounds,1)
                sampleList = sampleBounds(pair):sampleBounds(pair+1);
                [smoothX, wrappedX] = smoothUnwrap(data.X(sampleList), daqParams.xOutputCal, 0);
                binnedX = histReady(wrappedX);
                n = hist(binnedX,rangeX);
                ns = padcat(1,ns,n);
            end
            
        end
    end
    
