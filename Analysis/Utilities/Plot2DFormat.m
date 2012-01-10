function plot2DFormat()

line(xlim(),[0 0],'Color',[0 0 0]);
line([90 90],ylim(),'Color',[0 0 0]);
line([270 270],ylim(),'Color',[0 0 0]);
xlabel('Angle (deg)');
ylabel('Speed (deg/sec)');
set(gca,'XTick',[90 270]);
set(gca, 'YTick',[-720 -360 0 360 720]);
grid off;