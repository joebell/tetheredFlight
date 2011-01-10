function box = drawBox(X, width, length, height, arena)

maxR = arena.maxR;
minR = arena.minR;
numRPanels = arena.numRPanels;
numHPanels = arena.numHPanels;

bottom = mapHeight(height,arena);
top = mapHeight(height + length,arena);
left = X*2*pi/360;
right = X*2*pi/360 - width*2*pi/(numRPanels*8);
angles = left:(right - left)/31:right;
tops = top*ones(32,1);
bottoms = bottom*ones(32,1);

[Xs, Ys] = pol2cart([left left angles right right angles(32:-1:1)] + pi/numRPanels,[bottom top tops' top bottom bottoms']);
box = fill(Xs, Ys, arena.drawColor,'EdgeColor','none');




