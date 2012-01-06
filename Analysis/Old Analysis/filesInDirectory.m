function fileList = filesInDirectory(directoryName)

    list = dir(directoryName);
    list(1:2) = [];
    
    for file = 1:size(list,1)
        
        fileList{file} = [directoryName, list(file).name];
        
    end
    
