% Accumulates a histogram from file in fileList and epochs in epochRanges
%
% Epoch start times can be adjusted +preTime, and end times +postTime
%
% Specify X bins with rangeX
function [stds, rangeX, rangedX] = accumulatePhaseStd(fileList,epochRanges, preTime, postTime, means, rangeX, rangedX)

    n = zeros(size(rangeX,2),size(rangedX,2));
    sums = zeros(size(rangeX,2),size(rangedX,2));

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
                dX = filteredData.dX(sampleList);
                dWBA = filteredData.filtdWBAdiff(sampleList);
                xNums = dsearchn(rangeX',binnedX);
                dxNums = dsearchn(rangedX',dX);
                for i=1:size(xNums,1)
                    squareDiff = (dWBA(i) - means(xNums(i),dxNums(i)))^2;
                    sums(xNums(i),dxNums(i)) = sums(xNums(i),dxNums(i)) + squareDiff;
                    n(xNums(i),dxNums(i)) = n(xNums(i),dxNums(i)) + 1;                   
                end
            end
            
        end
    end
    
    vars = sums ./ n;
    % Set undefined variances to 0
    ind = find(isnan(vars));
    vars(ind) = 0;
    % Report the standard deviations
    stds = sqrt(vars);
    