function runFilters(fileList)

% Design filter for making dX/dt data
ha=fdesign.lowpass('Fp,Fst,Ap,Ast',1,8,1,60,1000);
da=design(ha,'equiripple');
% Design filter for WBA data
hb=fdesign.lowpass('Fp,Fst,Ap,Ast',2,10,1,60,1000);
db=design(hb,'equiripple');

 for fileN = 1:size(fileList,2)
        
        loadData(fileList(fileN));
        
        % Generate a new file name to hold filtered data
        dcSettings = dataCzarSettings();
        load([dcSettings.dataCzarDir,'.dmIndex.mat']);
        file = dmIndex.files(fileList(fileN));
        sourceName = file.name;        
        newName = strrep(sourceName,'.mat','filt.mat');
        
        % Get data to be filtered.
        [smoothX, wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
        lTrace = data.LAmp;
        rTrace = data.RAmp;
        % Filter X data    
        filtX = filtfilt(da.Numerator,1,smoothX);
        %filtX = filtX - mean(filtX - smoothX); % Subtract any DC residual
        dX = diff(filtX).*1000;    dX(end+1) = dX(end);
        % Filter WBA data
        filtDiff = filtfilt(db.Numerator,1,lTrace - rTrace);
        filtDiff = filtDiff - mean(filtDiff - (lTrace - rTrace)); % Subtract DC
        dWBAdiff = diff(filtDiff) .* 1000; dWBAdiff(end+1) = dWBAdiff(end);
        
        filteredData.filtX = filtX;
        filteredData.dX = dX;
        filteredData.filtWBAdiff = filtDiff;
        filteredData.filtdWBAdiff = dWBAdiff;
        
        saveExperimentData(newName,newName, 'filteredData');
 end