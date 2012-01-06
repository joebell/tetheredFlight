function analyze(filename)

comment = '';

settings = tfSettings();
analyzeRTTF([settings.dataDir,filename],comment);
analyzeWBAStats([settings.dataDir,filename],comment);