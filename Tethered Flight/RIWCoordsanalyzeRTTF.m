function out = RIWCoordsanalyzeRTTF(filename, comment)

%% Parameters

freqThresh = 100;       % Discard WBA's if Freq is below this.
colorList = ['b','m','k','r','g','y','c','b','m','k','r','g','y','c'];
tOffset = -.129; % Timing offset
rateError = .36; % Correction for DAQ clock


%% Load the file with the filename
load(filename);
nSamples = size(data.LAmp,1);
data.time = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;


%% Cleanup for old files

% TimeRun = 0;
% data.Odor = data.Laser;
% data.Laser = zeros(size(data.Odor,1),1);
% innateOdor;


% for i=1:size(trialStructureList,1)
%     point = trialStructureList{i,2};
%     if (point(2) > 0)
%         trialStructureList{i,3} = 'ffff';
%     elseif (point(2) < 0)
%         trialStructureList{i,4} = 'ffff';
%     end
% end

%% Remove data from times when the fly isn't flying...
ind = find(data.Freq < freqThresh);
data.LAmp(ind) = NaN;
data.RAmp(ind) = NaN;

%% Replot out of range points, flip axis to match plot axis

% data.X = -76.33*data.X + 3.0155;
% data.X = data.X - 360*(data.X > 360);
% data.X = data.X + 360*(data.X < 0);
% data.X = data.X - 360*(data.X > 360);
% data.X = data.X + 360*(data.X < 0);
% data.X = unwrap(data.X*2*pi/360);
% data.X = data.X*360/(2*pi);
[data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);

%% Make a figure
timeSeriesFigure = figure();
hold on;


%% Plot the WBA diff
subplot(6,1,1:2);
smoothWBAdiff = smooth(data.LAmp - data.RAmp,100,'moving');
plot(data.time, smoothWBAdiff, 'b');
title([trialStructureName,' - ',datestr(TimeRun,'yy-mm-dd HH:MM:SS'),' - ',comment]);
axis tight;
plotLaserTrace(gca, data);
plotOdorTrace(gca, data);
plot(data.time, data.LAmp - data.RAmp, 'g');
plot(data.time, smoothWBAdiff, 'b');
ylabel('WBA Difference (cV)');

xlims = [data.time(1),data.time(end)];
xlim(xlims);


%% Plot each WBA
subplot(6,1,3);
plot(data.time, smooth(data.LAmp,100,'moving'), 'y');
hold on;
plot(data.time, smooth(data.RAmp,100,'moving'), 'c');
axis tight;
lims = ylim();
if (lims(1) < 0)
    ylim([0 lims(2)]);
end
lims = ylim();
if (lims(2) > 550)
    ylim([lims(1) 550]);
end
plotLaserTrace(gca, data);
plotOdorTrace(gca, data);
ylabel('R & L WBA (cV)');
xlim(xlims);

%% Plot Freq
subplot(6,1,4);
plot(data.time, data.Freq, 'm');
lims = ylim();
if (lims(1) < 150 && lims(2) > 150)
    ylim([150 lims(2)]);
end
lims = ylim();
if (lims(2) > 300 && lims(1) < 300)
    ylim([lims(1) 300]);
end
xlim(xlims);
plotLaserTrace(gca, data);
plotOdorTrace(gca, data);
ylabel('WB Frequency (Hz)');



%% Plot arena position
subplot(6,1,5:6);
figure();
hold on;

for i=1:size(trialStructureList,1)
    time(i) = trialStructureList{i,1};
    laser(i,:) = trialStructureList{i,3};
    odor1(i,:)  = trialStructureList{i,4};
    odor2(i,:)  = trialStructureList{i,5};
end


for i = 2:size(trialStructureList,1)
    for j=1:16
        fillColor = [1 .7 .7];
        if (  bitand( hex2dec(laser(i-1,:)), bitshift(1,j-1))  > 0)
            interval = 360/16;
            bottom = 90 +(j-1)*interval;
            top = 90 + j*interval;
            if (top > 180)
                ntop = top - 360;
                nbottom = bottom - 360;
                if nbottom < -180
                    nbottom = -180;
                end
                fill( [time(i-1), time(i-1), time(i), time(i)],[ntop  nbottom nbottom ntop],fillColor ,'EdgeColor','none','FaceAlpha',.5);
                top = 180;
            end
            fill( [time(i-1), time(i-1), time(i), time(i)],[top  bottom bottom top],fillColor ,'EdgeColor','none','FaceAlpha',.5);            
        end
        fillColor = [.7 1 .7];
        if (  bitand( hex2dec(odor1(i-1,:)), bitshift(1,j-1))  > 0)
            interval = 360/16;
            bottom = 90 +(j-1)*interval;
            top = 90 + j*interval;
            if (top > 180)
                ntop = top - 360;
                nbottom = bottom - 360;
                if nbottom < -180
                    nbottom = -180;
                end
                fill( [time(i-1), time(i-1), time(i), time(i)],[ntop  nbottom nbottom ntop],fillColor ,'EdgeColor','none','FaceAlpha',.5);
                top = 180;
            end
            fill( [time(i-1), time(i-1), time(i), time(i)],[top  bottom bottom top],fillColor ,'EdgeColor','none','FaceAlpha',.5);            
        end
        fillColor = [.7 .7 1];
        if (  bitand( hex2dec(odor2(i-1,:)), bitshift(1,j-1))  > 0)
            interval = 360/16;
            bottom = 90 +(j-1)*interval;
            top = 90 + j*interval;
            if (top > 180)
                ntop = top - 360;
                nbottom = bottom - 360;
                if nbottom < -180
                    nbottom = -180;
                end
                fill( [time(i-1), time(i-1), time(i), time(i)],[ntop  nbottom nbottom ntop],fillColor ,'EdgeColor','none','FaceAlpha',.5);
                top = 180;
            end
            fill( [time(i-1), time(i-1), time(i), time(i)],[top  bottom bottom top],fillColor ,'EdgeColor','none','FaceAlpha',.5);            
        end
    end
end
%  
% transWrap = -data.wrappedX + 90;
% tooLow = find(transWrap < -180 | transWrap > 90);
% transWrap(tooLow) = NaN;
% plot(data.time, transWrap, 'b');
% transWrap = -data.wrappedX + 90;
% upperWrap = transWrap + 360;
% tooLow = find(upperWrap < 85 | upperWrap > 180);
% upperWrap(tooLow) = NaN;
% plot(data.time, upperWrap, 'b');

transX = -data.wrappedX + 90;
outBounds = transX < -180;
transX(outBounds) = NaN;
trans2X = -data.wrappedX + 90 + 360;
out2Bounds = trans2X > 180;
trans2X(out2Bounds) = NaN;

plot(data.time, transX,'b');
hold on;
plot(data.time, trans2X,'b');


plot(xlim(), [0 0],'--k');
plot(xlim(), [180 180],'k');
plot(xlim(), [-180 -180],'k');
ylim([-185 181]);
fill([xlims(1) xlims(2) xlims(2) xlims(1)],[-360,-360,-180,-180],[1 1 1],'FaceAlpha',1,'EdgeColor','none');
plotLaserTrace(gca, data);
plotOdorTrace(gca, data);
ylabel('Arena Position (deg)');
xlabel('Time (sec)');
set(gca,'YTick',[-180 -90 0 90 180]);
set(gca,'YTickLabel','-180|-90|0|90|180');
xlim(xlims);









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






