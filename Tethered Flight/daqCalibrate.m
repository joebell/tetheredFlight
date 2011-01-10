function daqCalibrate()

    daqSettings();
    global analogIn;
    
    set(analogIn, 'SamplesPerTrigger',uint32(1000));
    
    start(analogIn);
    wait(analogIn, 3);
    acquiredData = getdata(analogIn);
    
    disp(mean(acquiredData));
    

    
    