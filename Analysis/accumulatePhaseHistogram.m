% Accumulates a histogram from file in fileList and epochs in epochRanges
%
% Epoch start times can be adjusted +preTime, and end times +postTime
%
% Specify X bins with rangeX
function [n, rangeX, rangedX] = accumulatePhaseHistogram(fileList,epochRanges, preTime, postTime, rangeX, rangedX)

    n = zeros(size(rangeX,2),size(rangedX,2));

    for fileN = 1:size(fileList,2)
        
        loadData(fileList(fileN));
        filteredData = loadFilteredData(fileList(fileN));
        
        for epochN = 1:size(epochRanges,2)
            epoch = epochRanges(epochN);
            
            timeList = nonzeros(histogramBounds(epoch,:));
            for pair=1:2:size(timeList,2)
                timeList(pair) = timeList(pair) + preTime;
                timeList(pair+1) = timeList(pair+1) + postTime;
            end
            sampleBounds = convertToSamples(timeList);
                        
            for pair=1:2:size(sampleBounds,2)
                sampleList = sampleBounds(pair):sampleBounds(pair+1);
                [smoothX, wrappedX] = smoothUnwrap(data.X(sampleList), daqParams.xOutputCal, 0);
                binnedX = histReady(wrappedX);
                dX = filteredData.dX(sampleList);
                n = n + hist3([binnedX,dX],{rangeX,rangedX});
            end
            
        end
    end
    
