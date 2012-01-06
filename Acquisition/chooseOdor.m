function chooseOdor()

    number = randi(6);
    
    disp('Randomized Odor To Run:');
    
    if (number == 1) 
        disp('EV');
    elseif (number == 2)
        disp('ACV @ 0');
    elseif (number == 3)
        disp('ACV @ -1');
    elseif (number == 4)
        disp('ACV @ -2');
    elseif (number == 5)
        disp('MeS @ -2');
    elseif (number == 6)
        disp('ETA @ -6');    
    end
        