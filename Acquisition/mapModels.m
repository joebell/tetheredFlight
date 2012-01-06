function mapModels()

settings = tfSettings();
models   = 'DynModels-111215-1631.mat';

load([settings.dataDir,models]);
noOdorModel = fitModels{2};
odorModel = fitModels{5};
rangeX = 3.75:3.75:360;
range1 =-720:7.5:720;
range2 =-180:4:180;

noOdorModelFig = figure();
odorModelFig = figure();
differenceFig = figure();

figure(noOdorModelFig); hold on;

        h = plot(noOdorModel,'Style','Contour','XLim',[3.75 360],'YLim',[range1(1) range1(end)]);
        set(h,'EdgeColor','none');
        levelList = range2(1):(range2(end)-range2(1))/20:range2(end);
        set(h,'LevelList',levelList);  
        set(h,'ButtonDownFcn',{@plotTrajectory,noOdorModel});
        line(xlim(),[0 0],'Color',[0 0 0]);
        line([90 90],ylim(),'Color',[0 0 0]);
        line([270 270],ylim(),'Color',[0 0 0]);
        title('Modeled dWBA/dt No Odor');
        
        
figure(odorModelFig); hold on;

        h = plot(odorModel,'Style','Contour','XLim',[3.75 360],'YLim',[range1(1) range1(end)]);
        set(h,'EdgeColor','none');
        levelList = range2(1):(range2(end)-range2(1))/20:range2(end);
        set(h,'LevelList',levelList);  
        set(h,'ButtonDownFcn',{@plotTrajectory,odorModel});
        line(xlim(),[0 0],'Color',[0 0 0]);
        line([90 90],ylim(),'Color',[0 0 0]);
        line([270 270],ylim(),'Color',[0 0 0]);
        title('Modeled dWBA/dt Odor');
        
figure(differenceFig); hold on;

        [X, dX] = meshgrid(rangeX,range1);
        responses = (odorModel(X,dX) - noOdorModel(X,dX));
        
        h = pcolor(rangeX,range1,responses);
        set(h,'EdgeColor','none');
        xlim([rangeX(1) rangeX(end)]);
        ylim([range1(1) range1(end)]);

%         h = plot(odorModel - noOdorModel,'Style','Contour','XLim',[3.75 360],'YLim',[range1(1) range1(end)]);
%         set(h,'EdgeColor','none');
%         levelList = range2(1):(range2(end)-range2(1))/20:range2(end);
%         set(h,'LevelList',levelList);  
%         set(h,'ButtonDownFcn',{@plotTrajectory,odorModel});
        line(xlim(),[0 0],'Color',[0 0 0]);
        line([90 90],ylim(),'Color',[0 0 0]);
        line([270 270],ylim(),'Color',[0 0 0]);
        title('Modeled dWBA/dt difference, Odor - no Odor');
        
     