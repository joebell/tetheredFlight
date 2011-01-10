function T = drawT(X, width, length, height, upright, arena)

    T(1) = drawBox(X - 360/96*(length - width)/2, width, length, height, arena);        
    if (upright == 1)
        T(2) = drawBox(X, length, width, height + (length - width), arena);
    else
        T(2) = drawBox(X, length, width, height, arena);
    end