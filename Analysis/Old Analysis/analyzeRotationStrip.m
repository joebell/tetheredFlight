function out = analyzeRotationStrip(filename, comment, myAxis, varargin)

%% Parameters

freqThresh = 100;       % Discard WBA's if Freq is below this.
colorList = ['b','m','k','r','g','y','c','b','m','k','r','g','y','c'];
tOffset = -.129; % Timing offset
rateError = .36; % Correction for DAQ clock


%% Load the file with the filename
load(filename);
nSamples = size(data.LAmp,1);
data.time = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;

if nargin <= 3
    stTime = data.time(1);
    endTime = data.time(end);
else
    stTime = varargin{1};
    endTime = varargin{2};
end

%% Remove data from times when the fly isn't flying...
ind = find(data.Freq < freqThresh);
data.LAmp(ind) = NaN;
data.RAmp(ind) = NaN;

%% Replot out of range points, flip axis to match plot axis

[data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);

%% Make a figure
% Don't make a figure; use the panel supplied
%timeSeriesFigure = figure();
%hold on;

axes(myAxis);



%% Plot the WBA diff
% subplot(6,1,1:2);
% smoothWBAdiff = smooth(data.LAmp - data.RAmp,100,'moving');
% plot(data.time, smoothWBAdiff, 'b');
% title([trialStructureName,' - ',datestr(TimeRun,'yy-mm-dd HH:MM:SS'),' - ',comment]);
% axis tight;
% plotLaserTrace(gca, data);
% plotOdorTrace(gca, data);
% plot(data.time, data.LAmp - data.RAmp, 'g');
% plot(data.time, smoothWBAdiff, 'b');
% ylabel('WBA Difference (cV)');
% 
% xlims = [data.time(1),data.time(end)];
% xlim(xlims);


%% Plot each WBA
% subplot(6,1,3);
% plot(data.time, smooth(data.LAmp,1,'moving'), 'y');
% hold on;
% plot(data.time, smooth(data.RAmp,1,'moving'), 'c');
% axis tight;
% lims = ylim();
% if (lims(1) < 0)
%     ylim([0 lims(2)]);
% end
% lims = ylim();
% if (lims(2) > 550)
%     ylim([lims(1) 550]);
% end
% plotLaserTrace(gca, data);
% plotOdorTrace(gca, data);
% ylabel('R & L WBA (cV)');
% xlim(xlims);

%% Plot Freq
% subplot(6,1,4);
% plot(data.time, data.Freq, 'm');
% lims = ylim();
% if (lims(1) < 150 && lims(2) > 150)
%     ylim([150 lims(2)]);
% end
% lims = ylim();
% if (lims(2) > 300 && lims(1) < 300)
%     ylim([lims(1) 300]);
% end
% xlim(xlims);
% plotLaserTrace(gca, data);
% plotOdorTrace(gca, data);
% ylabel('WB Frequency (Hz)');



%% Plot arena position
% subplot(6,1,5:6);
hold on;

for i=1:size(trialStructureList,1)
    time(i) = trialStructureList{i,1};
    laser(i,:) = trialStructureList{i,3};
    odor1(i,:)  = trialStructureList{i,4};
    odor2(i,:)  = trialStructureList{i,5};
end

fillOffset = 3.75/2;
for i = 2:size(trialStructureList,1)
    for j=1:16
        if (  bitand( hex2dec(laser(i-1,:)), bitshift(1,16-j))  > 0)
            interval = 360/16;
            fill( [time(i-1), time(i-1), time(i), time(i)],[(360 - (j-1)*interval)+fillOffset (360 -j*interval)+fillOffset (360 -j*interval)+fillOffset (360 -(j-1)*interval)+fillOffset],[1 .7 .7] ,'EdgeColor','none','FaceAlpha',.5);
            bottom = -j*interval+fillOffset;
            top = -(j-1)*interval+fillOffset;
            if (bottom < -180)
                bottom = -180;
            end
            if (top > bottom)
                fill( [time(i-1), time(i-1), time(i), time(i)],[top bottom bottom top],[1 .6 .6] ,'EdgeColor','none','FaceAlpha',.5);       
            end
        end
        if (  bitand( hex2dec(odor1(i-1,:)), bitshift(1,16-j))  > 0)
            interval = 360/16;
            fill( [time(i-1), time(i-1), time(i), time(i)],[(360 - (j-1)*interval)+fillOffset (360 -j*interval)+fillOffset (360 -j*interval)+fillOffset (360 -(j-1)*interval)+fillOffset],[.7 1 .7] ,'EdgeColor','none','FaceAlpha',.5);
            bottom = -j*interval+fillOffset;
            top = -(j-1)*interval+fillOffset;
            if (bottom < -180)
                bottom = -180;
            end
            if (top > bottom)
                fill( [time(i-1), time(i-1), time(i), time(i)],[top bottom bottom top],[.6 1 .6] ,'EdgeColor','none','FaceAlpha',.5);       
            end
        end
        if (  bitand( hex2dec(odor2(i-1,:)), bitshift(1,16-j))  > 0)
            interval = 360/16;
            fill( [time(i-1), time(i-1), time(i), time(i)],[(360 - (j-1)*interval)+fillOffset (360 -j*interval)+fillOffset (360 -j*interval)+fillOffset (360 -(j-1)*interval)+fillOffset],[.7 .7 1] ,'EdgeColor','none','FaceAlpha',.5);
            bottom = -j*interval+fillOffset;
            top = -(j-1)*interval+fillOffset;
            if (bottom < -180)
                bottom = -180;
            end
            if (top > bottom)
                fill( [time(i-1), time(i-1), time(i), time(i)],[top bottom bottom top],[.6 .6 1] ,'EdgeColor','none','FaceAlpha',.5);       
            end
        end
    end
end
 

plot(data.time, data.wrappedX, 'b');
axis tight;
lowerWrap = data.wrappedX - 360;
tooLow = find(lowerWrap < -180);
lowerWrap(tooLow) = NaN;
plot(data.time, lowerWrap, 'b');

plot(xlim(), [0 0],'--k');
plot(xlim(), [360 360],'k');
plot(xlim(), [-180 -180],'k');

ylim([-185 361]);
%fill([xlims(1) xlims(2) xlims(2) xlims(1)],[-360,-360,-180,-180],[1 1 1],'FaceAlpha',1,'EdgeColor','none');
plotLaserTrace(gca, data);
plotOdorTrace(gca, data);
ylabel('Arena Position (deg)');
xlabel('Time (sec)');
set(gca,'YTick',[-180 -90 0 90 180 270 360]);
set(gca,'YTickLabel','180|270|0|90|180|270|360');
title(comment);
xlim([stTime endTime]);
%xlim(xlims);

%% Plot the WBAdiff histogram

%histogramFigure = figure();

% subplot(1,(1 + size(histogramBounds,1)),1);
% 
% sampleBounds = round(histogramBounds * daqParams.SampleRate) + 1;
% numHist = size(histogramBounds,1);
% numParts = size(histogramBounds,2);
% 
% hold on;
% 
% for i=numHist:-1:1
%     partsList = [];
%     for j=1:2:numParts
%         partsList = cat(2, partsList, sampleBounds(i,j):sampleBounds(i,j+1));
%     end
%     [n(i,:),bins(i,:)] = hist(smoothWBAdiff(partsList),100);
%     plot(bins(i,:),n(i,:),colorList(i));
% end
% title([trialStructureName,' - ',datestr(TimeRun,'yy-mm-dd HH:MM:SS')]);
% 
% 
% xlabel('WBA Diff (cV)');
% ylabel('N');


%% Plot the angle histogram

% sampleBounds = round(histogramBounds * daqParams.SampleRate) + 1;
% numHist = size(histogramBounds,1);
% numParts = size(histogramBounds,2);
% 
% clear('bins','n');
% fillOffset = 3.75/2*2*pi/360;
% 
% for i=numHist:-1:1
%     partsList = [];
%     for j=1:2:numParts
%         partsList = cat(2, partsList, sampleBounds(i,j):sampleBounds(i,j+1));
%     end
%     [bins(i,:), n(i,:)] = rose((data.wrappedX(partsList)+1.8)*2*pi/360,96); 
%     %was smoothX
%     %[n(i,:), bins(i,:)] = hist(data.wrappedX(partsList)*2*pi/360,96);
%     maxN(i) = max(n(i,:));
% end
% 
% [B, IX] = sort(maxN,'descend');
% totMax = max(maxN);
% 
% for plotNum = 1:size(histogramBounds,1)
%     subplot(2,( size(histogramBounds,1)), plotNum);
%     for i=plotNum
%         polar(bins(i,:)-(3.75/2*2*pi/360),n(i,:)./maxN(plotNum),colorList(i));
%         hold on;
%     end
%     lims = ylim();
%     maxR = 1;
% 
% 
%     for i=1:size(trialStructureList,1)
%         time(i) = trialStructureList{i,1};
%         laser(i,:) = trialStructureList{i,3}; 
%         odor1(i,:) = trialStructureList{i,4}; 
%         odor2(i,:) = trialStructureList{i,5}; 
%     end
%     for i = 2:size(trialStructureList,1)
%         for j=1:16
%             if (  bitand( hex2dec(laser(i-1,:)), bitshift(1,16-j))  > 0)
%                 interval = -2*pi/16;
%                 angles = ((j-1)*interval:interval/15:j*interval)+fillOffset;
%                 Rmaxes = 1*ones(16,1);
%                 [X, Y] = pol2cart([(j-1)*interval angles j*interval],[0 Rmaxes' 0]);
%                 fill(X, Y, [1 .7 .7],'EdgeColor','none','FaceAlpha',.5);
%                 hold on;
%             end
%             if (  bitand( hex2dec(odor1(i-1,:)), bitshift(1,16-j))  > 0)
%                 interval = -2*pi/16;
%                 angles = ((j-1)*interval:interval/15:j*interval)+fillOffset;
%                 Rmaxes = .8*ones(16,1);
%                 [X, Y] = pol2cart([(j-1)*interval angles j*interval],[0 Rmaxes' 0]);
%                 fill(X, Y, [.7 1 .7],'EdgeColor','none','FaceAlpha',.5);
%                 hold on;
%             end
%             if (  bitand( hex2dec(odor2(i-1,:)), bitshift(1,16-j))  > 0)
%                 interval = -2*pi/16;
%                 angles = ((j-1)*interval:interval/15:j*interval)+fillOffset;
%                 Rmaxes = .6*ones(16,1);
%                 [X, Y] = pol2cart([(j-1)*interval angles j*interval],[0 Rmaxes' 0]);
%                 fill(X, Y, [.7 .7 1],'EdgeColor','none','FaceAlpha',.5);
%                 hold on;
%             end
%         end
%     end
% 
%     hline = findobj(gca,'Type','line');
%     set(hline,'LineWidth',1);
%     axis equal;
%     title(comment);
% end
% out = n;

%% Plot the 2D histograms

% sampleBounds = round(histogramBounds * daqParams.SampleRate) + 1;
% numHist = size(histogramBounds,1);
% numParts = size(histogramBounds,2);
% 
% smoothingWindow = 4; % Boxcar window in seconds
% 
% for i=numHist:-1:1
%     partsList = [];
%     for j=1:2:numParts
%         partsList = cat(2, partsList, sampleBounds(i,j):sampleBounds(i,j+1));
%     end
%     % 2 second boxcar filter on angle data
%     smoothX = smooth(cos(data.wrappedX(:)*2*pi/360),daqParams.SampleRate*smoothingWindow,'moving');
%     smoothY = smooth(sin(data.wrappedX(:)*2*pi/360),daqParams.SampleRate*smoothingWindow,'moving');
%     
%     Xvector{i} = smoothX(partsList);
%     Yvector{i} = smoothY(partsList);
% end
% 
% for plotNum = 1:size(histogramBounds,1)
%     clear('bins','n');
%     subplot(2,size(histogramBounds,1),size(histogramBounds,1)+plotNum);  
%     N = hist3([Xvector{plotNum},Yvector{plotNum}],{[-1.2:.05:1.2],[-1.2:.05:1.2]});   
%     myMap = hot;
%     % colormap(myMap(end:-1:1,:));    % Inverts colormap...
%     colormap(hot);
%     h = pcolor( N' / sum(N(:)));
%     set(h,'EdgeColor','none');
%     % colorbar;
%     axis square;
%     set(gca,'XTick',[]);
%     set(gca,'YTick',[]);
% 
% end

%% Save to PDF

% figure(timeSeriesFigure);
% 
%         set(gcf, 'Color', 'white');
%         set(gcf, 'InvertHardcopy','off');
%         set(gcf,'Units','pixels');
%         scnsize = get(0,'ScreenSize');
%         set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
%         set(gcf, 'PaperUnits', 'inches');
%         set(gcf, 'PaperSize', [11 8.5])
%         set(gcf, 'PaperPosition', [0 0 11 8.5]);
%         filenameOut = strrep(filename,'.mat','a.pdf');
%         print(gcf, '-dpdf',filenameOut);
%         
% figure(histogramFigure);
% 
%         set(gcf, 'Color', 'white');
%         set(gcf, 'InvertHardcopy','off');
%         set(gcf,'Units','pixels');
%         scnsize = get(0,'ScreenSize');
%         set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
%         set(gcf, 'PaperUnits', 'inches');
%         set(gcf, 'PaperSize', [11 8.5])
%         set(gcf, 'PaperPosition', [0 0 11 8.5]);
%         filenameOut = strrep(filename,'.mat','b.pdf');
%         print(gcf, '-dpdf',filenameOut);


function plotLaserTrace(ax, data)

    set(gcf,'CurrentAxes',ax);
    hold on;
    ylims = ylim();
    top = ylims(2);
    oldbot = ylims(1);
    newbot = oldbot - abs(top - oldbot)/8;
    laserbot = oldbot - .8* abs(top - oldbot)/8;
    scale = abs(top - oldbot)/10;
    ylim([newbot top]);
    ylims = ylim();
    plot(data.time, data.Rcv.*500000 - 1000000, 'k');
    plot(data.time, scale.*data.Laser./5 + laserbot, 'r');
    ylim(ylims);

function plotOdorTrace(ax, data)

    set(gcf,'CurrentAxes',ax);
    hold on;
    ylims = ylim();
    top = ylims(2);
    oldbot = ylims(1);
    newbot = oldbot - abs(top - oldbot)/8;
    laserbot = oldbot - .8* abs(top - oldbot)/8;
    scale = abs(top - oldbot)/10;
    ylim([newbot top]);
    ylims = ylim();
    plot(data.time, scale*data.Odor./5 + laserbot, 'c');
    ylim(ylims);

% a = analyzeRTTF('./Data/RTTF100322-162658.mat');   
% b = analyzeRTTF('./Data/RTTF100322-163425.mat');
% c = analyzeRTTF('./Data/RTTF100322-162933.mat');
% d = analyzeRTTF('./Data/RTTF100322-163156.mat');
% close all;
% figure();
% plot(a{2},a{1},'r');
% hold on;
% plot(b{2},b{1},'g');
% plot(c{2},c{1},'b');
% plot(d{2},d{1},'m');
% % plot(e{2},e{1},'k');






