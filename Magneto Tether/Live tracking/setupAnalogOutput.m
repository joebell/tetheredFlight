function analogOut = setupAnalogOutput();

    analogOut = analogoutput('mcc','0');  
    warning('off', 'daq:daqmex:propertyConfigurationError');
    addchannel(analogOut, 0);