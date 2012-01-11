function analyzePOLBS(experiment)

fileList = returnFileList(experiment);

%% Histogram ranges
rangeX = 3.75:3.75:360;
rangedX = -1080:7.5:1080;
ranged2X = -300:4:300;

% %% First generate OL plots
% OLepochs = [1 12 13];
% 
% OLTimeFig = figure();
% preTime = 0;
% timeStep = 1;
% 
% postTime = 115;
% subplot(4,3,1:3);
% epochRanges = OLepochs(1);
% [n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, preTime, postTime, timeStep, rangeX);
% h = pcolor(rangeT,rangeX,n);
% set(h,'EdgeColor','none');
% xlim([rangeT(1) rangeT(end)]);
% ylim([rangeX(1) rangeX(end)]);
% title('Vert. Stripe P(angle|time)');
% xlabel('Time');
% set(gca,'YTick',[90 180 270 360]);
% ylabel('Angle');
% 
% postTime = 120;
% subplot(4,3,4:6);
% epochRanges = OLepochs(2);
% [n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, preTime, postTime, timeStep, rangeX);
% h = pcolor(rangeT,rangeX,n);
% set(h,'EdgeColor','none');
% xlim([rangeT(1) rangeT(end)]);
% ylim([rangeX(1) rangeX(end)]);
% title('Box + EV P(angle|time)');
% xlabel('Time');
% set(gca,'YTick',[90 180 270 360]);
% ylabel('Angle');
% 
% postTime = 120;
% subplot(4,3,7:9);
% epochRanges = OLepochs(3);
% [n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, preTime, postTime, timeStep, rangeX);
% h = pcolor(rangeT,rangeX,n);
% set(h,'EdgeColor','none');
% xlim([rangeT(1) rangeT(end)]);
% ylim([rangeX(1) rangeX(end)]);
% title('Box + Odor P(angle|time)');
% xlabel('Time');
% set(gca,'YTick',[90 180 270 360]);
% ylabel('Angle');
% 
% postTime = 115;
% epochRanges = OLepochs(1);
% subplot(4,3,10); hold on;
% [ns, rangeX] = accumulateMultiHistogram(fileList,epochRanges, preTime, postTime, rangeX);
% plotBands(rangeX,ns,'r');
% for i=1:size(ns,1)
%     plot(rangeX,ns(i,:));
% end
% xlim([rangeX(1) rangeX(end)]);
% set(gca,'XTick',[90 270]);
% set(gca,'YTick',[]);
% title('Vert. Bar P(angle)');
% 
% postTime = 120;
% epochRanges = OLepochs(2);
% subplot(4,3,11); hold on;
% [ns, rangeX] = accumulateMultiHistogram(fileList,epochRanges, preTime, postTime, rangeX);
% plotBands(rangeX,ns,'r');
% for i=1:size(ns,1)
%     plot(rangeX,ns(i,:));
% end
% xlim([rangeX(1) rangeX(end)]);
% set(gca,'XTick',[90 270]);
% set(gca,'YTick',[]);
% title('Box + EV P(angle)');
% 
% postTime = 120;
% epochRanges = OLepochs(3);
% subplot(4,3,12); hold on;
% [ns, rangeX] = accumulateMultiHistogram(fileList,epochRanges, preTime, postTime, rangeX);
% plotBands(rangeX,ns,'r');
% for i=1:size(ns,1)
%     plot(rangeX,ns(i,:));
% end
% xlim([rangeX(1) rangeX(end)]);
% set(gca,'XTick',[90 270]);
% set(gca,'YTick',[]);
% title('Box + Odor P(angle)');
% 
% bigTitle(['Experiment: ',experiment]);
% codeStampFigure(gcf);
% 
% %% Next generate phase space plots
% 
% phaseSpaceFig = figure();
% preTime = 0;
% OLepochs = [1 12 13];
% 
% postTime = 115;
% epochRanges = OLepochs(1);
% subplot(3,3,1); hold on;
% [n, rangeX, rangedX] = accumulatePhaseHistogram(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
% h = pcolor(rangeX,rangedX,log(n'));
% set(h,'EdgeColor','none');
% xlim([rangeX(1) rangeX(end)]);
% ylim([rangedX(1) rangedX(end)]);
% xlabel('Angle (deg)');
% ylabel('Speed (deg/sec)');
% title('Vert. Bar log(P(angle,speed))');
% plot2dFormat();
% 
% postTime = 120;
% epochRanges = OLepochs(2);
% subplot(3,3,2); hold on;
% [n, rangeX, rangedX] = accumulatePhaseHistogram(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
% h = pcolor(rangeX,rangedX,log(n'));
% set(h,'EdgeColor','none');
% xlim([rangeX(1) rangeX(end)]);
% ylim([rangedX(1) rangedX(end)]);
% xlabel('Angle (deg)');
% ylabel('Speed (deg/sec)');
% title('Box + EV log(P(angle,speed))');
% plot2dFormat();
% 
% postTime = 120;
% epochRanges = OLepochs(3);
% subplot(3,3,3); hold on;
% [n, rangeX, rangedX] = accumulatePhaseHistogram(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
% h = pcolor(rangeX,rangedX,log(n'));
% set(h,'EdgeColor','none');
% xlim([rangeX(1) rangeX(end)]);
% ylim([rangedX(1) rangedX(end)]);
% xlabel('Angle (deg)');
% ylabel('Speed (deg/sec)');
% title('Box + Odor log(P(angle,speed))');
% plot2dFormat();
% 
% postTime = 115;
% epochRanges = OLepochs(1);
% subplot(3,3,4);hold on;
% [means, n, rangeX, rangedX] = accumulatePhaseMeans(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
% epochMeans{1} = means;
% epochNs{1} = n;
% h = pcolor(rangeX,rangedX,means');
% set(h,'EdgeColor','none');
% xlim([rangeX(1) rangeX(end)]);
% ylim([rangedX(1) rangedX(end)]);
% caxis([ranged2X(1) ranged2X(end)]);
% xlabel('Angle (deg)');
% ylabel('Speed (deg/sec)');
% title('Vert. Bar <dWBA/dt(angle,speed)>');
% plot2dFormat();
% 
% postTime = 120;
% epochRanges = OLepochs(2);
% subplot(3,3,5);hold on;
% [means, n, rangeX, rangedX] = accumulatePhaseMeans(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
% epochMeans{2} = means;
% epochNs{2} = n;
% h = pcolor(rangeX,rangedX,means');
% set(h,'EdgeColor','none');
% xlim([rangeX(1) rangeX(end)]);
% ylim([rangedX(1) rangedX(end)]);
% caxis([ranged2X(1) ranged2X(end)]);
% xlabel('Angle (deg)');
% ylabel('Speed (deg/sec)');
% title('Box + EV <dWBA/dt(angle,speed)>');
% plot2dFormat();
% 
% postTime = 120;
% epochRanges = OLepochs(3);
% subplot(3,3,6);hold on;
% [means, n, rangeX, rangedX] = accumulatePhaseMeans(fileList,epochRanges, preTime, postTime, rangeX, rangedX);
% epochMeans{3} = means;
% epochNs{3} = n;
% h = pcolor(rangeX,rangedX,means');
% set(h,'EdgeColor','none');
% xlim([rangeX(1) rangeX(end)]);
% ylim([rangedX(1) rangedX(end)]);
% caxis([ranged2X(1) ranged2X(end)]);
% title('Box + Odor <dWBA/dt(angle,speed)>');
% plot2dFormat();
% 
% postTime = 115;
% epochRanges = OLepochs(1);
% subplot(3,3,7); hold on;
% modelFun = fitModel(epochMeans{1}, epochNs{1}, rangeX, rangedX);
% epochModels{1} = modelFun;
% h = plot(modelFun,'Style','Contour','XLim',[rangeX(1) rangeX(end)],'YLim',[rangedX(1) rangedX(end)]);
% set(h,'EdgeColor','none');
% levelList = ranged2X(1):(ranged2X(end)-ranged2X(1))/20:ranged2X(end);
% set(h,'LevelList',levelList);
% set(h,'ButtonDownFcn',{@plotTrajectory,modelFun});
% plot2dFormat();
% title('Vert. Bar Model <dWBA/dt>');
% 
% postTime = 120;
% epochRanges = OLepochs(2);
% subplot(3,3,8); hold on;
% modelFun = fitModel(epochMeans{2}, epochNs{2}, rangeX, rangedX);
% epochModels{2} = modelFun;
% h = plot(modelFun,'Style','Contour','XLim',[rangeX(1) rangeX(end)],'YLim',[rangedX(1) rangedX(end)]);
% set(h,'EdgeColor','none');
% levelList = ranged2X(1):(ranged2X(end)-ranged2X(1))/20:ranged2X(end);
% set(h,'LevelList',levelList);
% set(h,'ButtonDownFcn',{@plotTrajectory,modelFun});
% plot2dFormat();
% title('Box + EV Model <dWBA/dt>');
% 
% postTime = 120;
% epochRanges = OLepochs(3);
% subplot(3,3,9); hold on;
% modelFun = fitModel(epochMeans{3}, epochNs{3}, rangeX, rangedX);
% epochModels{3} = modelFun;
% h = plot(modelFun,'Style','Contour','XLim',[rangeX(1) rangeX(end)],'YLim',[rangedX(1) rangedX(end)]);
% set(h,'EdgeColor','none');
% levelList = ranged2X(1):(ranged2X(end)-ranged2X(1))/20:ranged2X(end);
% set(h,'LevelList',levelList);
% set(h,'ButtonDownFcn',{@plotTrajectory,modelFun});
% plot2dFormat();
% title('Box + Odor Model <dWBA/dt>');
% 
% bigTitle(['Experiment: ',experiment]);
% codeStampFigure(gcf);

%% OL Time Domain Plots

OLTimeDomain = figure();

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

%% OL Time Domain Plots

OLTimeDomainDWBA = figure();

EVepochList = 2:11;
preTime = 0;
postTime = 10;

for nEpoch = 1:10;
    preTime = -2;
    postTime = 11;
    epochRanges = EVepochList(nEpoch);
    subplot(10,2,(nEpoch - 1)*2 + 1); hold on;
    [traces, timeTrace] = accumulatedWBATraces(fileList,epochRanges, preTime, postTime);
    plotBands(timeTrace,traces,'b');
    xlim([timeTrace(1) timeTrace(end)]);
    ylim([-300 300]);
end
subplot(10,2,1); title('EV');
subplot(10,2,11); ylabel('dWBA (cV/sec)');
subplot(10,2,19); xlabel('Time (sec)');

odorEpochList = 14:23;
for nEpoch = 1:10;
    preTime = -2;
    postTime = 11;
    epochRanges = odorEpochList(nEpoch);
    subplot(10,2,(nEpoch - 1)*2 + 2); hold on;
    [traces, timeTrace] = accumulatedWBATraces(fileList,epochRanges, preTime, postTime);
    plotBands(timeTrace,traces,'b');
    xlim([timeTrace(1) timeTrace(end)]);
    ylim([-300 300]);
end
subplot(10,2,2); title('Odor');
subplot(10,2,12); ylabel('dWBA (cV/sec)');
subplot(10,2,20); xlabel('Time (sec)');

bigTitle(['Experiment: ',experiment]);
codeStampFigure(gcf);