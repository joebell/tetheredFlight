close all;
clear all;

x = 0:2:360;
v = -100:100;

xs = [];
vs = [];
data = [];
    for xi = 1:size(x,2)
        for vi = 1:size(v,2)
            xs(end+1) = x(xi);
            vs(end+1) = v(vi);
            data(end+1) = 10*(sin(4*x(xi)*(2*pi/360)) + v(vi)/100 + (rand() - .5));
            y(xi,vi) = data(end);
        end
    end


subplot(2,1,1);
colormap(jet);
h = pcolor(x,v,y');
set(h,'EdgeColor','none');
colorbar();


terms = {};
coeffs = {};
nc = 1;
for p= 0:5
    for m= 1:5
        terms{end + 1} = ['(v^',num2str(p),')*sin(x*(2*pi/360)*',num2str(m),')'];
        coeffs{end + 1} = ['c',num2str(nc)];
        nc = nc + 1;
        terms{end + 1} = ['(v^',num2str(p),')*cos(x*(2*pi/360)*',num2str(m),')'];
        coeffs{end + 1} = ['c',num2str(nc)];
        nc = nc + 1;
    end
    terms{end + 1} = ['(v^',num2str(p),')'];
    coeffs{end + 1} = ['c',num2str(nc)];
    nc = nc + 1;
end
ffun = fittype(terms,'coefficients',coeffs,'independent',{'x','v'});
[cfun,gof,output] = fit([xs',vs'],data',ffun);
subplot(2,1,2);
h = plot(cfun,'Style','Contour','XLim',[0,360]);
set(h,'EdgeColor','none');
colorbar();
set(h,'LevelList',[-20:4:20]);

set(h,'ButtonDownFcn',{@plotTrajectory,cfun});
