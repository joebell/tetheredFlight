%%
function modelFun = fitModel(means, n, rangeX, rangedX)


% %% Generate the fitting object
% 
% nExponential = 5;
% nPeriodic = 5;
% 
%         terms = {};
%         coeffs = {};
%         nc = 1;
%         for p= 0:nExponential
%             for m= 1:nPeriodic
%                 terms{end + 1} = ['(v^',num2str(p),')*sin(x*(2*pi/360)*',num2str(m),')'];
%                 coeffs{end + 1} = ['c',num2str(nc)];
%                 nc = nc + 1;
%                 terms{end + 1} = ['(v^',num2str(p),')*cos(x*(2*pi/360)*',num2str(m),')'];
%                 coeffs{end + 1} = ['c',num2str(nc)];
%                 nc = nc + 1;
%             end
%             terms{end + 1} = ['(v^',num2str(p),')'];
%             coeffs{end + 1} = ['c',num2str(nc)];
%             nc = nc + 1;
%         end
%         ffun = fittype(terms,'coefficients',coeffs,'independent',{'x','v'});

%% Generate a fitting object
% This one is fourier is X and dX, with dX clamped to zero at borders.

nInX = 8;
nIndX = 8;

        dXspan = rangedX(end) - rangedX(1);
        terms = {};
        coeffs = {};
        nc = 1;
        
        for p = 1:nIndX
            for m =0:nInX 
                if ((p > 0) && (round(p/2) == (p/2)))
                    fToUse = 'sin';
                else
                    fToUse = 'cos';
                end
                if (m > 0)
                    terms{end + 1} = [fToUse,'(pi*v*',num2str(p/dXspan),')*sin(x*(2*pi/360)*',num2str(m),')'];
                    coeffs{end + 1} = ['c',num2str(nc)];
                    nc = nc + 1;
                end
                terms{end + 1} = [fToUse,'(pi*v*',num2str(p/dXspan),')*cos(x*(2*pi/360)*',num2str(m),')'];
                coeffs{end + 1} = ['c',num2str(nc)];
                nc = nc + 1;
            end
        end
        ffun = fittype(terms,'coefficients',coeffs,'independent',{'x','v'});
        
 %% Do the fit
 
        [angleFit,speedFit] = meshgrid(rangeX,rangedX);

        dataToFit = means';
        weights = n'./50 + 1;
        weights = weights.^(1);
        
%         figure();
%         h = pcolor(weights);
%         set(h,'EdgeColor','none');
%         colorbar;
%         figure();
        
    % Weight by the number of points in each bin
    options = fitoptions('Weights',weights(:),'Method','LinearLeastSquares');
    [modelFun,gof,output] = fit([angleFit(:),speedFit(:)],dataToFit(:),ffun,options);
    %[modelFun,gof,output] = fit([angleFit(:),speedFit(:)],dataToFit(:),ffun);
         
    
