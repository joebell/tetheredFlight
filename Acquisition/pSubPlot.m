function ax = pSubPlot(figH,row,col,plotN,axisN)

    global subPlots;
    
    if ~isfield(subPlots,'figures')
        subPlots.figures = [];
        subPlots.sizes = [];
        subPlots.axes = [];
    end
    
    % If it's a new figure, make it.
    if isempty(find(subPlots.figures == figH))
        subPlots.figures(end+1) = figure(figH);
        subPlots.sizes(end+1,:) = [row,col];
        for i=1:(row*col)
            subPlots.axes(end+1,i,end+1) = subplot(row,col,i);            
        end
    end
    
    figIdx = find(subPlots.figures == figH);
    figure(figIdx);
    % Add "if it's the wrong size, remake it"
    if (axisN > size(subPlots.axes(figIdx,plotN,:),1))
        ax1 = subPlots.axes(figIdx,plotN,end);
        set(ax1,'Color','none');
        ax = axes('Position',get(ax1,'Position'),...
                    'XAxisLocation','top',...
                    'YAxisLocation','right',...
                    'Color','none',...
                    'XColor','k','YColor','k');
        subPlots.axes(figIdx,plotN,end+1) = ax;
    else
        ax = subPlots.axes(figIdx,plotN,axisN);
    end

    
    