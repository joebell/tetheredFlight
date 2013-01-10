function rosePOLBS(experiment)

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

%% Generate OL-CL model comparisons

figList{3} = figure();

subplot(6,2,1); hold on;
preTime = 0;
postTime = 10;
useEpochs = [2,9,3,8,5,6];
spaceFactor = 600;

epochList = 2:11;
for nEpoch = useEpochs
    epochRanges = epochList(nEpoch);
 
    [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
    size(dWBAtraces)
    subplot(1,4,1); hold on;
    plotBands(rangeX,dWBAtraces - spaceFactor*nEpoch,'b');
    subplot(1,4,3); hold on;
    plotBands(rangeX,dWBAtraces - spaceFactor*nEpoch,'b');
end
epochList = 14:23;
for nEpoch = useEpochs
    epochRanges = epochList(nEpoch);
 
    [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
    subplot(1,4,1); hold on;
    plotBands(rangeX,dWBAtraces - spaceFactor*nEpoch,'r');
    subplot(1,4,4); hold on;
    plotBands(rangeX,dWBAtraces - spaceFactor*nEpoch,'r');
    subplot(1,4,1); hold on;
    line([rangeX(1) rangeX(end)],[-nEpoch*spaceFactor -nEpoch*spaceFactor],'Color','k'); 
end
maxSpan = -(nEpoch+1)*spaceFactor;
xlim([rangeX(1) rangeX(end)]); 
ylim([maxSpan 0]);
set(gca,'YTick',[]);
set(gca,'XTick',[90 270]);
line([90 90], ylim(),'Color','k');
line([270 270], ylim(),'Color','k');
bottomBlock = 31*maxSpan/32;
fill([15 20 20 15],[bottomBlock bottomBlock bottomBlock+spaceFactor bottomBlock+spaceFactor],'k');
text(25, bottomBlock, '600 cV/sec','VerticalAlignment','baseline')
subplot(1,4,1); title('\color{blue} EV Data \color{black}+ \color{red}Odor Data');
subplot(1,4,1); ylabel('dWBA/dt (cV/sec)');
subplot(1,4,1); xlabel('Angle (deg)');

subplot(1,4,2); hold on;
preTime = 0;
postTime = 10;
spaceFactor = 600;

spinVals = [720 540 360 180 90 -90 -180 -360 -540 -720];
for nEpoch = useEpochs
    spins = ones(1,size(rangeX,2)) .* spinVals(nEpoch);
    evModel = epochModels{2};
    evResp = evModel(rangeX,spins);
    subplot(1,4,2); hold on;
    plot(rangeX,evResp - spaceFactor*nEpoch,'Color','c','LineWidth',2);
    subplot(1,4,3); hold on;
    plot(rangeX,evResp - spaceFactor*nEpoch,'Color','c','LineWidth',2);
    odorModel = epochModels{3};
    odorResp = odorModel(rangeX,spins);
    subplot(1,4,2); hold on;
    plot(rangeX,odorResp - spaceFactor*nEpoch,'Color','m','LineWidth',2);
    subplot(1,4,4); hold on;
    plot(rangeX,odorResp - spaceFactor*nEpoch,'Color','m','LineWidth',2);
    line([rangeX(1) rangeX(end)],[-nEpoch*spaceFactor -nEpoch*spaceFactor],'Color','k'); 
    subplot(1,4,3); hold on;
    line([rangeX(1) rangeX(end)],[-nEpoch*spaceFactor -nEpoch*spaceFactor],'Color','k'); 
    subplot(1,4,2); hold on;
    line([rangeX(1) rangeX(end)],[-nEpoch*spaceFactor -nEpoch*spaceFactor],'Color','k'); 
end
maxSpan = -(nEpoch+1)*spaceFactor;
xlim([rangeX(1) rangeX(end)]); 
ylim([maxSpan 0]);
set(gca,'YTick',[]);
set(gca,'XTick',[90 270]);
line([90 90], ylim(),'Color','k');
line([270 270], ylim(),'Color','k');
bottomBlock = 31*maxSpan/32;
fill([15 20 20 15],[bottomBlock bottomBlock bottomBlock+spaceFactor bottomBlock+spaceFactor],'k');
text(25, bottomBlock, '600 cV/sec','VerticalAlignment','baseline')
subplot(1,4,2); title('\color{cyan} EV Model \color{black}+ \color{magenta}Odor Model');
subplot(1,4,2); ylabel('dWBA/dt (cV/sec)');
subplot(1,4,2); xlabel('Angle (deg)');

subplot(1,4,3); hold on;
maxSpan = -(nEpoch+1)*spaceFactor;
xlim([rangeX(1) rangeX(end)]); 
ylim([maxSpan 0]);
set(gca,'YTick',[]);
set(gca,'XTick',[90 270]);
line([90 90], ylim(),'Color','k');
line([270 270], ylim(),'Color','k');
bottomBlock = 31*maxSpan/32;
fill([15 20 20 15],[bottomBlock bottomBlock bottomBlock+spaceFactor bottomBlock+spaceFactor],'k');
text(25, bottomBlock, '600 cV/sec','VerticalAlignment','baseline')
title('\color{blue} EV Data \color{black}+ \color{cyan}EV Model');
ylabel('dWBA/dt (cV/sec)');
xlabel('Angle (deg)');

subplot(1,4,4); hold on;
maxSpan = -(nEpoch+1)*spaceFactor;
xlim([rangeX(1) rangeX(end)]); 
ylim([maxSpan 0]);
set(gca,'YTick',[]);
set(gca,'XTick',[90 270]);
line([90 90], ylim(),'Color','k');
line([270 270], ylim(),'Color','k');
bottomBlock = 31*maxSpan/32;
fill([15 20 20 15],[bottomBlock bottomBlock bottomBlock+spaceFactor bottomBlock+spaceFactor],'k');
text(25, bottomBlock, '600 cV/sec','VerticalAlignment','baseline')
title('\color{red} Odor Data \color{black}+ \color{magenta}Odor Model');
ylabel('dWBA/dt (cV/sec)');
xlabel('Angle (deg)');

bigTitle(['Experiment: ',experiment]);
codeStampFigure(gcf);
