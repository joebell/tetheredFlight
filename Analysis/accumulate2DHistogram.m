% Accumulates a 2D time-angle histogram from file in fileList 
% and epochs in epochRanges
%
% Epoch start times can be adjusted +preTime, and end times +postTime
%
% Specify X bins with rangeX
function [n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, rangeX, rangeT)
  
    n = zeros(size(rangeX,2),size(rangeT,2));

    for fileN = 1:size(fileList,2)
        
        loadData(fileList(fileN));
        for epochN = 1:size(epochRanges,2)
            epoch = epochRanges(epochN);
            
            timeList = nonzeros(histogramBounds(epoch,:));
            for pair=1:2:size(timeList,2)
                timeList(pair) = timeList(pair) + rangeT(1);
                timeList(pair+1) = timeList(pair) + rangeT(end);
            end
            sampleBounds = convertToSamples(timeList);
                        
            for pair=1:2:size(sampleBounds,1)
                sampleList = sampleBounds(pair):sampleBounds(pair+1);
                [smoothX, wrappedX] = smoothUnwrap(data.X(sampleList), daqParams.xOutputCal, 0);
                binnedX = histReady(wrappedX);
                timeTrace = getExpTime(rangeT(1),rangeT(end));
                n = n + hist3([binnedX,timeTrace],{rangeX,rangeT});
            end
            
        end
    end
    
