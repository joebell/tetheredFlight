function bigTitle(title)

    versionString(1) = {title};

    height = .95;

    txtar = annotation('textbox',[.45 height .5 .15],'String',versionString,...
        'FontSize',12,'FitBoxToText','on','LineStyle','none',...
        'VerticalAlignment','cap','FontName','Courier');
    myPos = get(txtar,'Position');
    set(txtar,'Position',[.45,height,myPos(3),myPos(4)]);