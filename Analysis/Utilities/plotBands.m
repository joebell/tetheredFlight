function plotBands(time,dataMatrix,lineColor)

meanTrace = mean(dataMatrix,1);
semTrace  = std(dataMatrix,1)./sqrt(size(dataMatrix,1));

h = area([time;time]',[(meanTrace-semTrace);(2*semTrace)]',0);
        set(h,'EdgeColor','none');
        set(h,'FaceColor','none');
        set(h(2),'FaceColor',[.8 .8 1]);
plot(time,meanTrace,'Color',lineColor,'LineWidth',1);
