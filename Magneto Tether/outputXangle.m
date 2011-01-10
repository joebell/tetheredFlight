function outputXangle(angle);

    global analogOut;
    global trackingParams;
    
    % Put angles in 0-360 space
    if (angle < 0)
        angle = angle + 360;
    elseif (angle > 360)
        angle = angle - 360;
    end
    
    slope = trackingParams.xInputCal.slope;
    intercept = trackingParams.xInputCal.intercept;
    voltage = slope*angle + intercept;
    if (voltage < 0)
        voltage = slope*(angle - 360) + intercept;
    end
    
    putsample(analogOut, voltage);