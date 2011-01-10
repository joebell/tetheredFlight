%
% A function for recording a raw video stream while videotracking.
%
% JSB 10/2009
% Commented 3/2010
%

function recordVideo(vid, filename, lastTimer)

    % Recording parameters
    filename = ['../Data/',filename,'.avi'];
    quality = 80;    
    
    
    % Setup saving the video to a file...   
    aviobj = avifile(filename,'Colormap',gray(256), ...
                    'Fps',30,'compression','MSVC','Quality',80);
    vid.LoggingMode = 'disk';
    vid.DiskLogger = aviobj;
    
    % Arm the video for recording
    start(vid);
    % Start the recording...
    trigger(vid);
    
    wait(lastTimer);
            % You could also set a timer here if your program needs to do other
            % things, just make sure to come back and stop the vid and clean up.
    
    
    % Stop the video, wait for all frames to get written to disk, then
    % clean up.
    stop(vid);  
    while(get(vid,'FramesAcquired') > vid.DiskLoggerFrameCount)
        pause(1);
        disp('Pausing for writing video to disk...');
    end
    aviobj = close(vid.DiskLogger);
    clear aviobj;
    flushdata(vid);
