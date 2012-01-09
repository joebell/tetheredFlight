function filteredData = loadFilteredData(fileN)

        % Generate a new file name to look for filtered data
        dcSettings = dataCzarSettings();
        load([dcSettings.dataCzarDir,'.dmIndex.mat']);
        file = dmIndex.files(fileN);
        sourceName = file.name;        
        newName = strrep(sourceName,'.mat','filt.mat');

        % Try to load the filtered data, but generate it if it's not there
        newNum = returnFileList(newName);
        if size(newNum,1) > 0
            loadData(newNum);
        else
            disp('Running filters.');
            runFilters(fileN);
            loadData(newName);
        end