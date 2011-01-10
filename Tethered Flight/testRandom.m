% Test Random

clear all;

thresh = 0;

reps = 100000;

firstCount = 0;
secondCount = 0;

for i=1:reps
    first = randi(200)-1;
    if (thresh) > first
        firstCount = firstCount + 1;
    end
    
end

disp( firstCount / reps);