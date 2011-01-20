% setAvgRing.m
%
% Sets the running avg to a circle in the center.
%
% JSB 11/2010
function setAvgRing(radius)

    global trackingParams;
    
    trackingParams.updateAvg = false;
    
    trackingParams.runningAvg(:,:,1) = 0;
    
    frameSize = size(trackingParams.runningAvg,1);
    
    for x = 1:frameSize
        for y = 1:frameSize
            distance = norm([x,y] - [frameSize/2,frameSize/2]);
            if distance <= radius
                trackingParams.runningAvg(x,y,1) = 200;
            end
        end
    end
  