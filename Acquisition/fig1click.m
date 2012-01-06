function fig1click(src,eventdata)

    global fig1Lines;

    parentAxis = get(src,'Parent');
    point = get(parentAxis,'CurrentPoint');
    
    save('fig1Markers.mat','point');
    
    initCond = point(1,1:2);
    
    if size(fig1Lines(:),1) > 0
        delete(fig1Lines(1));
        delete(fig1Lines(2));
    end
    fig1Lines(1) = line([0 640],[initCond(2) initCond(2)],'Color',[1 0 0]);
    fig1Lines(2) = line([initCond(1) initCond(1)],[0 480],'Color',[1 0 0]);
    
