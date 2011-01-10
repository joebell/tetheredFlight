function ardI2Cecho(b1, b2, b3, b4, b5) 

    global USB;
    global ardVar;
       
    list = [ardVar.ee,ardVar.I2Cecho,b1,b2,b3,b4,b5,ardVar.ee];
    
    fwrite(USB, uint8(size(list,2)),  'uint8','sync');
    for i=1:size(list,2)
        fwrite(USB, uint8(list(i)),  'uint8','sync');
    end
    pause(.01);