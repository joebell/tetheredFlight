function [X,dX,t] = runSystem(initCond,f,maxT)



[t,Y] = ode15s(@F,[0 maxT],initCond);

X = Y(:,1);
dX = Y(:,2);

    function dy = F(ts,x)
        dy(1) = x(2);
        dy(2) = f(x');         
        dy = dy(:);
    end

end

