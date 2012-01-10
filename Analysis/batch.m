%% batch

fileList = returnFileList('111229-ACV-2-POLBS');
%fileList = [72];

rangeX = 3.75:3.75:360;
rangedX = -1080:4:1080;
ranged2X = -300:300;
timeStep = 2;
epochRanges = [1];
preTime = 0;
postTime = 100;

figure(); hold on;
[traces, timeTrace] = accumulateXTraces(fileList,epochRanges, preTime, postTime);
for i=1:size(traces,1)
    plot(timeTrace,traces(i,:));
end
xlim([timeTrace(1) timeTrace(end)]);
ylim([0 360]);
% 
% figure(); hold on;
% [traces, timeTrace] = accumulatedXTraces(fileList,epochRanges, preTime, postTime);
% for i=1:size(traces,1)
%     plot(timeTrace,traces(i,:));
% end
% xlim([timeTrace(1) timeTrace(end)]);
% ylim([-900 900]);
% 
% figure(); hold on;
% [n, rangeX] = accumulateHistogram(fileList,epochRanges, preTime, postTime, rangeX);
% plot(rangeX,n);

figure(); hold on;
[ns, rangeX] = accumulateMultiHistogram(fileList,epochRanges, preTime, postTime, rangeX);
for i=1:size(ns,1)
    plot(rangeX,ns(i,:));
end
figure(); hold on;
plotBands(rangeX,ns,'b');

% 
% figure(); hold on;
% [n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, preTime, postTime, timeStep, rangeX);
% h = pcolor(rangeT,rangeX,n);
% set(h,'EdgeColor','none');
% xlim([rangeT(1) rangeT(end)]);
% ylim([rangeX(1) rangeX(end)]);
% % 
% figure(); hold on;
% [n, rangeX, rangedX] = accumulatePhaseHistogram(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
% h = pcolor(rangeX,rangedX,log(n'));
% set(h,'EdgeColor','none');
% xlim([rangeX(1) rangeX(end)]);
% ylim([rangedX(1) rangedX(end)]);

% figure(); hold on;
% [traces, timeTrace] = accumulateWBATraces(fileList,epochRanges, preTime, postTime);
% for i=1:size(traces,1)
%     plot(timeTrace,traces(i,:));
% end
% xlim([timeTrace(1) timeTrace(end)]);
% ylim([-200 200]);
% 
% figure(); hold on;
% plotBands(timeTrace,traces,'b');
% xlim([timeTrace(1) timeTrace(end)]);
% ylim([-200 200]);
% 
% 
% 
% figure(); hold on;
% [traces, timeTrace] = accumulatedWBATraces(fileList,epochRanges, preTime, postTime);
% for i=1:size(traces,1)
%     plot(timeTrace,traces(i,:));
% end
% xlim([timeTrace(1) timeTrace(end)]);
% ylim([-800 800]);
% 
% figure(); hold on;
% plotBands(timeTrace,traces,'b');
% xlim([timeTrace(1) timeTrace(end)]);
% ylim([-800 800]);

% figure(); hold on;
% [means, n, rangeX, rangedX] = accumulatePhaseMeans(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
% h = pcolor(rangeX,rangedX,means');
% set(h,'EdgeColor','none');
% xlim([rangeX(1) rangeX(end)]);
% ylim([rangedX(1) rangedX(end)]);
% caxis([ranged2X(1) ranged2X(end)]);

% figure(); hold on;
% [stds, rangeX, rangedX] = accumulatePhaseStd(fileList,epochRanges, preTime, postTime, means, rangeX, rangedX);
% h = pcolor(rangeX,rangedX,stds');
% set(h,'EdgeColor','none');
% xlim([rangeX(1) rangeX(end)]);
% ylim([rangedX(1) rangedX(end)]);
% stdStd = std(stds(:));
% caxis([0 2*stdStd]);

% figure(); hold on;
% modelFun = fitModel(means, n, rangeX, rangedX);
% h = plot(modelFun,'Style','Contour','XLim',[rangeX(1) rangeX(end)],'YLim',[rangedX(1) rangedX(end)]);
% set(h,'EdgeColor','none');
% levelList = ranged2X(1):(ranged2X(end)-ranged2X(1))/20:ranged2X(end);
% set(h,'LevelList',levelList);
% set(h,'ButtonDownFcn',{@plotTrajectory,modelFun});
% line(xlim(),[0 0],'Color',[0 0 0]);
% line([90 90],ylim(),'Color',[0 0 0]);
% line([270 270],ylim(),'Color',[0 0 0]);
% set(gca,'XTick',[90 270]);
% set(gca, 'YTick',[-720 -360 0 360 720]);
% grid off;
% 
% figure(); hold on;
% modelFun = fitModel(means, n, rangeX, rangedX);
% h = plot(modelFun,'Style','Contour','XLim',[rangeX(1) rangeX(end)],'YLim',[rangedX(1) rangedX(end)]);
% set(h,'EdgeColor','none');
% levelList = ranged2X(1):(ranged2X(end)-ranged2X(1))/20:ranged2X(end);
% set(h,'LevelList',levelList);
% set(h,'ButtonDownFcn',{@plotRealTrajectory,fileList,epochRanges, preTime, postTime});
% line(xlim(),[0 0],'Color',[0 0 0]);
% line([90 90],ylim(),'Color',[0 0 0]);
% line([270 270],ylim(),'Color',[0 0 0]);
% set(gca,'XTick',[90 270]);
% set(gca, 'YTick',[-720 -360 0 360 720]);
% grid off;

% startingPoint = [90, 100];
% tolX = 2;
% toldX = 5;
% length = .75;
% smoothX = false;
% [xTraces, dXTraces, WBATraces, dWBATraces, times] = getTrajectories(fileList,epochRanges, preTime, postTime, startingPoint, tolX, toldX, length, smoothX);
% disp(['Found ',num2str(size(xTraces,1)),' segments.']);
% for i=1:size(xTraces,1)
%     plot(xTraces(i,:),dXTraces(i,:));
% end
% 
% figure(); hold on;
% [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
% for i=1:size(WBAtraces,1)
%     plot(rangeX,dWBAtraces(i,:));
% end
% xlim([rangeX(1) rangeX(end)]);
% 
% figure(); hold on;
% plotBands(rangeX,dWBAtraces,'b');
% xlim([rangeX(1) rangeX(end)]);
