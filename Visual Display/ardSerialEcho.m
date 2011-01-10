function out = ardSerialEcho(loc) 

    global USB;
    global ardVar;

    list = [ardVar.ee,ardVar.SerialEcho,loc,0,0,0,0,ardVar.ee];
    
    fwrite(USB, uint8(size(list,2)),  'uint8','sync');
    for i=1:size(list,2)
        fwrite(USB, uint8(list(i)),  'uint8','sync');
    end

       
    num = fread(USB, 2, 'uint8');   
    
    % Convert back from two's complement
    usout = num(1) + bitshift(num(2),8);
    if (usout >= (2^15))
        out = usout - 2^16;
    else 
        out = usout;
    end
    
    
    