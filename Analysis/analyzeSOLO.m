%%
function analyzeSOLO(experiment)

fileList = returnFileList(experiment);

%% Histogram ranges
rangeX = 3.75:3.75:360;
rangedX = -1080:7.5:1080;
ranged2X = -300:4:300;
timeStep = 2;

timeSeriesFig = figure();


subplot(6,6,1:5); hold on;
epochRanges = 1; preTime = 0; postTime = 599;
[n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, preTime, postTime, timeStep, rangeX);
h = pcolor(rangeT,rangeX,n);
set(h,'EdgeColor','none');
xlim([rangeT(1) rangeT(end)]);
ylim([rangeX(1) rangeX(end)]);
title('Vert. Stripe P(angle|time)');
set(gca,'YTick',[90 180 270 360]);
ylabel('Angle');

subplot(6,6,6); hold on;
[ns, rangeX] = accumulateMultiHistogram(fileList,epochRanges, preTime, postTime, rangeX);
plotBands(rangeX,ns,'r');
for i=1:size(ns,1)
    plot(rangeX,ns(i,:));
end
xlim([rangeX(1) rangeX(end)]);
line([90 90],ylim(),'Color','k');
line([270 270],ylim(),'Color','k');
set(gca,'XTick',[90 270]);
set(gca,'YTick',[]);
title('Vert. Bar P(angle)');

for epoch = 2:6
    subplot(6,6,((epoch-1)*6 + 1):((epoch-1)*6 + 5)); hold on;
    epochRanges = epoch; preTime = 0; postTime = 120;
    [n, rangeX, rangeT] = accumulate2DHistogram(fileList,epochRanges, preTime, postTime, timeStep, rangeX);
    h = pcolor(rangeT,rangeX,n);
    set(h,'EdgeColor','none');
    xlim([rangeT(1) rangeT(end)]);
    ylim([rangeX(1) rangeX(end)]);
    set(gca,'YTick',[90 180 270 360]);
    ylabel('Angle');
    
    
    
    subplot(6,6,(epoch-1)*6 + 6); hold on;
    [ns, rangeX] = accumulateMultiHistogram(fileList,epochRanges, preTime, postTime, rangeX);
    plotBands(rangeX,ns,'r');
    for i=1:size(ns,1)
        plot(rangeX,ns(i,:));
    end
    xlim([rangeX(1) rangeX(end)]);
    line([90 90],ylim(),'Color','k');
    line([270 270],ylim(),'Color','k');
    set(gca,'XTick',[90 270]);
    set(gca,'YTick',[]);
    
end
