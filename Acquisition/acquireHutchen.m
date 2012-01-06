function acquireHutchen(length)

     sampleRate = 25000;

     analogIn = analoginput('mcc','1');  
%    set(analogIn, 'InputType','SingleEnded');  % Unused on mcc boards
     warning('off', 'daq:daqmex:propertyConfigurationError');
     set(analogIn, 'SampleRate', sampleRate);
     addchannel(analogIn, 0:1, {'L','R'});
     
     set(analogIn, 'SamplesPerTrigger',uint32(length*sampleRate));
     
     start(analogIn);     
     wait(analogIn, length + 1);
     acquired = getdata(analogIn);
     
     hutchens.L = acquired(:,1);
     hutchens.R = acquired(:,2);
     hutchens.time = (1:size(acquired,1)) ./ sampleRate;

     hutchFig = figure();
     subplot(3,1,1);
     plot(hutchens.time,hutchens.L,'b');
     hold on;
     plot(hutchens.time,hutchens.R,'r');
     xlabel('Time (s)');
     ylabel('Hutchens (V)');
     xlim([1 1.05]);
     subplot(3,1,2);
     plot(hutchens.time,hutchens.L,'b');
     hold on;
     plot(hutchens.time,hutchens.R,'r');
     xlabel('Time (s)');
     ylabel('Hutchens (V)');
     xlim([1.25 1.3]);
     subplot(3,1,3);
     plot(hutchens.time,hutchens.L,'b');
     hold on;
     plot(hutchens.time,hutchens.R,'r');
     xlabel('Time (s)');
     ylabel('Hutchens (V)');
     xlim([1.5 1.55]);
     
    TimeRun = now;
    time = datestr(TimeRun, 'yymmdd-HHMMSS');
    filename = ['HUTCHEN',time,'.pdf'];
    datafilename = ['HUTCHEN',time,'.mat'];
    saveExperimentData('Hutchens',datafilename,'hutchens');
    
    figure(hutchFig);
    subplot(3,1,1);   
    settings = dataCzarSettings();   
    title(filename);
     
        set(gcf, 'Color', 'white');
        set(gcf, 'InvertHardcopy','off');
        set(gcf,'Units','pixels');
        scnsize = get(0,'ScreenSize');
        set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [11 8.5])
        set(gcf, 'PaperPosition', [0 0 11 8.5]);
        print(gcf, '-dpdf',[settings.dataDir,filename]);
     
     
        