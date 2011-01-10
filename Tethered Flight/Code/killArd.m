
if (~isempty(instrfind))
    fclose(instrfind);                           %closes matlabs open ports
end
clear('USB');
clear('arduinoVariables');
clear('power');
clear('time');
disp('Arduino deinitialized');
