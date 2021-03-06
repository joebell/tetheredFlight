function arena = drawArena(bgcolor);


offset = 10;
zoom = 1.3;
numRPanels = 12;
numHPanels = 4;
maxR = 8*numHPanels + offset;
minR = offset;
divs = 96;
green = [.6  1 .6];
grey  = [.5 .5 .5];

if (bgcolor == 0)
    arena.bgColor = grey;
    arena.drawColor = green;
else
    arena.bgColor = green;
    arena.drawColor = grey;
end

arena.maxR = maxR;
arena.minR = minR;
arena.numRPanels = numRPanels;
arena.numHPanels = numHPanels;
arena.zoom = zoom;
arena.offset = offset;



Rs = offset + (0:8:8*numHPanels).^ zoom /(8*numHPanels)^(zoom - 1);
angles = 0:2*pi/(divs):2*pi;

for j=2:size(Rs,2)
    Rmaxes = Rs(j)*ones(size(angles,2),1);
    Rmins  = Rs(j-1)*ones(size(angles,2),1);
    [X, Y] = pol2cart([0 angles angles(size(angles,2):-1:1)] + pi/numRPanels,[Rs(j-1) Rmaxes' Rmins']);
    fill(X, Y, arena.bgColor,'EdgeColor','k');
    hold on;
end
for i=1:divs/numRPanels:divs
    [X,Y] = pol2cart([angles(i) angles(i)] + pi/numRPanels,[minR maxR]);
    line(X,Y,'Color','k');
end


axis square;
set(gca, 'XTickLabel',[]);
set(gca, 'YTickLabel',[]);
set(gca, 'XTick',[]);
set(gca, 'YTick',[]);
box off;
arena.axis = gca;