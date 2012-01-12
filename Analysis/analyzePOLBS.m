function analyzePOLBS(experiment)

fileList = returnFileList(experiment);

%% Histogram ranges
rangeX = 3.75:3.75:360;
rangedX = -1080:7.5:1080;
ranged2X = -300:4:300;
nRangeX = size(rangeX,2);
maxY = 8;

%% First generate OL plots
OLepochs = [1 12 13];

figList{1} = figure();
preTime = 0;
timeStep = 1;

postTime = 115;
subplot(4,3,1:3);
epochRanges = OLepochs(1);
[n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, preTime, postTime, timeStep, rangeX);
h = pcolor(rangeT,rangeX,n);
set(h,'EdgeColor','none');
xlim([rangeT(1) rangeT(end)]);
ylim([rangeX(1) rangeX(end)]);
title('Vert. Stripe P(angle|time)');
xlabel('Time');
set(gca,'YTick',[90 270]);
ylabel('Angle');

postTime = 120;
subplot(4,3,4:6);
epochRanges = OLepochs(2);
[n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, preTime, postTime, timeStep, rangeX);
h = pcolor(rangeT,rangeX,n);
set(h,'EdgeColor','none');
xlim([rangeT(1) rangeT(end)]);
ylim([rangeX(1) rangeX(end)]);
title('Box + EV P(angle|time)');
xlabel('Time');
set(gca,'YTick',[90 180 270 360]);
ylabel('Angle');

postTime = 120;
subplot(4,3,7:9);
epochRanges = OLepochs(3);
[n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, preTime, postTime, timeStep, rangeX);
h = pcolor(rangeT,rangeX,n);
set(h,'EdgeColor','none');
xlim([rangeT(1) rangeT(end)]);
ylim([rangeX(1) rangeX(end)]);
title('Box + Odor P(angle|time)');
xlabel('Time');
set(gca,'YTick',[90 180 270 360]);
ylabel('Angle');

postTime = 115;
epochRanges = OLepochs(1);
subplot(4,3,10); hold on;
[ns, rangeX] = accumulateMultiHistogram(fileList,epochRanges, preTime, postTime, rangeX);
ns = ns ./ (sum(ns(1,:))/nRangeX);
plotBands(rangeX,ns,'r');
for i=1:size(ns,1)
    plot(rangeX,ns(i,:));
end
ylim([0 maxY]);
xlim([rangeX(1) rangeX(end)]);
set(gca,'XTick',[90 270]);
set(gca,'YTick',[0 maxY]);
title('Vert. Bar P(angle)');

postTime = 120;
epochRanges = OLepochs(2);
subplot(4,3,11); hold on;
[ns, rangeX] = accumulateMultiHistogram(fileList,epochRanges, preTime, postTime, rangeX);
ns = ns ./ (sum(ns(1,:))/nRangeX);
plotBands(rangeX,ns,'r');
for i=1:size(ns,1)
    plot(rangeX,ns(i,:));
end
ylim([0 maxY]);
xlim([rangeX(1) rangeX(end)]);
set(gca,'XTick',[90 270]);
set(gca,'YTick',[0 maxY]);
title('Box + EV P(angle)');

postTime = 120;
epochRanges = OLepochs(3);
subplot(4,3,12); hold on;
[ns, rangeX] = accumulateMultiHistogram(fileList,epochRanges, preTime, postTime, rangeX);
ns = ns ./ (sum(ns(1,:))/nRangeX);
plotBands(rangeX,ns,'r');
for i=1:size(ns,1)
    plot(rangeX,ns(i,:));
end
ylim([0 maxY]);
xlim([rangeX(1) rangeX(end)]);
set(gca,'XTick',[90 270]);
set(gca,'YTick',[0 maxY]);
title('Box + Odor P(angle)');

bigTitle(['Experiment: ',experiment]);
codeStampFigure(gcf);

% %% Next generate phase space plots
% 
figList{2} = figure();
preTime = 0;
OLepochs = [1 12 13];

postTime = 115;
epochRanges = OLepochs(2);
subplot(3,3,1); hold on;
[n, rangeX, rangedX] = accumulatePhaseHistogram(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
h = pcolor(rangeX,rangedX,log(n'));
set(h,'EdgeColor','none');
xlim([rangeX(1) rangeX(end)]);
ylim([rangedX(1) rangedX(end)]);
xlabel('Angle (deg)');
ylabel('Speed (deg/sec)');
title('Vert. Bar log(P(angle,speed))');
plot2dFormat();

postTime = 120;
epochRanges = OLepochs(2);
subplot(3,3,2); hold on;
[n, rangeX, rangedX] = accumulatePhaseHistogram(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
h = pcolor(rangeX,rangedX,log(n'));
set(h,'EdgeColor','none');
xlim([rangeX(1) rangeX(end)]);
ylim([rangedX(1) rangedX(end)]);
xlabel('Angle (deg)');
ylabel('Speed (deg/sec)');
title('Box + EV log(P(angle,speed))');
plot2dFormat();


postTime = 120;
epochRanges = OLepochs(3);
subplot(3,3,3); hold on;
[n, rangeX, rangedX] = accumulatePhaseHistogram(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
h = pcolor(rangeX,rangedX,log(n'));
set(h,'EdgeColor','none');
xlim([rangeX(1) rangeX(end)]);
ylim([rangedX(1) rangedX(end)]);
xlabel('Angle (deg)');
ylabel('Speed (deg/sec)');
title('Box + Odor log(P(angle,speed))');
plot2dFormat();

%


postTime = 115;
epochRanges = OLepochs(1);
subplot(3,3,4);hold on;
[means, n, rangeX, rangedX] = accumulatePhaseMeans(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
epochMeans{1} = means;
epochNs{1} = n;
h = pcolor(rangeX,rangedX,means');
set(h,'EdgeColor','none');
xlim([rangeX(1) rangeX(end)]);
ylim([rangedX(1) rangedX(end)]);
caxis([ranged2X(1) ranged2X(end)]);
xlabel('Angle (deg)');
ylabel('Speed (deg/sec)');
title('Vert. Bar <dWBA/dt(angle,speed)>');
plot2dFormat();


postTime = 120;
epochRanges = OLepochs(2);
subplot(3,3,5);hold on;
[means, n, rangeX, rangedX] = accumulatePhaseMeans(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
epochMeans{2} = means;
epochNs{2} = n;
h = pcolor(rangeX,rangedX,means');
set(h,'EdgeColor','none');
xlim([rangeX(1) rangeX(end)]);
ylim([rangedX(1) rangedX(end)]);
caxis([ranged2X(1) ranged2X(end)]);
xlabel('Angle (deg)');
ylabel('Speed (deg/sec)');
title('Box + EV <dWBA/dt(angle,speed)>');
plot2dFormat();


postTime = 120;
epochRanges = OLepochs(3);
subplot(3,3,6);hold on;
[means, n, rangeX, rangedX] = accumulatePhaseMeans(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
epochMeans{3} = means;
epochNs{3} = n;
h = pcolor(rangeX,rangedX,means');
set(h,'EdgeColor','none');
xlim([rangeX(1) rangeX(end)]);
ylim([rangedX(1) rangedX(end)]);
caxis([ranged2X(1) ranged2X(end)]);
xlabel('Angle (deg)');
ylabel('Speed (deg/sec)');
title('Box + Odor <dWBA/dt(angle,speed)>');
plot2dFormat();

%

postTime = 115;
epochRanges = OLepochs(1);
subplot(3,3,7); hold on;
modelFun = fitModel(epochMeans{1}, epochNs{1}, rangeX, rangedX);
epochModels{1} = modelFun;
[X,dX] = meshgrid(rangeX,rangedX);
responses = modelFun(X,dX);
h = pcolor(rangeX,rangedX,responses);
xlim([rangeX(1) rangeX(end)]);
ylim([rangedX(1) rangedX(end)]);
caxis([ranged2X(1) ranged2X(end)]);
set(h,'EdgeColor','none');
set(h,'ButtonDownFcn',{@plotTrajectory,modelFun});
plot2dFormat();
title('Vert. Bar Model <dWBA/dt>');

postTime = 120;
epochRanges = OLepochs(2);
subplot(3,3,8); hold on;
modelFun = fitModel(epochMeans{2}, epochNs{2}, rangeX, rangedX);
epochModels{2} = modelFun;
[X,dX] = meshgrid(rangeX,rangedX);
responses = modelFun(X,dX);
h = pcolor(rangeX,rangedX,responses);
xlim([rangeX(1) rangeX(end)]);
ylim([rangedX(1) rangedX(end)]);
caxis([ranged2X(1) ranged2X(end)]);
set(h,'EdgeColor','none');
set(h,'ButtonDownFcn',{@plotTrajectory,modelFun});
plot2dFormat();
title('Box + EV Model <dWBA/dt>');

postTime = 120;
epochRanges = OLepochs(3);
subplot(3,3,9); hold on;
modelFun = fitModel(epochMeans{3}, epochNs{3}, rangeX, rangedX);
epochModels{3} = modelFun;
[X,dX] = meshgrid(rangeX,rangedX);
responses = modelFun(X,dX);
h = pcolor(rangeX,rangedX,responses);
xlim([rangeX(1) rangeX(end)]);
ylim([rangedX(1) rangedX(end)]);
caxis([ranged2X(1) ranged2X(end)]);
set(h,'EdgeColor','none');
set(h,'ButtonDownFcn',{@plotTrajectory,modelFun});
plot2dFormat();
title('Box + Odor Model <dWBA/dt>');

bigTitle(['Experiment: ',experiment]);
codeStampFigure(gcf);
% 
% %% OL Time Domain Plots
% 
% figList{3} = figure();
% 
% EVepochList = 2:11;
% preTime = 0;
% postTime = 10;
% 
% for nEpoch = 1:10;
%     preTime = -2;
%     postTime = 11;
%     epochRanges = EVepochList(nEpoch);
%     subplot(10,2,(nEpoch - 1)*2 + 1); hold on;
%     [traces, timeTrace] = accumulateWBATraces(fileList,epochRanges, preTime, postTime);
%     plotBands(timeTrace,traces,'b');
%     xlim([timeTrace(1) timeTrace(end)]);
%     ylim([-300 300]);
% end
% subplot(10,2,1); title('EV');
% subplot(10,2,11); ylabel('WBA (cV)');
% subplot(10,2,19); xlabel('Time (sec)');
% 
% odorEpochList = 14:23;
% for nEpoch = 1:10;
%     preTime = -2;
%     postTime = 11;
%     epochRanges = odorEpochList(nEpoch);
%     subplot(10,2,(nEpoch - 1)*2 + 2); hold on;
%     [traces, timeTrace] = accumulateWBATraces(fileList,epochRanges, preTime, postTime);
%     plotBands(timeTrace,traces,'b');
%     xlim([timeTrace(1) timeTrace(end)]);
%     ylim([-300 300]);
% end
% subplot(10,2,2); title('Odor');
% subplot(10,2,12); ylabel('WBA (cV)');
% subplot(10,2,20); xlabel('Time (sec)');
% 
% bigTitle(['Experiment: ',experiment]);
% codeStampFigure(gcf);
% 
% %% OL Time Domain Plots
% 
% figList{4} = figure();
% 
% EVepochList = 2:11;
% preTime = 0;
% postTime = 10;
% 
% for nEpoch = 1:10;
%     preTime = -2;
%     postTime = 11;
%     epochRanges = EVepochList(nEpoch);
%     subplot(10,2,(nEpoch - 1)*2 + 1); hold on;
%     [traces, timeTrace] = accumulatedWBATraces(fileList,epochRanges, preTime, postTime);
%     plotBands(timeTrace,traces,'b');
%     xlim([timeTrace(1) timeTrace(end)]);
%     ylim([-300 300]);
% end
% subplot(10,2,1); title('EV');
% subplot(10,2,11); ylabel('dWBA (cV/sec)');
% subplot(10,2,19); xlabel('Time (sec)');
% 
% odorEpochList = 14:23;
% for nEpoch = 1:10;
%     preTime = -2;
%     postTime = 11;
%     epochRanges = odorEpochList(nEpoch);
%     subplot(10,2,(nEpoch - 1)*2 + 2); hold on;
%     [traces, timeTrace] = accumulatedWBATraces(fileList,epochRanges, preTime, postTime);
%     plotBands(timeTrace,traces,'b');
%     xlim([timeTrace(1) timeTrace(end)]);
%     ylim([-300 300]);
% end
% subplot(10,2,2); title('Odor');
% subplot(10,2,12); ylabel('dWBA (cV/sec)');
% subplot(10,2,20); xlabel('Time (sec)');
% 
% bigTitle(['Experiment: ',experiment]);
% codeStampFigure(gcf);
% 
% %% Generate OL-CL model comparisons
% 
% figList{5} = figure();
% subplot(10,4,1);
% preTime = 0;
% postTime = 10;
% 
% epochList = 2:11;
% for epochN = 1:10
%     epochRanges = epochList(epochN);
%     subplot(10,4, 4*(epochN-1) + 1); hold on;
%     
%     [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
%     plotBands(rangeX,dWBAtraces,'b');
%     % for i=1:size(WBAtraces,1)
%     %     plot(rangeX,dWBAtraces(i,:));
%     % end
%     xlim([rangeX(1) rangeX(end)]);
%     ylim([-500 500]);
%     set(gca,'XTick',[90 270]);
%     line(xlim(),[0 0],'Color','k');
%     line([90 90],ylim(),'Color','k');
%     line([270 270],ylim(),'Color','k');
% end
% subplot(10,4,1); title('EV Data');
% subplot(10,4,4*5 + 1); ylabel('dWBA/dt (cV)');
% 
% epochList = 14:23;
% for epochN = 1:10
%     epochRanges = epochList(epochN);
%     subplot(10,4, 4*(epochN-1) + 2); hold on;
%     
%     [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
%     plotBands(rangeX,dWBAtraces,'r');
%     % for i=1:size(WBAtraces,1)
%     %     plot(rangeX,dWBAtraces(i,:));
%     % end
%     xlim([rangeX(1) rangeX(end)]);
%     ylim([-500 500]);
%     set(gca,'XTick',[90 270]);
%     line(xlim(),[0 0],'Color','k');
%     line([90 90],ylim(),'Color','k');
%     line([270 270],ylim(),'Color','k');
% end
% subplot(10,4,2); title('Odor Data');
% subplot(10,4,4*5 + 3); ylabel('dWBA/dt (cV)');
% 
% spinVals = [720 540 360 180 90 -90 -180 -360 -540 -720];
% for epochN = 1:10
%     subplot(10,4, 4*(epochN-1) + 3); hold on;
%     spins = ones(1,size(rangeX,2)) .* spinVals(epochN);
%     evModel = epochModels{2};
%     evResp = evModel(rangeX,spins);
%     plot(rangeX,evResp,'Color','b','LineWidth',1);
%     xlim([rangeX(1) rangeX(end)]);
%     ylim([-500 500]);
%     set(gca,'XTick',[90 270]);
%     line(xlim(),[0 0],'Color','k');
%     line([90 90],ylim(),'Color','k');
%     line([270 270],ylim(),'Color','k');
% end
% subplot(10,4,3); title('EV Model');
% subplot(10,4,4*5 + 3); ylabel('dWBA/dt (cV)');
% 
% spinVals = [720 540 360 180 90 -90 -180 -360 -540 -720];
% for epochN = 1:10
%     subplot(10,4, 4*(epochN-1) + 4); hold on;
%     spins = ones(1,size(rangeX,2)) .* spinVals(epochN);
%     evModel = epochModels{3};
%     evResp = evModel(rangeX,spins);
%     plot(rangeX,evResp,'Color','r','LineWidth',1);
%     xlim([rangeX(1) rangeX(end)]);
%     ylim([-500 500]);
%     set(gca,'XTick',[90 270]);
%     line(xlim(),[0 0],'Color','k');
%     line([90 90],ylim(),'Color','k');
%     line([270 270],ylim(),'Color','k');
% end
% subplot(10,4,4); title('Odor Model');
% subplot(10,4,4*5 + 4); ylabel('dWBA/dt (cV)');
% 
% bigTitle(['Experiment: ',experiment]);
% codeStampFigure(gcf);
% 
% %%
% 
% figList{6} = figure();
% 
% subplot(10,4,1);
% preTime = 0;
% postTime = 10;
% 
% epochList = 2:11;
% for epochN = 1:10
%     epochRanges = epochList(epochN);
%     subplot(10,4, 4*(epochN-1) + 1); hold on;
%     
%     [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
%     %plotBands(rangeX,dWBAtraces,'b');
%     for i=1:size(WBAtraces,1)
%         plot(rangeX,dWBAtraces(i,:),'b');
%     end
%     xlim([rangeX(1) rangeX(end)]);
%     ylim([-500 500]);
%     set(gca,'XTick',[90 270]);
%     line(xlim(),[0 0],'Color','k');
%     line([90 90],ylim(),'Color','k');
%     line([270 270],ylim(),'Color','k');
% end
% subplot(10,4,1); title('EV Data');
% subplot(10,4,4*5 + 1); ylabel('dWBA/dt (cV/sec)');
% 
% epochList = 14:23;
% for epochN = 1:10
%     epochRanges = epochList(epochN);
%     subplot(10,4, 4*(epochN-1) + 2); hold on;
%     
%     [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
%     %plotBands(rangeX,dWBAtraces,'r');
%     for i=1:size(WBAtraces,1)
%         plot(rangeX,dWBAtraces(i,:),'r');
%     end
%     xlim([rangeX(1) rangeX(end)]);
%     ylim([-500 500]);
%     set(gca,'XTick',[90 270]);
%     line(xlim(),[0 0],'Color','k');
%     line([90 90],ylim(),'Color','k');
%     line([270 270],ylim(),'Color','k');
% end
% subplot(10,4,2); title('Odor Data');
% subplot(10,4,4*5 + 2); ylabel('dWBA/dt (cV/sec)');
% 
% epochList = 2:11;
% for epochN = 1:10
%     epochRanges = epochList(epochN);
%     subplot(10,4, 4*(epochN-1) + 3); hold on;
%     
%     [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
%     %plotBands(rangeX,dWBAtraces,'b');
%     for i=1:size(WBAtraces,1)
%         plot(rangeX,WBAtraces(i,:),'b');
%     end
%     xlim([rangeX(1) rangeX(end)]);
%     ylim([-500 500]);
%     set(gca,'XTick',[90 270]);
%     line(xlim(),[0 0],'Color','k');
%     line([90 90],ylim(),'Color','k');
%     line([270 270],ylim(),'Color','k');
% end
% subplot(10,4,3); title('EV Data');
% subplot(10,4,4*5 + 3); ylabel('WBA (cV)');
% 
% epochList = 14:23;
% for epochN = 1:10
%     epochRanges = epochList(epochN);
%     subplot(10,4, 4*(epochN-1) + 4); hold on;
%     
%     [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
%     %plotBands(rangeX,dWBAtraces,'r');
%     for i=1:size(WBAtraces,1)
%         plot(rangeX,WBAtraces(i,:),'r');
%     end
%     xlim([rangeX(1) rangeX(end)]);
%     ylim([-500 500]);
%     set(gca,'XTick',[90 270]);
%     line(xlim(),[0 0],'Color','k');
%     line([90 90],ylim(),'Color','k');
%     line([270 270],ylim(),'Color','k');
% end
% subplot(10,4,4); title('Odor Data');
% subplot(10,4,4*5 + 4); ylabel('WBA (cV)');
% 
% bigTitle(['Experiment: ',experiment]);
% codeStampFigure(gcf);

%% Save figs!
pause();
saveMultiPage(figList,experiment);