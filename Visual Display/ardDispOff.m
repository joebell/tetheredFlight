function ardDispOff() 

    global USB;
    global ardVar;
    
   
    list = [ardVar.ee,ardVar.DisplayOff,0,0,0,0,0,ardVar.ee];
    
    fwrite(USB, uint8(size(list,2)),  'uint8','sync');
    for i=1:size(list,2)
        fwrite(USB, uint8(list(i)),  'uint8','sync');
    end
    fwrite(USB, uint8(size(list,2)),  'uint8','sync');
    for i=1:size(list,2)
        fwrite(USB, uint8(list(i)),  'uint8','sync');
    end
