function cutouts = drawCutOuts(arena)

X = 90;
width = 8;
length = 8;
height = 9;

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
cutouts(1) = fill(Xs, Ys, [1 1 1],'EdgeColor','k');

X = 270;
width = 8;
length = 16;
height = 9;

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
cutouts(2) = fill(Xs, Ys, [1 1 1],'EdgeColor','k');