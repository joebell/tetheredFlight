% batchAnalyzeTracks

directory = './Data/Apr21/';
fileStem  = 'RTTF100421-';

fileList = dir([directory,fileStem,'*.mat']);

for file=1:size(fileList,1)
    
    analyzeRTTF([directory,fileList(file).name],'');
    
    figure(1);

        set(gcf, 'Color', 'white');
        set(gcf, 'InvertHardcopy','off');
        set(gcf,'Units','pixels');
        scnsize = get(0,'ScreenSize');
        set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [11 8.5])
        set(gcf, 'PaperPosition', [0 0 11 8.5]);
        filenameOut = [directory,fileList(file).name];
        filenameOut = strrep(filenameOut,'.mat','Q.pdf');
        print(gcf, '-dpdf',filenameOut);
        close gcf;
    
    figure(2);
    
        set(gcf, 'Color', 'white');
        set(gcf, 'InvertHardcopy','off');
        set(gcf,'Units','pixels');
        scnsize = get(0,'ScreenSize');
        set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [11 8.5])
        set(gcf, 'PaperPosition', [0 0 11 8.5]);
        filenameOut = [directory,fileList(file).name];
        filenameOut = strrep(filenameOut,'.mat','R.pdf');
        print(gcf, '-dpdf',filenameOut);
        close gcf;

    clear global;   
    
end