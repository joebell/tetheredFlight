function [smoothX, wrappedX] = smoothUnwrap(inputX, xOutputCal, patternOffset)

    % Scales and unwraps X
    X = xOutputCal.slope*inputX + xOutputCal.intercept + patternOffset;     % Converts voltage to degrees
    X = unwrap(X*2*pi/360);                         % Degrees to radians
    X = X*360/(2*pi);                               % Back to degrees
    
    smoothX = X;
    smoothX = smooth(smoothX,25,'moving');                % Smooths waveform
    lowPass = 40;
    sampleRate = 1000;
    [b a] = butter(8,lowPass/(sampleRate/2),'low');
    smoothX = filtfilt(b,a,smoothX);
   
    smoothX = round(smoothX*96/360)*360/96;         % Quantizes waveform to arena
    
	% Re-wraps X
    turnsUp = ceil(max(smoothX)/360);
    turnsDown = floor(min(smoothX)/360);
    for i = 0:abs(turnsUp)
        temp = (smoothX - 360*i);
        ind = find((temp >= 0) & (temp < 360));
        wrappedX(ind) = temp(ind);
    end
    for i = 1:abs(turnsDown)
        temp = (smoothX + 360*i);
        ind = find((temp >= 0) & (temp < 360));
        wrappedX(ind) = temp(ind);
    end
    
    % Adds NaN separators
    diffX = abs(wrappedX(1:(size(wrappedX,2)-1)) - wrappedX(2:(size(wrappedX,2))));   
    jumps = find(diffX > 180);
    wrappedX(jumps) = NaN;
    % Ensures continuity
    proxUpGaps = find(wrappedX(jumps - 1) > 180);
    wrappedX(jumps(proxUpGaps) - 1) = 360;
    distalDownGaps = find(wrappedX(jumps + 1) > 180);
    wrappedX(jumps(distalDownGaps) + 1) = 360;
    
