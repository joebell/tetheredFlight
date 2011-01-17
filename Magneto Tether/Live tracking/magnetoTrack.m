% magnetoTrack.m
%
% This function is called by FramesAcquiredFcn on every video acquisition
% frame.  It tracks using 4 different trackModes:
% 
% 0 - Thresholds the image, takes the centroid.
% 1 - Subtracst he image from background, thresholds, takes the centroid
% 2 - Divides the image into the most informative halves, thresholds, and
% then reports the largest centroid between the two halves.
% 3 - Divides the image into the most informative halves, thresholds, and
% then takes the centroid closest to the previously tracked location.  This
% will follow either the head or the tail of an oblong blob.  Use the
% flipEnd() function to switch which end is tracked.
%
% By default this tracks white flies on a black bg.  Set invert=false to
% track a black fly on a white background.
%
% JSB 11/2010
function magnetoTrack(obj, event)

    global vid;
    global trackingParams;

    % Tracking parameters    
    imageTau = 20;          % Image averaging time-constant (secs)
    trackThresh = 40;       % Pixel brightness threshold for detecting change
    boxSize = 3;            % Size of bounding box to draw
    invert = true;          % True for white fly on black BG 
    trackMode = 1;          % See below for descriptions
    
    
    bsize = trackingParams.boundingSize;
    
    % Get the most recent frame
    frame = getdata(obj, 1);
    frame = frame(:,bsize:-1:1);
      
    % Update the running avg if necessary
    if trackingParams.updateAvg
        fps = get(obj.Source,'FrameRate');
        flyDecayN = str2num(fps)*imageTau;
        trackingParams.runningAvg = trackingParams.runningAvg(:,:,1)*(flyDecayN - 1)/flyDecayN + double(frame)/flyDecayN;
    end
    % ---------------------------------------------------
    %   Tracking mode descriptions
    % ---------------------------------------------------
    % Mode 0 is threshold centroid
    % Mode 1 is bg subtraction threshold centroid
    % Mode 2 bg subtracts into half-regions and tracks the biggest centroid
    % Mode 3 bg subtracts into half-regions and tracks the last centroid
    % Mode 4 takes the half-regions with the biggest difference in pixel
    % counts.
    if trackMode == 0
        % Find over threshold pix
        if invert
            trackingParams.redPix = (frame > trackThresh);
        else
            trackingParams.redPix = (frame < trackThresh);
        end
        
        % Find the over-threshold pixels (recently changed...)
        [row, col] = find(trackingParams.redPix);
        
        % Compute their mean as the centroid center.
        xPos = mean(col);
        yPos = mean(row);
    elseif trackMode == 1
        % Subtract camera data from the running average
        if invert
            diffPix = frame - uint8(trackingParams.runningAvg);
        else
            diffPix = uint8(trackingParams.runningAvg) - frame;
        end
        trackingParams.redPix = (diffPix > trackThresh);

        % Find the over-threshold pixels (recently changed...)
        [row, col] = find(trackingParams.redPix);
        
        % Compute their mean as the centroid center.
        xPos = mean(col);
        yPos = mean(row);
    elseif trackMode == 2
        % Subtract camera data from the running average
        if invert
            diffPix = frame  - uint8(trackingParams.runningAvg);
        else
            diffPix = uint8(trackingParams.runningAvg) - frame;
        end
        trackingParams.redPix = (diffPix > trackThresh);

        % Divide screen into most informative halves, then
        % subdivide the blobs along those halves, tracking the
        % centroid of the biggest blob
        [Trow, Tcol] = find(diffPix(1:bsize/2,:) > trackThresh);
        [Brow, Bcol] = find(diffPix(bsize/2:bsize,:) > trackThresh);
        [Lrow, Lcol] = find(diffPix(:,1:bsize/2) > trackThresh);
        [Rrow, Rcol] = find(diffPix(:,bsize/2:bsize) > trackThresh);
        TBidx = (std(Trow) + std(Tcol))/size(Tcol,1) + (std(Brow) + std(Bcol))/size(Bcol,1);
        LRidx = (std(Lrow) + std(Lcol))/size(Lcol,1) + (std(Rrow) + std(Rcol))/size(Rcol,1);
        if TBidx < LRidx % Choose TB panels
            if size(Tcol,1) > size(Bcol,1) % Choose top
                xPos = mean(Tcol);  yPos = mean(Trow);
            else % Choose bottom
                xPos = mean(Bcol);  yPos = mean(Brow)+bsize/2;
            end
        else  % Choose LR panels
            if size(Lcol,1) > size(Rcol,1) % Choose left
                xPos = mean(Lcol);     yPos = mean(Lrow);
            else % Choose bottom
                xPos = mean(Rcol)+bsize/2; yPos = mean(Rrow);
            end
        end
    elseif trackMode == 3
        % Subtract camera data from the running average
        if invert
            diffPix = frame - uint8(trackingParams.runningAvg);
        else
            diffPix = uint8(trackingParams.runningAvg) - frame;
        end
        trackingParams.redPix = (diffPix > trackThresh);
        
        % Divide screen into most informative halves, then
        % subdivide the blobs along those halves, tracking the
        % centroid of the last blob
        bsize = trackingParams.boundingSize;
        [Trow, Tcol] = find(diffPix(1:(bsize/2),:) > trackThresh);
        [Brow, Bcol] = find(diffPix((bsize/2):bsize,:) > trackThresh);
        [Lrow, Lcol] = find(diffPix(:,1:(bsize/2)) > trackThresh);
        [Rrow, Rcol] = find(diffPix(:,(bsize/2):bsize) > trackThresh);
        %TBidx = (std(Trow) + std(Tcol))/size(Tcol,1) + (std(Brow) + std(Bcol))/size(Bcol,1);
        %LRidx = (std(Lrow) + std(Lcol))/size(Lcol,1) + (std(Rrow) + std(Rcol))/size(Rcol,1);
        TBidx = max([size(Tcol,1),size(Bcol,1)]);
        LRidx = max([size(Lcol,1),size(Rcol,1)]);
        % disp([num2str(TBidx),' ',num2str(LRidx)]);
        prevPosition = [trackingParams.xPos, trackingParams.yPos];
        if TBidx > LRidx % Choose TB panels
            topDist = norm([mean(Tcol),mean(Trow)]-prevPosition);
            bottomDist = norm([mean(Bcol),mean(Brow)+(bsize/2)]-prevPosition);
            if trackingParams.ringBuffer.flip
                  temp = topDist;
                  topDist = bottomDist;
                  bottomDist = temp;
                  trackingParams.ringBuffer.flip = false;
            end
            if topDist < bottomDist % Choose top
                xPos = mean(Tcol);  yPos = mean(Trow);
                %disp('Top');
            else % Choose bottom
                xPos = mean(Bcol);  yPos = mean(Brow)+(bsize/2);
                %disp('Bottom');
            end
        else  % Choose LR panels
            leftDist = norm([mean(Lcol),mean(Lrow)]-prevPosition);
            rightDist = norm([mean(Rcol)+(bsize/2),mean(Rrow)]-prevPosition);
            % Choose LR panels
            if trackingParams.ringBuffer.flip
                temp = leftDist;
                leftDist = rightDist;
                rightDist = temp;
                trackingParams.ringBuffer.flip = false;
            end
            if leftDist < rightDist % Choose left
                xPos = mean(Lcol);     yPos = mean(Lrow);
                %disp('Left');
            else % Choose right
                xPos = mean(Rcol)+(bsize/2); yPos = mean(Rrow);
                %disp('Right');
            end
        end
    elseif trackMode == 4
        % Subtract camera data from the running average
        if invert
            diffPix = frame - uint8(trackingParams.runningAvg);
        else
            diffPix = uint8(trackingParams.runningAvg) - frame;
        end
        trackingParams.redPix = (diffPix > trackThresh);

        % Divide screen into most informative halves, then
        % subdivide the blobs along those halves, tracking the
        % centroid of the biggest blob
        [Trow, Tcol] = find(diffPix(1:bsize/2,:) > trackThresh);
        [Brow, Bcol] = find(diffPix(bsize/2:bsize,:) > trackThresh);
        [Lrow, Lcol] = find(diffPix(:,1:bsize/2) > trackThresh);
        [Rrow, Rcol] = find(diffPix(:,bsize/2:bsize) > trackThresh);
        TBidx = abs(size(Tcol,1) - size(Bcol,1));
        LRidx = abs(size(Lcol,1) - size(Rcol,1));
        if TBidx > LRidx % Choose TB panels
            if size(Tcol,1) > size(Bcol,1) % Choose top
                xPos = mean(Tcol);  yPos = mean(Trow);
            else % Choose bottom
                xPos = mean(Bcol);  yPos = mean(Brow)+bsize/2;
            end
        else  % Choose LR panels
            if size(Lcol,1) > size(Rcol,1) % Choose left
                xPos = mean(Lcol);     yPos = mean(Lrow);
            else % Choose bottom
                xPos = mean(Rcol)+bsize/2; yPos = mean(Rrow);
            end
        end    
    end % End trackMode
       
    % Copy the computed positions to the global space
    if (isnan(xPos) || isnan(yPos))
        xPos = trackingParams.xPos;
        yPos = trackingParams.yPos;
    else
        trackingParams.xPos = xPos;
        trackingParams.yPos = yPos;
    end
    ctrX = trackingParams.rotationCenter(1);
    ctrY = trackingParams.rotationCenter(2);
    trackingParams.angle = atan2(-(yPos - ctrY), xPos - ctrX)*360/(2*pi);
    
    % Output the tracking angle
    outputXangle(trackingParams.angle + 90);

    
    
    % Load ring buffer with place and time
    ringBuffer = trackingParams.ringBuffer;
    ringBuffer.buffer(ringBuffer.idx, 1) = xPos;
    ringBuffer.buffer(ringBuffer.idx, 2) = yPos;
    ringBuffer.time(ringBuffer.idx) = toc;
    tic;
    ringBuffer.prevIdx = ringBuffer.idx;
    ringBuffer.idx = ringBuffer.idx + 1;
    if ringBuffer.idx > ringBuffer.size
        ringBuffer.idx = 1;
    end
    trackingParams.ringBuffer = ringBuffer;
    
    % Write the tracking to the current figure
    set(0,'CurrentFigure',trackingParams.previewFigure);
    delete(trackingParams.lastLine);
    trackingParams.lastLine = line([xPos-boxSize, xPos+boxSize, ...
        xPos+boxSize, xPos-boxSize,xPos-boxSize],[yPos+boxSize, ...
        yPos+boxSize,yPos-boxSize,yPos-boxSize,yPos+boxSize]);
    delete(trackingParams.centerLine);
    xSeq = [trackingParams.rotationCenter(1)-3, trackingParams.rotationCenter(1), ...
        trackingParams.rotationCenter(1)+3, trackingParams.rotationCenter(1), ...
        trackingParams.rotationCenter(1)-3];
    ySeq = [trackingParams.rotationCenter(2), trackingParams.rotationCenter(2)-3,  ...
        trackingParams.rotationCenter(2), trackingParams.rotationCenter(2)+3, ...
        trackingParams.rotationCenter(2)];
    trackingParams.centerLine = line(xSeq, ySeq);
    
    % Call the preview window
    anEvent.Data = frame;
    tVec = event.Data.AbsTime;
    anEvent.Timestamp = [num2str(tVec(4),'%02.f'),':',num2str(tVec(5),'%02.f'),':',num2str(floor(tVec(6)),'%02i'),'.',num2str(floor((tVec(6)-floor(tVec(6)))*100),'%02i')];
    magnetoPreview(obj, anEvent,trackingParams.hImage);

end