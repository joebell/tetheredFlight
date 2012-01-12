%%
function analyzeSOLO(experiment)

fileList = returnFileList(experiment); 

%% Histogram ranges
rangeX = 3.75:3.75:360;
rangedX = -1080:7.5:1080;
ranged2X = -300:4:300;
timeStep = 2;
bigMaxY = .15;
littleMaxY = .05;

% figList{1} = figure();
% 
% 
% subplot(6,6,1:4); hold on;
% epochRanges = 1; preTime = 0; postTime = 599;
% [n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, preTime, postTime, timeStep, rangeX);
% h = pcolor(rangeT,rangeX,n);
% set(h,'EdgeColor','none');
% xlim([rangeT(1) rangeT(end)]);
% ylim([rangeX(1) rangeX(end)]);
% title('P(angle|time)');
% set(gca,'YTick',[90 270]);
% ylabel('Angle');
% 
% 
% 
% subplot(6,6,5); hold on;
% [ns, rangeX] = accumulateMultiHistogram(fileList,epochRanges, preTime, postTime, rangeX);
% ns = ns ./ (1000 * postTime);
% plotBands(rangeX,ns,'r');
% ylim([0 bigMaxY]);
% xlim([rangeX(1) rangeX(end)]);
% line([90 90],ylim(),'Color','k');
% line([270 270],ylim(),'Color','k');
% set(gca,'XTick',[90 270]);
% set(gca,'YTick',[0 bigMaxY]);
% title('P(angle)');
% 
% 
% 
% subplot(6,6,6); hold on;
% for i=1:size(ns,1)
%     plot(rangeX,ns(i,:));
% end
% ylim([0 bigMaxY]);
% xlim([rangeX(1) rangeX(end)]);
% set(gca,'XTick',[90 270]);
% set(gca,'YTick',[0 bigMaxY]);
% title('P(angle)');
% line([90 90],ylim(),'Color','k');
% line([270 270],ylim(),'Color','k');
% 
% 
% for epoch = 2:6
%     subplot(6,6,((epoch-1)*6 + 1):((epoch-1)*6 + 4)); hold on;
%     epochRanges = epoch; preTime = 0; postTime = 120;
%     [n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, preTime, postTime, timeStep, rangeX);
%     h = pcolor(rangeT,rangeX,n);
%     set(h,'EdgeColor','none');
%     xlim([rangeT(1) rangeT(end)]);
%     ylim([rangeX(1) rangeX(end)]);
%     set(gca,'YTick',[90 270]);
%     ylabel('Angle');
%     
% 
%     
%     subplot(6,6,(epoch-1)*6 + 5); hold on;
%     [ns, rangeX] = accumulateMultiHistogram(fileList,epochRanges, preTime, postTime, rangeX);
%     ns = ns ./ (1000 * postTime);
%     plotBands(rangeX,ns,'r');
%     ylim([0 littleMaxY]);
%     xlim([rangeX(1) rangeX(end)]);
%     set(gca,'XTick',[90 270]);
%     set(gca,'YTick',[0 littleMaxY]);
%     line([90 90],ylim(),'Color','k');
%     line([270 270],ylim(),'Color','k');
%     
% 
%     
%     subplot(6,6,(epoch-1)*6 + 6); hold on;
%     for i=1:size(ns,1)
%         plot(rangeX,ns(i,:));
%     end
%     ylim([0 littleMaxY]);
%     xlim([rangeX(1) rangeX(end)]);
%     set(gca,'XTick',[90 270]);
%     set(gca,'YTick',[0 littleMaxY]);
%     line([90 90],ylim(),'Color','k');
%     line([270 270],ylim(),'Color','k');
%     
%     
% end
% 
% subplot(6,6,(1-1)*6 + 5); ylabel('Vert. Bar');
% subplot(6,6,(2-1)*6 + 5); ylabel('Box');
% subplot(6,6,(3-1)*6 + 5); ylabel('Box + EV');
% subplot(6,6,(4-1)*6 + 5); ylabel('Box + Odor');
% subplot(6,6,(5-1)*6 + 5); ylabel('Box + EV');
% subplot(6,6,(6-1)*6 + 5); ylabel('Box + Odor');
% 
% 
% 
% bigTitle(['Experiment: ',experiment]);
% codeStampFigure(gcf);

%% Make PI trace figure
figList{2} = figure();

subplot(6,6,1:5);
epochRanges = 1; preTime = 0; postTime = 599;
[traces, timeTrace] = accumulateXTraces(fileList,epochRanges, preTime, postTime);
sinTraces = sin(traces*2*pi/360);
plotBands(timeTrace,sinTraces,'b');
ylim([-1 1]); ylabel('Vert. Bar'); set(gca,'YTick',[-1 0 1]);
xlim([preTime postTime]);
title('sin(angle)');
line(xlim(),[0 0],'Color','k');

for nEpoch = 2:6
    subplot(6,6,(nEpoch-1)*6 + (1:5));
    epochRanges = nEpoch; preTime = 0; postTime = 120;
    [traces, timeTrace] = accumulateXTraces(fileList,epochRanges, preTime, postTime);
    sinTraces = sin(traces*2*pi/360);
    plotBands(timeTrace,sinTraces,'b');
    ylim([-1 1]); set(gca,'YTick',[-1 0 1]);
    xlim([preTime postTime]);
    line(xlim(),[0 0],'Color','k');
    
    subplot(6,6,(nEpoch-1)*6 + 6);
    meanSin = mean(sinTraces,2);
    Xones = ones(size(sinTraces,1),1);
    scatter(meanSin,Xones,'+'); xlim([-1 1]); ylim([0 2]);
    set(gca,'YTick',[]);
    set(gca,'XTick',[-1 0 1]);
    
end

subplot(6,6,(6-1)*6 + (1:5)); xlabel('Time (sec)');

subplot(6,6,(2-1)*6 + (1:5)); ylabel('Box');
subplot(6,6,(3-1)*6 + (1:5)); ylabel('Box + EV');
subplot(6,6,(4-1)*6 + (1:5)); ylabel('Box + Odor');
subplot(6,6,(5-1)*6 + (1:5)); ylabel('Box + EV');
subplot(6,6,(6-1)*6 + (1:5)); ylabel('Box + Odor');

bigTitle(['Experiment: ',experiment]);
codeStampFigure(gcf);

%% Save figs!

saveMultiPage(figList,experiment);
