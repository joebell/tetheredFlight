%
experiment = '111229-ACV-2-POLBS';
fileList = returnFileList(experiment);

%% Histogram ranges
rangeX = 3.75:3.75:360;
rangedX = -1440:7.5:1440;
ranged2X = -300:4:300;
nRangeX = size(rangeX,2);
maxY = 8;
OLepochs = [1 12 13];
preTime = 0; 

%% OL Time Domain Plots

figList{3} = figure();

EVepochList = 2:11;
preTime = 0;
postTime = 10;

for nEpoch = 1:10;
    preTime = -2;
    postTime = 11;
    epochRanges = EVepochList(nEpoch);
    subplot(10,2,(nEpoch - 1)*2 + 1); hold on;
    [traces, timeTrace] = accumulateWBATraces(fileList,epochRanges, preTime, postTime);
    plotBands(timeTrace,traces,'b');
    xlim([timeTrace(1) timeTrace(end)]);
    ylim([-300 300]);
end
subplot(10,2,1); title('EV');
subplot(10,2,11); ylabel('WBA (cV)');
subplot(10,2,19); xlabel('Time (sec)');

odorEpochList = 14:23;
for nEpoch = 1:10;
    preTime = -2;
    postTime = 11;
    epochRanges = odorEpochList(nEpoch);
    subplot(10,2,(nEpoch - 1)*2 + 2); hold on;
    [traces, timeTrace] = accumulateWBATraces(fileList,epochRanges, preTime, postTime);
    plotBands(timeTrace,traces,'b');
    xlim([timeTrace(1) timeTrace(end)]);
    ylim([-300 300]);
end
subplot(10,2,2); title('Odor');
subplot(10,2,12); ylabel('WBA (cV)');
subplot(10,2,20); xlabel('Time (sec)');

bigTitle(['Experiment: ',experiment]);
codeStampFigure(gcf);