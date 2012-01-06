function fig2click(src,eventdata)

    global fig2Lines;

    parentAxis = get(src,'Parent');
    point = get(parentAxis,'CurrentPoint');
    
    save('fig2Markers.mat','point');
    
    initCond = point(1,1:2);
    
    if size(fig2Lines(:),1) > 0
        delete(fig2Lines(1));
        delete(fig2Lines(2));
    end
    fig2Lines(1) = line([0 640],[initCond(2) initCond(2)],'Color',[1 0 0]);
    fig2Lines(2) = line([initCond(1) initCond(1)],[0 480],'Color',[1 0 0]);
    
