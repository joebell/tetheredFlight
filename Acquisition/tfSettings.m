%% tfSettings.m
%
function settings = tfSettings()

    pathToDMF = which('tfSettings');
    pathToDM = regexprep(pathToDMF,'tfSettings.m','');
    load([pathToDM,'.tfSettings.mat']);