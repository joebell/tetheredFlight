function grate = drawVertGrate(X, width, spacing, arena)

    grate = [];
    for i = 0:96/spacing
        agrate = drawBox(X + 360/96*i*spacing, width, 32, 1, arena);
        grate = cat(1,grate,agrate);
    end