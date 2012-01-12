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
