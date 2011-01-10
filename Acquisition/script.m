
command = [7/7,1/7,4/7,2/7,6/7,3/7,5/7,2/15,1/15,1/31];
read = [207,33,124,64,182,96,143,31,15,5];

plot(command,read,'o');
xlabel('Greenscale command');
ylabel('Luminance (lux)');
title('Arena luminance control');
xlim([0,1.1]);