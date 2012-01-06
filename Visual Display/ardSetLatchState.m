function ardSetLatchState(laser,olf1,olf2,olf3)

    global ardVar;

    value = 0;
    if (laser)
        value = value + bitshift(1,0);
    end
    if (olf1)
        value = value + bitshift(1,1);
    end
    if (olf2)
        value = value + bitshift(1,2);
    end
    if (olf3)
        value = value + bitshift(1,3);
    end
    
    ardWriteParam(ardVar.LatchState, value);
    ardFlip;
