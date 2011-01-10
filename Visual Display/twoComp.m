function out = twoComp(number)

%
% This function calculates the 16 bit two's complement representation of a
% negative number.  Because apparently MATLAB can't do this?
%

if (number > (2^15)-1) || (number < -(2^15))
    % disp('Two''s complement overflow...');
    out = number;
elseif (number < 0)   
    out = (2^16) - abs(number);
else
    out = number;
end

