function arena = drawBG()

A = imread('smallunTetheredFly.jpg');

scale = 8.5;
x = 150/(2*scale);
y = 118/(2*scale);

arena = drawArena(1);
image(A, 'XData',[-x x],'YData',[-y y]);
hold on;
arena = drawArena(1);