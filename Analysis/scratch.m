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

% %%
% 
% figList{2} = figure();
% preTime = 0;
% OLepochs = [1 12 13];
% 
% postTime = 115;
% epochRanges = OLepochs(2);
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
% %
% 
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
% xlabel('Angle (deg)');
% ylabel('Speed (deg/sec)');
% title('Box + Odor <dWBA/dt(angle,speed)>');
% plot2dFormat();
% 
% %
% 
% postTime = 115;
% epochRanges = OLepochs(1);
% subplot(3,3,7); hold on;
% modelFun = fitModel(epochMeans{1}, epochNs{1}, rangeX, rangedX);
% epochModels{1} = modelFun;
% [X,dX] = meshgrid(rangeX,rangedX);
% responses = modelFun(X,dX);
% h = pcolor(rangeX,rangedX,responses);
% xlim([rangeX(1) rangeX(end)]);
% ylim([rangedX(1) rangedX(end)]);
% caxis([ranged2X(1) ranged2X(end)]);
% set(h,'EdgeColor','none');
% set(h,'ButtonDownFcn',{@plotTrajectory,modelFun});
% plot2dFormat();
% title('Vert. Bar Model <dWBA/dt>');
% 
% postTime = 120;
% epochRanges = OLepochs(2);
% subplot(3,3,8); hold on;
% modelFun = fitModel(epochMeans{2}, epochNs{2}, rangeX, rangedX);
% epochModels{2} = modelFun;
% [X,dX] = meshgrid(rangeX,rangedX);
% responses = modelFun(X,dX);
% h = pcolor(rangeX,rangedX,responses);
% xlim([rangeX(1) rangeX(end)]);
% ylim([rangedX(1) rangedX(end)]);
% caxis([ranged2X(1) ranged2X(end)]);
% set(h,'EdgeColor','none');
% set(h,'ButtonDownFcn',{@plotTrajectory,modelFun});
% plot2dFormat();
% title('Box + EV Model <dWBA/dt>');
% 
% postTime = 120;
% epochRanges = OLepochs(3);
% subplot(3,3,9); hold on;
% modelFun = fitModel(epochMeans{3}, epochNs{3}, rangeX, rangedX);
% epochModels{3} = modelFun;
% [X,dX] = meshgrid(rangeX,rangedX);
% responses = modelFun(X,dX);
% h = pcolor(rangeX,rangedX,responses);
% xlim([rangeX(1) rangeX(end)]);
% ylim([rangedX(1) rangedX(end)]);
% caxis([ranged2X(1) ranged2X(end)]);
% set(h,'EdgeColor','none');
% set(h,'ButtonDownFcn',{@plotTrajectory,modelFun});
% plot2dFormat();
% title('Box + Odor Model <dWBA/dt>');
% 
% bigTitle(['Experiment: ',experiment]);
% codeStampFigure(gcf);

subplot(1,4,1);
preTime = 0;
postTime = 10;

     epochList = 2:11;
     epochRanges = epochList(epochN);
     [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
     plotBands(rangeX,dWBAtraces,'b');
     % for i=1:size(WBAtraces,1)
     %     plot(rangeX,dWBAtraces(i,:));
     % end




spaceFactor = 600;
spinVals = [720 540 360 180 90 -90 -180 -360 -540 -720];

subplot(1,4,1); hold on;
for epochN = 1:10
     epochList = 2:11;
     epochRanges = epochList(epochN);
     [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
     plotBands(rangeX,dWBAtraces - epochN*spaceFactor,'b');
     % for i=1:size(WBAtraces,1)
     %     plot(rangeX,dWBAtraces(i,:) - epochN*spaceFactor);
     % end
    line([rangeX(1) rangeX(end)],[-epochN*spaceFactor -epochN*spaceFactor],'Color','k');
end
set(gca,'XTick',[90 270]);
set(gca,'YTick',[]);
title('EV Data');
maxSpan = -(epochN+1)*spaceFactor;
ylim([maxSpan 0]);
set(gca,'YTick',[]);
bottomBlock = 31*maxSpan/32;
fill([30 35 35 30],[bottomBlock bottomBlock bottomBlock+spaceFactor bottomBlock+spaceFactor],'k');
text(40, bottomBlock, ' 800 cV/sec','VerticalAlignment','baseline')
xlim([rangeX(1) rangeX(end)]);
xlabel('Angle (deg.)');
ylabel('dWBA/dt (cV/sec)');
line([90 90],ylim(),'Color','k');
line([270 270],ylim(),'Color','k');

subplot(1,4,2); hold on;
for epochN = 1:10
     epochList = 14:23;
     epochRanges = epochList(epochN);
     [WBAtraces, dWBAtraces, rangeX] = accumulateWBAbyAngle(fileList,epochRanges, preTime, postTime,rangeX);
     plotBands(rangeX,dWBAtraces - epochN*spaceFactor,'r');
     % for i=1:size(WBAtraces,1)
     %     plot(rangeX,dWBAtraces(i,:) - epochN*spaceFactor);
     % end
    line([rangeX(1) rangeX(end)],[-epochN*spaceFactor -epochN*spaceFactor],'Color','k');
end
set(gca,'XTick',[90 270]);
set(gca,'YTick',[]);
title('Odor Data');
maxSpan = -(epochN+1)*spaceFactor;
ylim([maxSpan 0]);
set(gca,'YTick',[]);
bottomBlock = 31*maxSpan/32;
fill([30 35 35 30],[bottomBlock bottomBlock bottomBlock+spaceFactor bottomBlock+spaceFactor],'k');
text(40, bottomBlock, ' 800 cV/sec','VerticalAlignment','baseline')
xlim([rangeX(1) rangeX(end)]);
xlabel('Angle (deg.)');
ylabel('dWBA/dt (cV/sec)');
line([90 90],ylim(),'Color','k');
line([270 270],ylim(),'Color','k');


subplot(1,4,3); hold on;
for epochN = 1:10
    spins = ones(1,size(rangeX,2)) .* spinVals(epochN);
    evModel = epochModels{2};
    evResp = evModel(rangeX,spins);
    plot(rangeX,evResp - epochN*spaceFactor,'Color','b','LineWidth',1);
    line([rangeX(1) rangeX(end)],[-epochN*spaceFactor -epochN*spaceFactor],'Color','k');
end
set(gca,'XTick',[90 270]);
set(gca,'YTick',[]);
title('EV Model');
maxSpan = -(epochN+1)*spaceFactor;
ylim([maxSpan 0]);
set(gca,'YTick',[]);
bottomBlock = 31*maxSpan/32;
fill([30 35 35 30],[bottomBlock bottomBlock bottomBlock+spaceFactor bottomBlock+spaceFactor],'k');
text(40, bottomBlock, ' 800 cV/sec','VerticalAlignment','baseline')
xlim([rangeX(1) rangeX(end)]);
xlabel('Angle (deg.)');
ylabel('dWBA/dt (cV/sec)');
line([90 90],ylim(),'Color','k');
line([270 270],ylim(),'Color','k');

subplot(1,4,4); hold on;
for epochN = 1:10
    spins = ones(1,size(rangeX,2)) .* spinVals(epochN);
    evModel = epochModels{3};
    evResp = evModel(rangeX,spins);
    plot(rangeX,evResp - epochN*spaceFactor,'Color','r','LineWidth',1);
    line([rangeX(1) rangeX(end)],[-epochN*spaceFactor -epochN*spaceFactor],'Color','k');
end
set(gca,'XTick',[90 270]);
set(gca,'YTick',[]);
title('Odor Model');
maxSpan = -(epochN+1)*spaceFactor;
ylim([maxSpan 0]);
set(gca,'YTick',[]);
bottomBlock = 31*maxSpan/32;
fill([30 35 35 30],[bottomBlock bottomBlock bottomBlock+spaceFactor bottomBlock+spaceFactor],'k');
text(40, bottomBlock, ' 800 cV/sec','VerticalAlignment','baseline')
xlim([rangeX(1) rangeX(end)]);
xlabel('Angle (deg.)');
ylabel('dWBA/dt (cV/sec)');
line([90 90],ylim(),'Color','k');
line([270 270],ylim(),'Color','k');


