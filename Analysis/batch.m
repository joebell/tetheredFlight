%% batch

%fileList = returnFileList('111229-ACV-2-POLBS');
fileList = [15];

rangeX = 3.75:7.5:360;
rangedX = -800:50:800;
timeStep = .1;
epochRanges = [2];
preTime = -1;
postTime = 11;

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
% 
% figure(); hold on;
% [n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, preTime, postTime, timeStep, rangeX);
% h = pcolor(rangeT,rangeX,log(n));
% set(h,'EdgeColor','none');
% xlim([rangeT(1) rangeT(end)]);
% ylim([rangeX(1) rangeX(end)]);
% 
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