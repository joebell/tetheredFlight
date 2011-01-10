function laser = drawLaser(on, arena)

x = .3;
y1 = 6.7;
y2 = 23;

if (on > 2.5)
    % laser is on
    laser = fill([x x -x -x],[y1 y2 y2 y1],[1 0 0],'EdgeColor',[.7 0 0]);
else
    % laser is off
    laser = [];
end
