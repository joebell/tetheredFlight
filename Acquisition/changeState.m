function changeState(obj, event, newState)

    % Implement what happens when a solenoid switches or the shockable
    % state switches
    
 global ardVar;
 global digitalIO;
 
 time = newState{1};
 visParams = newState{2};
 
 ardFlip();

 if (size(newState,2) > 6) 
     cmd = newState{7};
     if (size(cmd,2) ~= 0)
        eval(cmd);
     end
 end
 
 disp(['State change at time: ',num2str(time)]);
 
 % putvalue(digitalIO, output);
 
 % Values are automatically transmitted over serial by preUpdateArduino


 
 
 
 
