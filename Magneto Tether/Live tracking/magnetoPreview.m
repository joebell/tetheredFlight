% magnetoPreview.m
%
% This is a video preview window function for previewing tracking data.
% This seems to run best if called by the tracking algoritm that is called
% by FramesAcquiredFcn, rather than implemented as a MATLAB video preview
% callback (called by UpdatePreviewWindowFcn).  The reason is that
% FramesAcquiredFcn is guaranteed to run on every frame.  This has 4 modes:
%
% 0 - RawView, just the raw video plus the graticule
% 1 - FlyView, highlights the tracked regions
% 2 - AvgView, shows the running avg. in cyan, new video in red
% 3 - DiffView, shows the difference from avg., hotter in red, colder in
% blue.
%
% All of these show the graticule and track location.  
% Click on the window to re-center the region of interest in the video.
% Shift-Click to set the region of interest to the center of the frame.
%
% JSB 11/2010
function magnetoPreview(obj,event,hImage) 
   
    global trackingParams;
    
    % Protect from the video loopback bug
    if (size(event.Data,2) == trackingParams.boundingSize) ...
            && (size(event.Data,3) == 1)
    
        % Get timestamp for frame.
        tstampstr = event.Timestamp;
        % Get handle to text label uicontrol.
        ht = getappdata(hImage,'HandleToTimestampLabel');
        % Set the value of the text label.
        set(ht,'String',tstampstr);

        if trackingParams.displayMode == 1
            % Fly-highlight view
            halfFrame = event.Data(:,:,1)/2;
            frame(:,:,1) = 245*uint8(trackingParams.redPix) + halfFrame;
            frame(:,:,2) = halfFrame;
            frame(:,:,3) = halfFrame;  
        elseif trackingParams.displayMode == 2
            % Avg. view, puts current in red, avg in cyan
            frame(:,:,1) = event.Data(:,:,1);
            frame(:,:,2) = trackingParams.runningAvg(:,:,1);
            frame(:,:,3) = trackingParams.runningAvg(:,:,1);
        elseif trackingParams.displayMode == 3
            % Diff. view, puts hotter than avg. in red, colder in blue
            frame(:,:,1) = 1*(event.Data(:,:,1) - uint8(trackingParams.runningAvg(:,:,1)));
            frame(:,:,2) = zeros(trackingParams.boundingSize);
            frame(:,:,3) = 1*(uint8(trackingParams.runningAvg(:,:,1)) - event.Data(:,:,1));           
        else
            frame(:,:,1) = event.Data(:,:,1);
            frame(:,:,2) = event.Data(:,:,1);
            frame(:,:,3) = event.Data(:,:,1);
        end        
        % Send the marked-up image to the preview window
        set(0,'CurrentFigure',trackingParams.previewFigure);
        set(hImage, 'CData', frame);
    end
end

    
        