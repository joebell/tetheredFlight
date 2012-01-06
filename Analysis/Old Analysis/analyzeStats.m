function analyzeStats(filename)

comment = '';

settings = tfSettings();
analyzeWBAStats([settings.dataDir,filename],comment);