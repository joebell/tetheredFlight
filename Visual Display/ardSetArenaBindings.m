function ardSetArenaBindings(visParams)

    global ardVar;
    
    visionStep = 360/(ardVar.MaxX - ardVar.MinX + 1);
    
    ardWriteParam(ardVar.Mode, visParams(1));
    % If we're in position mode
    if (visParams(1) == 0) 
        ardWriteParam(ardVar.K0, (floor(mod(-(visParams(2)+30),360)/visionStep) + 1)); % Tested ok      
        ardWriteParam(ardVar.K1, round(  visParams(3)*100*(2^ardVar.Oversample)/(voltsToArd(1)*visionStep)  )); % Tested ok
        ardWriteParam(ardVar.K2, round(voltsToArd(visParams(4)/100))); % Good to within a few cV
    % If we're in velocity mode...
    elseif (visParams(1) == 1)
        ardWriteParam(ardVar.K3, round(-visParams(2)*(2^ardVar.Oversample)/(visionStep * ardVar.SampleRate))); % Tested ok
        ardWriteParam(ardVar.K4, round(visParams(3)*100*(2^ardVar.Oversample)/(voltsToArd(1)*visionStep * ardVar.SampleRate)  ));% Tested ok
        ardWriteParam(ardVar.K5, round(voltsToArd(visParams(4)/100))); % Good to within a few cV
    end

    ardFlip;
