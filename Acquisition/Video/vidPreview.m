function vidPreview(obj,event,himage)

    global previewFigure;

    if (size(event.Data,2) == 640)
    
       
        % Get timestamp for frame.
        tstampstr = event.Timestamp;
        % Get handle to text label uicontrol.
        ht = getappdata(himage,'HandleToTimestampLabel');
        % Set the value of the text label.
        set(ht,'String',tstampstr);

        frame = event.Data;
  
        % Send the marked-up image to the preview window
        % set(0,'CurrentFigure',previewFigure);
        set(0,'CurrentFigure',previewFigure);
        set(himage, 'CData', frame(480:-1:1,639:-1:1));   % flip image
        %set(himage, 'CData', frame); % Upright
    end

    
        