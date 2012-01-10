% Accumulates traces from file in fileList 
% and epochs in epochRanges
%
% Epoch start times can be adjusted +preTime, and end times +postTime
%
function [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX)

    WBAtraces = [];
    dWBAtraces = [];
    
    for fileN = 1:size(fileList,2)
        
        loadData(fileList(fileN));
        filteredData = loadFilteredData(fileList(fileN));
        
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
                WBA = filteredData.filtWBAdiff(sampleList)';
                dWBA = filteredData.filtdWBAdiff(sampleList)';               
                xNums = dsearchn(rangeX',binnedX);
                WBAsums = zeros(1,size(rangeX,2));
                dWBAsums = zeros(1,size(rangeX,2));
                n = zeros(1,size(rangeX,2));
                for i=1:size(xNums,1)
                    WBAsums(xNums(i)) = WBAsums(xNums(i)) + WBA(i);
                    dWBAsums(xNums(i)) = dWBAsums(xNums(i)) + dWBA(i);  
                    n(xNums(i)) = n(xNums(i)) + 1; 
                end
                WBAavg = WBAsums ./ n;
                dWBAavg = dWBAsums ./ n;
                WBAtraces = padcat(1,WBAtraces,WBAavg);
                dWBAtraces = padcat(1,dWBAtraces,dWBAavg);
            end
            
        end
        
    end
    
