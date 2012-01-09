% Accumulates traces from file in fileList 
% and epochs in epochRanges
%
% Epoch start times can be adjusted +preTime, and end times +postTime
%
function [traces, timeTrace] = accumulatedXTraces(fileList,epochRanges, preTime, postTime)

    traces = [];

    for fileN = 1:size(fileList,2)
        
        loadData(fileList(fileN));
        filteredData = loadFilteredData(fileList(fileN));
        for epochN = 1:size(epochRanges,2)
            epoch = epochRanges(epochN);
            
            timeList = nonzeros(histogramBounds(epoch,:));
            for pair=1:2:size(timeList,1)
                timeList(pair) = timeList(pair) + preTime;
                timeList(pair+1) = timeList(pair+1) + postTime;
            end
            sampleBounds = convertToSamples(timeList);
            
            for pair=1:2:size(sampleBounds,1)
                sampleList = sampleBounds(pair):sampleBounds(pair+1);               
                traces = padcat(1,traces,filteredData.dX(sampleList)');
            end
            
        end
        
        timeTrace = getExpTime(size(traces,2)) + preTime;
    end
    
