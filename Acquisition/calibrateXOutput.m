function calibrateXOutput()

    stepLength = 1; % in seconds

    global analogIn;
    [USB, ardVar] = initializeArduino();
    % Intitialize the DAQ
    daqSettings();
    
    
    sampleRate = get(analogIn, 'SampleRate');
    set(analogIn, 'SamplesPerTrigger',uint32(stepLength*sampleRate));
    
    
    % Changes set angle of drum
    for i = 1:12;
        
        angle(i) = (i-1)*30;
        disp(['Testing angle = ',num2str(angle(i))]);
        ardSetArenaBindings([0,angle(i),0,0]);
        ardDispOn(); 
        pause(.1);
        start(analogIn);
        
        wait(analogIn,stepLength+2);
        acquiredData = getdata(analogIn);
        X(i)     = mean(acquiredData(:,6));
    end
    
    figure();
    plot(angle, X, 'bo');
    cfun = fit(X', angle', 'poly1');
    xOutputCal.slope = cfun.p1;
    xOutputCal.intercept = cfun.p2;
    hold on;
    plot(cfun.p1*X + cfun.p2, X, 'r-');
    xlabel('Arena angle (deg)');
    ylabel('Flight computer output (V)');
    title('Calibration Curve');
    
    save('./xOutputCalibration.mat','xOutputCal');
    disp(['Wrote calibration: slope = ',num2str(cfun.p1),' deg/V,  intercept = ',num2str(cfun.p2),' V']);
    
    RTTF('calibrateAngles','CalSteps',[]);
    wait(analogIn,35);

    RTTF('smoothSweepCalibrate','CalSweep',[]);
    wait(analogIn,11);
    wait(analogIn,26);

        
        
        
        