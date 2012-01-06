%% 
% padcat.m 
%
% Utility function for concatenating arrays of different sizes. Will pad
% the arrays with filler along the required dimensions. For reference see
% the MATLAB manual pages for cat() and padarray(). Works for arbitrary
% dimensionality, but only two arrays at a time. Includes integrated
% testing.
%
% Usage: 
%   C = padcat(catDim,array1,array2);
%   C = padcat(catDim,array1,array2,padVal);
%   C = padcat(catDim,array1,array2,padVal,padDir);
%
% Arguments:
%   catDim - The dimension to concatenate along (1 - vert., 2 - horiz.)
%   array1 - The first array to concatenate
%   array2 - The second array to concatenate
%   --------
%   padVal - (Optional) The value to pad the array with. 
%               [Also: 'circular','replicate','symmetric'- see padarray()]
%               Default: 0
%   padDir - (Optional) Pad 'pre' or 'post' (does not support 'both')
%               Default: 'post'
%
% Examples:
%   a = [1 1 1];
%   b = [2 2 2 2 2];
%   padcat(1,a,b)     -> [1 1 1 0 0 ; 2 2 2 2 2]
%   padcat(2,a,b)     -> [1 1 1 2 2 2 2 2]
%   padcat(1,a,b,NaN) -> [1 1 1 NaN NaN ; 2 2 2 2 2]
%   padcat(1,b,a)     -> [2 2 2 2 2 ; 1 1 1 0 0]
%
% Testing:
%      To test, run with 6 arguments [ie: padcat(0,0,0,0,0,0); ]
%
% JSB 8/2011

%%                                           (opt. args) padVal, padDir
function out = padcat(catDim, array1, array2, varargin)

    if (nargin == 6)
        % Run testing
        testPadCat();
        return;
    end

    % If there's an arg specified to pad with, use it
    if (nargin == 4)
        padVal = varargin{1};
        padDir = 'post';
    elseif (nargin == 5)
        padVal = varargin{1};
        padDir = varargin{2};
    else
        padVal = 0;
        padDir = 'post';
    end

    % Figure out which dimensions to look for mis-sizing on
    nDim1 = size(size(array1),2);
    nDim2 = size(size(array2),2);
    nDim = max([nDim1,nDim2]);
    dimListToCheck = 1:nDim;
    if ~isempty(find(dimListToCheck == catDim))
        dimListToCheck(catDim) = [];
    end

    % Make a list of how to pad each array
    array1PadList(catDim) = 0;
    array2PadList(catDim) = 0;
    for aDim = dimListToCheck
        if (size(array1,aDim) < size(array2,aDim))
            array1PadList(aDim) =  size(array2,aDim) - size(array1,aDim);
            array2PadList(aDim) = 0;
        elseif (size(array1,aDim) > size(array2,aDim))
            array1PadList(aDim) = 0;
            array2PadList(aDim) =  size(array1,aDim) - size(array2,aDim);
        else
            array1PadList(aDim) = 0;
            array2PadList(aDim) = 0;
        end           
    end
    
    % Pad the arrays
    padded1 = padarray(array1, array1PadList,padVal,padDir);
    padded2 = padarray(array2, array2PadList,padVal,padDir);

    % Concatenate and output
    out = cat(catDim, padded1, padded2);


%% Testing function: (run: padcat(0, 0, 0, 0, 0, 0); to activate)
%
    function testPadCat()
        
        disp('Testing Pad Cat:');
        disp('----------------');
        
        % 
        a = [1 1 1];
        b = [2 2 2 2 2];
        
        disp(['a = ',num2str(a)]);
        disp(['b = ',num2str(b)]);
        
        disp('---');
        disp('padcat(1,a,b);');
        c = [1 1 1 0 0; 2 2 2 2 2];
        calc = padcat(1,a,b);
        if isequal(c,calc)
            disp('Ok:');
            disp(c);
        else
            disp('FAIL'); disp(calc);
            return;
        end
        
        disp('---');
        disp('padcat(2,a,b);');
        c = [1 1 1 2 2 2 2 2];
        calc = padcat(2,a,b);
        if isequal(c,calc)
            disp('Ok:');
            disp(c);
        else
            disp('FAIL'); disp(calc);
            return;
        end
        
        disp('---');
        disp('padcat(1,a'',b'');');
        c = [1; 1; 1; 2; 2; 2; 2; 2;];
        calc = padcat(1,a',b');
        if isequal(c,calc)
            disp('Ok:');
            disp(c);
        else
            disp('FAIL'); disp(calc);
            return;
        end
        
        disp('---');
        disp('padcat(2,a'',b'');');
        c = [1 2 ; 1 2; 1 2; 0 2; 0 2];
        calc = padcat(2,a',b');
        if isequal(c,calc)
            disp('Ok:');
            disp(c);
        else
            disp('FAIL'); disp(calc);
            return;
        end
        
        disp('---');
        disp('padcat(1,a,b,7);');
        c = [1 1 1 7 7; 2 2 2 2 2];
        calc = padcat(1,a,b, 7);
        if isequal(c,calc)
            disp('Ok:');
            disp(c);
        else
            disp('FAIL'); disp(calc);
            return;
        end
        
        disp('---');
        disp('padcat(1,a,b,NaN);');
        c = [1 1 1 NaN NaN; 2 2 2 2 2];
        calc = padcat(1,a,b,NaN);
        if isequalwithequalnans(c,calc)
            disp('Ok:');
            disp(c);
        else
            disp('FAIL'); disp(calc);
            return;
        end
        
        disp('---');
        disp('padcat(1,a,b,7,''pre'');');
        c = [7 7 1 1 1; 2 2 2 2 2];
        calc = padcat(1,a,b,7,'pre');
        if isequal(c,calc)
            disp('Ok:');
            disp(c);
        else
            disp('FAIL'); disp(calc);
            return;
        end
        
        disp('---');
        disp('padcat(1,a,b,7,''post'');');
        c = [1 1 1 7 7; 2 2 2 2 2];
        calc = padcat(1,a,b,7,'post');
        if isequal(c,calc)
            disp('Ok:');
            disp(c);
        else
            disp('FAIL'); disp(calc);
            return;
        end
        
        disp('---');
        disp('padcat(3,a,b);');
        clear c;
        c(:,:,1) = [1 1 1 0 0];
        c(:,:,2) = [2 2 2 2 2];
        calc = padcat(3,a,b);
        if isequal(c,calc)
            disp('Ok:');
            disp(c);
        else
            disp('FAIL'); disp(calc);
            return;
        end
        
        disp('---');
        disp('padcat(3,a'',b'');');
        clear c;
        c(:,:,1) = [1; 1; 1; 0; 0];
        c(:,:,2) = [2; 2; 2; 2; 2];
        calc = padcat(3,a',b');
        if isequal(c,calc)
            disp('Ok:');
            disp(c);
        else
            disp('FAIL'); disp(calc);
            return;
        end
        
        disp('---');
        disp('padcat(2,padcat(1,a,b),a);');
        c = [1 1 1 0 0 1 1 1; 2 2 2 2 2 0 0 0];
        calc = padcat(2,padcat(1,a,b),a);
        if isequal(c,calc)
            disp('Ok:');
            disp(c);
        else
            disp('FAIL'); disp(calc);
            return;
        end
        
        disp('---');
        disp('padcat(1,a, padcat(1,a,b));');
        c = [1 1 1 0 0 ;1 1 1 0 0 ; 2 2 2 2 2];
        calc = padcat(1,a, padcat(1,a,b));
        if isequal(c,calc)
            disp('Ok:');
            disp(c);
        else
            disp('FAIL'); disp(calc);
            return;
        end


        disp('TEST CASES ALL PASSED');
            
            
            
        
        
        
        