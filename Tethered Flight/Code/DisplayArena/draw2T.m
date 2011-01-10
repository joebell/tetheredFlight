function T = draw2T(X, width, length, height, arena)

    Tup = drawT(X + 180, width, length, height, 1, arena);
    Tdown = drawT(X + 0, width, length, height, 0, arena);
    
    T = cat(1, Tup, Tdown);