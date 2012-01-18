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

figure();

subplot(1,4,1); hold on;
preTime = 0;
postTime = 10;
spaceFactor = 600;

epochList = 2:11;
for nEpoch = 1:10
    epochRanges = epochList(nEpoch);
 
    [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
    subplot(1,4,1); hold on;
    plotBands(rangeX,dWBAtraces - spaceFactor*nEpoch,'b');
    subplot(1,4,3); hold on;
    plotBands(rangeX,dWBAtraces - spaceFactor*nEpoch,'b');
end
epochList = 14:23;
for nEpoch = 1:10
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
for nEpoch = 1:10
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



