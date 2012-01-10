%%
function [xTraces, dXTraces, WBATraces, dWBATraces, times] = getTrajectories(fileList,epochRanges, preTime, postTime, startingPoint, tolX, toldX, length, smoothXtrace)

    times = getExpTime(0,length);
    nSamples = size(times,1);
    
    xTraces = [];
    dXTraces = [];
    WBATraces = [];
    dWBATraces = [];

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
                if smoothXtrace
                    % Smooth X
                    X  = mod(filteredData.filtX(sampleList),360);
                else    
                    % Quantized X
                    [smoothX, wrappedX] = smoothUnwrap(data.X(sampleList), daqParams.xOutputCal, 0);
                    X = histReady(wrappedX);
                end
                dX = filteredData.dX(sampleList); 
                WBA = filteredData.filtWBAdiff(sampleList);
                dWBA = filteredData.filtdWBAdiff(sampleList);
                xInTol = abs(X - startingPoint(1)) <= tolX;
                dXInTol = abs(dX - startingPoint(2)) <= toldX;
                tolPoints = find(xInTol & dXInTol);
                endSample = -1;
                for i=1:size(tolPoints,1)
                    stSample = tolPoints(i);  
                    % Only accept new trace starts after end of previous
                    % trace
                    if (endSample < stSample)
                        disp('Found a segment');
                        endSample = tolPoints(i) + nSamples - 1;
                        sampleList = stSample:endSample;
                        xTraces = padcat(1,xTraces,X(sampleList)');
                        dXTraces = padcat(1,dXTraces,dX(sampleList)');  
                        WBATraces = padcat(1,WBATraces,WBA(sampleList)'); 
                        dWBATraces = padcat(1,dWBATraces,dWBA(sampleList)');
                    end
                end
                
                
            end
            
        end
    end
    
