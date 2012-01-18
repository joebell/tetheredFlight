function plotBands(time,dataMatrix,lineColor)

% Protect against NaN's
ind = find(isnan(dataMatrix));
dataMatrix(ind) = 0;

meanTrace = mean(dataMatrix,1);
semTrace  = std(dataMatrix,1)./sqrt(size(dataMatrix,1));
hold on;

%h = area([time;time]',[(meanTrace-semTrace);(2*semTrace)]',-1);
h = joeArea(time,meanTrace-semTrace,meanTrace+semTrace);

        set(h,'EdgeColor','none');
        set(h,'FaceColor',lineColor);
        set(h,'FaceAlpha',.3);

        
plot(time,meanTrace,'Color',lineColor,'LineWidth',1);

