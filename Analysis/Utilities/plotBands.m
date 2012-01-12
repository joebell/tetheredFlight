function plotBands(time,dataMatrix,lineColor)

meanTrace = mean(dataMatrix,1);
semTrace  = std(dataMatrix,1)./sqrt(size(dataMatrix,1));
hold on;
h = area([time;time]',[(meanTrace-semTrace);(2*semTrace)]',0);
pause();
        set(h,'EdgeColor','none');
        set(h,'FaceColor','none');
        if lineColor == 'r'
            set(h(2),'FaceColor',[1 .8 .8]);
        else    
            set(h(2),'FaceColor',[.8 .8 1]);
        end
pause();        
plot(time,meanTrace,'Color',lineColor,'LineWidth',1);
pause();
