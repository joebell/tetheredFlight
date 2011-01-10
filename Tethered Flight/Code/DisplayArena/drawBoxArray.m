function boxArray = drawBoxArray(X, width, length, height, spacing, arena)

    boxArray = [];
    for i = 0:96/spacing
        aBox = drawBox(X + 360/96*i*spacing, width, length, height, arena);
        boxArray = cat(1,boxArray,aBox);
    end