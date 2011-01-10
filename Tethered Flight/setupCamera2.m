% 
% This function sets up a video preview window with a timestamp and a 
% custom preview window function that can be used for video tracking or 
% live-image mark-up.
%
% JSB 10/2009
% Commented 3/2010
%
function vid2 = setupCamera2() 

    global vid2;
        
    % Sets up the video object
    vid2 = videoinput('dcam',1,'Y8_640x480');
    set(vid2,'FramesPerTrigger',inf);
    set(vid2,'FrameGrabInterval', 1);
    triggerconfig(vid2, 'Manual');
    

    set(vid2.Source,'AutoExposureMode','manual', ...
        'BrightnessMode','manual', ...
        'AutoExposure',511, ...             % 0-511
        'Brightness', 280, ...              % 128-383
        'Gain', 160, ...                    % 0-255
        'Sharpness', 50, ...                % 0-255
        'Shutter', 7, ...                   % 0-7
        'Gamma',1, ...                      % 0 or 1  
        'FrameRate', '30');                 % 30,15,7.5,3.75 - Use a string!

    % Create the video preview figure
    global previewFigure2;
    previewFigure2 = figure('Name', 'Live video...','Position',[100, 100, 640, 480],'Resize','off','MenuBar','none');
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    %setAlwaysOnTop(previewFigure2,true);
    
    
    % Create the axes and image for the video feed and timestamp
    axes('Position',[0 0 1 1]);
    hTextLabel = uicontrol('style','text','String','Timestamp', ...
        'Units','normalized',...
        'Position',[0.85 -.04 .15 .065]);
    vidRes = get(vid2, 'VideoResolution'); 
    nBands = 3;
    hImage = image( zeros(vidRes(2), vidRes(1), nBands) ); 

    % Set up the update preview window function.
    % This displays the preview and does the tracking!
    setappdata(hImage,'UpdatePreviewWindowFcn',@vidPreview2);

    % Make handle to text label available to update function.
    setappdata(hImage,'HandleToTimestampLabel',hTextLabel);

    % Start the video preview
    preview(vid2, hImage);




