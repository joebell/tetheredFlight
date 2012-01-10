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
    
    function [X,dX,t] = runSystem(initCond,f,maxT)


    options = odeset('RelTol',10^-5,'Refine',50);
    [t,Y] = ode15s(@F,[0 maxT],initCond,options);

    X = Y(:,1);
    dX = Y(:,2);

        function dy = F(ts,x)
            dy(1) = x(2);
            dy(2) = f(x');         
            dy = dy(:);
        end

    end
end

