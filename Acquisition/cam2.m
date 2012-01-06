function cam2(arg)

    global vid2;

    if (isstr(arg))
      %  'AutoExposure',500, ...             % 0-511
      %  'Brightness', 250, ...              % 128-383
      %  'Gain', 110, ...                    % 0-255
        set(vid2.Source,'AutoExposureMode','auto', ...
            'BrightnessMode','auto', ...
            'Sharpness', 50, ...                % 0-255
            'Shutter', 7, ...                   % 0-7
            'Gamma',1, ...                      % 0 or 1  
            'FrameRate', '30');                 % 30,15,7.5,3.75 - Use a string!
    else
              
        set(vid2.Source,'AutoExposureMode','manual', ...
            'BrightnessMode','manual', ...
            'AutoExposure',arg, ...             % 0-511
            'Brightness', 250, ...              % 128-383
            'Gain', 200, ...                    % 0-255
            'Sharpness', 50, ...                % 0-255
            'Shutter', 7, ...                   % 0-7
            'Gamma',1, ...                      % 0 or 1  
            'FrameRate', '30');                 % 30,15,7.5,3.75 - Use a string!
    end