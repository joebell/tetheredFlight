function plotTrajectory(src, eventdata, cfun)

    parentAxis = get(src,'Parent');
    point = get(parentAxis,'CurrentPoint');
    
    initCond = point(1,1:2);

    tMax  = 10;

    [xt,dxt,t] = runSystem(initCond,cfun,tMax);
    hold on;
    xt = mod(xt,360);
    ind = find(abs(xt(2:end) - xt(1:(end-1))) > 180);
    xt(ind+1) = NaN;
    ylims = ylim();
    ind = find(dxt > ylims(2)); dxt(ind) = NaN;
    ind = find(dxt < ylims(1)); dxt(ind) = NaN;
    plot(xt(1),dxt(1),'.');
    plot(xt,dxt,'k','LineWidth',1);
    
