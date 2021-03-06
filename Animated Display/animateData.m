function animateData(dataFilename, startTime, endTime, plotFcn)

global saveVideo;
global wholeData;
global readVideo;
global filename;
global videoOffset;
global plotFunction;
global upright;
global sub1;
global sub2;

plotFunction = plotFcn;

videoRate = 30;     % fps
saveVideo = true;
readVideo = true;
upright   = false;
videoOffset = -2;  % frames

figure();
set(gcf,'Units','pixels');
scnsize = get(0,'ScreenSize');
set(gcf,'Position',[100 100 960 640]);
subplot(2,4,[1 2 5 6]);
set(gca,'OuterPosition',[0 0 .5 1]);
set(gca,'Position',[0 0 .5 1]);
sub1 = gca;
subplot(2,4,[3 4 7 8]);
set(gca,'OuterPosition',[.5 0 .5 1]);
set(gca,'Position',[.5 0 .5 1]);
box off;
sub2 = gca;
set(gcf,'OuterPosition',[100 100 960 640]);
set(gcf,'Position',[100 100 960 640]);
%set(gcf,'Resize','off');


filename = dataFilename;

load([filename]);
tOffset = -.129; % Timing offset
rateError = .36; % Correction for DAQ clock
nSamples = size(data.LAmp,1);
data.time = ((1:nSamples) ./ (daqParams.SampleRate + rateError)) + tOffset;
[data.smoothX, data.wrappedX] = smoothUnwrap(data.X, daqParams.xOutputCal, 0);
    
global X;
X = data.wrappedX;
global Laser;
Laser = data.Laser;
global Odor;
Odor = data.Odor;

global samplesPerFrame;
global startSample;
global startPoint;
startPoint = startTime;
startSample = startTime*daqParams.SampleRate;
samplesPerFrame = daqParams.SampleRate / videoRate;
totalFrames = (endTime - startTime)*videoRate;

global arena;
global currentShapes;
global cutouts;
global laserBar;
global odorBar;
arena = drawBG;
currentShapes = currentProgram(0, arena);
cutouts = drawCutOuts(arena);
laserBar   = drawLaser(0, arena);
odorBar = drawOdor(0, arena);

if (saveVideo)
    mode = 'queue';
else
    mode = 'drop';
end

animationTimer = timer('ExecutionMode','fixedRate','Period',1/videoRate,...
                 'TimerFcn', @onTimer, 'TasksToExecute',totalFrames, 'BusyMode',mode);
start(animationTimer);
wait(animationTimer);

if (saveVideo)
    dos(['ffmpeg -i ./temp/Anim%d.jpg -qscale 1 ',strrep(filename,'.mat','.mpg')]);
    dos('del .\temp\Anim*.jpg');
end


function onTimer(obj, event)

    frame = get(obj, 'TasksExecuted');
    global samplesPerFrame;
    global startSample;
    global X;
    global arena;
    global currentShapes;
    global cutouts;
    global startPoint;
    global Laser;
    global Odor;
    global laserBar;
    global odorBar;
    global saveVideo;
    global wholeData;
    global filename;
    global readVideo;
    global videoOffset;
    global plotFunction;
    global upright;
    global sub1;
    global sub2;

    axes(sub2);
    
    sample = round(startSample + frame*samplesPerFrame);
    delete(currentShapes);
    delete(cutouts);
    delete(laserBar);
    delete(odorBar);
    currentShapes = plotFunction(X(sample), arena);
    cutouts = drawCutOuts(arena);
    laserBar = drawLaser(Laser(sample),arena);
    if (frame/30 + startPoint) > 60
        odorBar  = drawOdor(Odor(sample), arena);
    else
        odorBar = drawOdor(0, arena);
    end
        
    title(['Time: ', num2str(frame/30 + startPoint,'%4.2f')],'Color','w');
    box off;
    
    if (readVideo)
        axes(sub1);
        if (frame + 30*startPoint + videoOffset > 0)
            anImage = aviread(strrep(filename,'.mat','.avi'),frame + 30*startPoint + videoOffset);
            if upright
                imshow(anImage.cdata(1:1:480,640:-1:1)');
            else
                imshow(anImage.cdata(480:-1:1,640:-1:1)');
            end
        end
    end
    
    if (saveVideo)
        set(gcf,'Color','k');
        scrnimage = getframe(gcf);
        imwrite(scrnimage.cdata,['./temp/Anim',num2str(frame),'.jpg'],'jpg');
    end


