function T = draw4T(X, width, length, height, arena)

    Tup1 = drawT(X + 90, width, length, height, 1, arena);
    Tup2 = drawT(X + 270, width, length, height, 1, arena);
    Tdown1 = drawT(X + 0, width, length, height, 0, arena);
    Tdown2 = drawT(X + 180, width, length, height, 0, arena);
    
    T = cat(1, Tup1, Tup2, Tdown1, Tdown2);
