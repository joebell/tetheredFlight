function accumulateHistogram(fileList,epochRows)

    rangeX = 3.75:3.75:360;
    n = zeros(size(rangeX,2),1);

    for fileN = 1:size(fileList,2)
        
        file = fileList(fileN);
        loadData(file);
        
        [smoothX, wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
        expTime = getExpTime(histogramBounds, data.Rcv, daqParams);
        
        for epochRowN = 1:size(epochRows,2)
            epochRow = epochRows(epochRowN);
            boundsRow = nonzeros(histogramBounds(epochRow,:));
            for col = 1:2:size(boundsRow,1)
                epochStT = boundsRow(col);
                epochEndT = boundsRow(col+1); 
                
                disp(['St: ',num2str(epochStT)]);
                disp(['End: ',num2str(epochEndT)]);
                
                epochStSamp = dsearchn(expTime',epochStT)-100;
                epochEndSamp = dsearchn(expTime',epochEndT)+100;
                
                figure();
                subplot(2,1,1);
                plot(expTime(epochStSamp:epochEndSamp), wrappedX(epochStSamp:epochEndSamp));
                subplot(2,1,2);
                diffRcv = abs(diff(data.Rcv)); diffRcv(end+1) = 0;
                plot(expTime(epochStSamp:epochEndSamp), diffRcv(epochStSamp:epochEndSamp));
                
            end
        end  
    end