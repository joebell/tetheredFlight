%% setTfSettings.m
%
function setTfSettings()

    settings.tfDir = 'C:\Documents and Settings\Wilson Lab\Desktop\Code\tetheredFlight\';
    settings.dataDir = 'C:\Documents and Settings\Wilson Lab\Desktop\Data\dataCzar\Flight\';
    
    oldDir = cd([settings.tfDir,'Acquisition\']);
    
    save('.tfSettings.mat','settings');
        
    cd(oldDir);