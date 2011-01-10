%
% This function sets up a video preview window with a timestamp and a 
% custom preview window function that can be used for video tracking or 
% live-image mark-up.
%
% JSB 10/2009
% Commented 3/2010
%
function uprightVid = setupCamera() 


    global uprightVid;
        
    % Sets up the video object
    uprightVid = videoinput('dcam',2,'Y8_640x480');
    set(uprightVid,'FramesPerTrigger',inf);
    set(uprightVid,'FrameGrabInterval', 1);
    triggerconfig(uprightVid, 'Manual');
    

    set(uprightVid.Source,'AutoExposureMode','manual', ...
        'BrightnessMode','manual', ...
        'AutoExposure',500, ...             % 0-511
        'Brightness', 128, ...              % 128-383
        'Gain', 130, ...                    % 0-255
        'Sharpness', 50, ...                % 0-255
        'Shutter', 7, ...                   % 0-7
        'Gamma',1, ...                      % 0 or 1  
        'FrameRate', '30');                 % 30,15,7.5,3.75 - Use a string!

    % Create the video preview figure
    global uprightPreviewFigure;
    uprightPreviewFigure = figure('Name', 'Live video...','Position',[100, 100, 480, 640],'Resize','off','MenuBar','none');
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    setAlwaysOnTop(uprightPreviewFigure,true);
    
    
    % Create the axes and image for the video feed and timestamp
    axes('Position',[0 0 1 1]);
    hTextLabel = uicontrol('style','text','String','Timestamp', ...
        'Units','normalized',...
        'Position',[0.85 -.04 .15 .065]);
    vidRes = get(uprightVid, 'VideoResolution'); 
    nBands = 3;
    hUpImage = image( zeros(vidRes(1), vidRes(2), nBands) ); 

    % Set up the update preview window function.
    % This displays the preview and does the tracking!
    setappdata(hUpImage,'UpdatePreviewWindowFcn',@vidPreview);

    % Make handle to text label available to update function.
    setappdata(hUpImage,'HandleToTimestampLabel',hTextLabel);

    % Start the video preview
    preview(uprightVid, hUpImage);




