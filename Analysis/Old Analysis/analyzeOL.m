function analyzeOL(filename)

comment = '';

settings = tfSettings();
%analyzeRTTF([settings.dataDir,filename],comment);
%analyzeWBAStats([settings.dataDir,filename],comment);
analyzeProbeOL(filename);
%analyzeProbeOLBox(filename);