function saveToPDF(name)

        set(gcf, 'Color', 'white');
        set(gcf, 'InvertHardcopy','off');
        set(gcf,'Units','pixels');
        scnsize = get(0,'ScreenSize');
        set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [11 8.5])
        set(gcf, 'PaperPosition', [0 0 11 8.5]);   
        settings = tfSettings();
        filenameOut = [settings.dataDir,name,'.pdf'];
        print(gcf, '-dpdf',filenameOut);