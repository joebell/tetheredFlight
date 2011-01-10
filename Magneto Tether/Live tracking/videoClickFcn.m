% videoClickFcn.m
%
% Called when the video preview image is clicked.  This moves the region of
% interest to be centered on the point that was clicked.  Shift-Clicking
% centers the ROI in the middle of the video frame.
%
% nb. Doesn't protect against wandering out of the video frame.
%
% JSB 11/2010
function videoClickFcn(obj, event)

    global trackingParams;
    global vid;

    imageAxis = get(trackingParams.hImage,'Parent');
    rawCoords = get(imageAxis,'CurrentPoint');
    computedCoords = rawCoords(1,1:2) + (trackingParams.boundingCenter ...
        - trackingParams.boundingSize/2);


    sel_typ = get(gcbf,'SelectionType');
    switch sel_typ
        case 'normal'
            % disp('User clicked left-mouse button')
            trackingParams.boundingCenter = computedCoords;
            center = computedCoords;
            size = trackingParams.boundingSize;
        case 'extend'
            % disp('User did a shift-click')
            trackingParams.boundingCenter = [320, 240];
            center = [320, 240];
            size = trackingParams.boundingSize;
        case 'alt'
            %                 disp('User did a control-click')
            %                 set(src,'Selected','on')
            %                 set(src,'SelectionHighlight','off')
    end

    stop(vid);
    set(vid,'ROIPosition',[center(1)-size/2 center(2)-size/2 size size]);
    start(vid);
    trigger(vid);
    disp(['Reset video center to: ',num2str(center)]);

