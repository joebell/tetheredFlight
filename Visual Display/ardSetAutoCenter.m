function ardSetAutoCenter(mode)

    % Mode 0 is no auto-centering
    % Mode 1 is auto-centering
    % mode 2 is auto-centering, auto-variance controlled gain

    global ardVar;

    ardWriteParam(ardVar.CenterMode, mode); 
    ardFlip();
        