% cam.m
%
% A wrapper function to set camera parameters.  Run without args to 
% set camera to auto-exposure mode. Else, argument sets exposure.
%
% JSB 11/2010
function mcam(arg)

    global vid;

    if (nargin < 1)
      %  'AutoExposure',500, ...             % 0-511
      %  'Brightness', 250, ...              % 128-383
      %  'Gain', 110, ...                    % 0-255
        set(vid.Source,'AutoExposureMode','auto', ...
            'BrightnessMode','auto', ...
            'Sharpness', 50, ...                % 0-255
            'Shutter', 7, ...                   % 0-7
            'Gamma',1, ...                      % 0 or 1  
            'FrameRate', '30');                 % 30,15,7.5,3.75 - Use a string!
    else
              
        set(vid.Source,'AutoExposureMode','manual', ...
            'BrightnessMode','manual', ...
            'AutoExposure',arg, ...             % 0-511
            'Brightness', 200, ...              % 128-383
            'Gain', 150, ...                    % 0-255
            'Sharpness', 50, ...                % 0-255
            'Shutter', 7, ...                   % 0-7
            'Gamma',1, ...                      % 0 or 1  
            'FrameRate', '30');                 % 30,15,7.5,3.75 - Use a string!
    end