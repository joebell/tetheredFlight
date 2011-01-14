% detailRotationStrip.m

clear all;

settings = tfSettings();

comment = 'prog4HT   0-2   LP @ 125';
fileName = [settings.dataDir,'RTTF110113-135751.mat'];


fileList{1} = fileName;
fileList{2} = fileName;
fileList{3} = fileName;
fileList{4} = fileName;

plotsPerPage = 4;
numFiles = size(fileList,2);
for file=1:numFiles    
    
    page = ceil(file/plotsPerPage);
    figure(page);
    slot = mod(file-1,plotsPerPage)+1;
    if slot == 1
        myComment = comment;
    else 
        myComment = '';
    end
    myAxis = subplot(plotsPerPage,1,slot);
    analyzeRotationStrip(fileList{file},myComment,myAxis);
    
    lims = xlim();
    span = lims(2) - lims(1);
    xlim([(file-1)*span/4 (file)*span/4]);
    
end

for page = 1:ceil(numFiles/plotsPerPage)
    figure(page);
    
        set(gcf, 'Color', 'white');
        set(gcf, 'InvertHardcopy','off');
        set(gcf,'Units','pixels');
        scnsize = get(0,'ScreenSize');
        set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [11 8.5])
        set(gcf, 'PaperPosition', [0 0 11 8.5]);
        if (page > 1)
            filenameOut = [settings.dataDir,'Detail-',comment,' p',num2str(page),'.pdf'];  
        else
            filenameOut = [settings.dataDir,'Detail-',comment,'.pdf'];  
        end
        print(gcf, '-dpdf',filenameOut);
end