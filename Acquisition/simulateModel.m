function WBAdiff = simulateModel(cfun, smoothX)

            
            % Filter to generate smoothed X, dX
            % Was 1,8
            h=fdesign.lowpass('Fp,Fst,Ap,Ast',1,8,1,60,1000);
            da=design(h,'equiripple');
            filtX = filtfilt(da.Numerator,1,smoothX);
            filtX = filtX - mean(filtX - smoothX);
            dX = diff(filtX).*1000;    dX(end+1) = dX(end);
            
            dWBA = cfun(filtX,dX);
            %WBAdiff = cumsum(dWBA ./ 1000);
            WBAdiff = dWBA;
