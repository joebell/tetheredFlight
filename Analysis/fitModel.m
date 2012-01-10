%%
function modelFun = fitModel(means, n, rangeX, rangedX)

%% Number of terms to fit
nExponential = 5;
nPeriodic = 5;

%% Generate the fitting object
        terms = {};
        coeffs = {};
        nc = 1;
        for p= 0:nExponential
            for m= 1:nPeriodic
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

 %% Do the fit
 
        [angleFit,speedFit] = meshgrid(rangeX,rangedX);
        dataToFit = means';
 
    % Weight by the number of points in each bin
    options = fitoptions('Weights',n(:));
    [modelFun,gof,output] = fit([angleFit(:),speedFit(:)],dataToFit(:),ffun,options);
        
    
