% flushPipes

disp(' ');
disp('--------------------------');
disp('    Flushing pipes...     ');
disp('--------------------------');
disp(' ');
ardSetColors(1,0);
ardDispOn;
for i=1:1000    
    
    ardWriteParam(ardVar.Olf1Armed, 'ffff');
    ardWriteParam(ardVar.Olf2Armed, '0000');
    ardFlip;
    pause(5);
    
    ardWriteParam(ardVar.Olf1Armed, '0000');
    ardWriteParam(ardVar.Olf2Armed, 'ffff');
    ardFlip;
    pause(5);
    disp(i);
    
    ardWriteParam(ardVar.Olf1Armed, '0000');
    ardWriteParam(ardVar.Olf2Armed, '0000');
    ardFlip;
    pause(5);
end
ardSetColors(0,1);