function odor = drawOdor(on, arena)

x = 1.8;
y1 = -9;
y2 = -31.8;

if (on > 2.5)
    % odor is on
    %odor1 = fill([4 1 -1 -4],[-2 y1 y1 -2],[.5 .5 .9],'EdgeColor','none','FaceAlpha',1);
    odor2 = line([4 1],[3 y1],'Color',[.5 .5 .9],'LineWidth',1.1);
    odor3 = line([-4 -1],[3 y1],'Color',[.5 .5 .9],'LineWidth',1.1);
    odor4 = line([-2 -.5],[3 y1],'Color',[.5 .5 .9],'LineWidth',1.1);
    odor5 = line([2 .5],[3 y1],'Color',[.5 .5 .9],'LineWidth',1.1);
    odor1 = fill([x x -x -x],[y1 y2 y2 y1],[.5 .5 .9],'EdgeColor',[.3 .3 .5],'FaceAlpha',1);   
    odor = [odor1, odor2, odor3, odor4, odor5];
else
    % odor is off
    % odor = fill([x x -x -x],[y1 y2 y2 y1],[.6 .6 1],'EdgeColor',[.4 .4 .7],'FaceAlpha',0);
    odor1 = fill([x x -x -x],[y1 y2 y2 y1],[.8 .8 .8],'EdgeColor',[.3 .3 .5],'FaceAlpha',1);
    odor2 = line([4 1],[3 y1],'Color',[.6 .6 .6],'LineWidth',1);
    odor3 = line([-4 -1],[3 y1],'Color',[.6 .6 .6],'LineWidth',1);
    odor4 = line([-2 -.5],[3 y1],'Color',[.6 .6 .6],'LineWidth',1);
    odor5 = line([2 .5],[3 y1],'Color',[.6 .6 .6],'LineWidth',1);
    odor = [odor1, odor2, odor3, odor4, odor5];
end