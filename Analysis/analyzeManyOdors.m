function analyzeManyOdors()

% Histogram range parameters
rangeX = 7.5:7.5:360;
nRangeX = size(rangeX,2);
bigMaxY = 10;
littleMaxY = 5;

baseCode = '110118-';

odorList = {...
        'EV',...
        'H2O',...
        'PO',...
        '8AC-2',...
        'ACV-1',...
        'ACV-2',...
        'ACV-4',...
        'ACV-6',...
        'MeS-2',...
        'Benz-3',...
        'Butyric-2',...
        '3MT1P-2',...
        'ETA-9',...
        'Phenyl-2',...
        'GerAc-2',...
        'EtOH-2'
};

for odorN = 1:size(odorList,2)
    experiment = [baseCode, odorList{odorN}];
    
    fileList = returnFileList(experiment); 
    
    figureN = floor((odorN-1)/4) + 1;    
    figure(figureN);
    rowN = mod(odorN-1,4)+1;
    
    for epoch = 1:6
        subplot(4,6,sfa(4,6, rowN, epoch)); hold on;
        preTime = 0;
        if (epoch == 1)
            postTime = 599;
            maxY = bigMaxY;
        else
            postTime = 120;
            maxY = littleMaxY;
        end 
        if ((epoch == 1) || (epoch == 2))
            plotColor = 'b';
        elseif ((epoch == 3) || (epoch == 5))
            plotColor = 'g';
        else
            plotColor = 'r';
        end
        [ns, rangeX] = accumulateMultiHistogram(fileList,epoch, preTime, postTime, rangeX);
        ns = ns ./ (sum(ns(1,:))/nRangeX);
        plotBands(rangeX,ns,plotColor);
        ylim([0 maxY]);
        xlim([rangeX(1) rangeX(end)]);
        line([90 90],ylim(),'Color','k');
        line([270 270],ylim(),'Color','k');
        set(gca,'XTick',[90 270]);
        set(gca,'YTick',[0, 1, maxY]);
        if (epoch == 1)
            ylabel(odorList{odorN});
        end
    end
    if rowN == 1
        subplot(4,6,sfa(4,6, 1, 1)); hold on;
        title('Vert. Bar');
        subplot(4,6,sfa(4,6, 1, 2)); hold on;
        title('Box');
         subplot(4,6,sfa(4,6, 1, 3)); hold on;
        title('Box + EV');
         subplot(4,6,sfa(4,6, 1, 4)); hold on;
        title('Box + Odor');
         subplot(4,6,sfa(4,6, 1, 5)); hold on;
        title('Box + EV');
         subplot(4,6,sfa(4,6, 1, 6)); hold on;
        title('Box + Odor');
    end
      
end

for figureN = 1:4
    figure(figureN);
    figList{figureN} = gcf;
    codeStampFigure();
end
saveMultiPage(figList,'MultiOdorSummary');
    