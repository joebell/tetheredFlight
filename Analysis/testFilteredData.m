function testFilteredData(fileList)

 for fileN = 1:size(fileList,2)
        
        loadData(fileList(fileN));
        
        filteredData = loadFilteredData(fileList(fileN));
        
        [smoothX, wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
        
        timeBase = getExpTime(size(wrappedX,2));
        
        figure();
        plot(timeBase,wrappedX,'b'); hold on;
        plot(timeBase,mod(filteredData.filtX,360),'r');
        
        figure();
        hist(filteredData.dX,-900:30:900);
        xlim([-900 900]);
        
        figure();
        plot(timeBase,data.LAmp - data.RAmp,'b'); hold on;
        plot(timeBase,filteredData.filtWBAdiff,'r');
        
        figure();
        hist(filteredData.filtdWBAdiff,200);
 end
 