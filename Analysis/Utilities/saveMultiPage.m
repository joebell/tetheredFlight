function saveMultiPage(figList,experimentName)

settings = dataCzarSettings();
batchName = [settings.dataDir,'BAT',experimentName,'.pdf'];
for fig = 1:size(figList,2)
    
    figure(fig);
   
    set(gcf, 'Color', 'white');
    set(gcf, 'InvertHardcopy','off');
    set(gcf,'Units','pixels');
    scnsize = get(0,'ScreenSize');
    set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [11 8.5])
    set(gcf, 'PaperPosition', [0 0 11 8.5]);
        
    filenameOut{fig} = [settings.dataDir,'multi',num2str(fig),'.pdf'];
    print(gcf, '-dpdf',filenameOut{fig});
    append_pdfs(batchName, filenameOut{fig});
    delete(filenameOut{fig});
end



