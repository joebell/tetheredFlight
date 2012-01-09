function testFilteredData(fileList)

 for fileN = 1:size(fileList,2)
        
        loadData(fileList(fileN));
        
        % Generate a new file name to hold filtered data
        dcSettings = dataCzarSettings();
        load([dcSettings.dataCzarDir,'.dmIndex.mat']);
        file = dmIndex.files(fileList(fileN));
        sourceName = file.name;        
        newName = strrep(sourceName,'.mat','filt.mat');