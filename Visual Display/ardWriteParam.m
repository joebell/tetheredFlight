function ardWriteParam(loc, val) 

    global USB;
    global ardVar;
    
    if (isstr(val))
        value = hex2dec(val);
    else
        value = val;
    end
    
    
    b1 = bitand(twoComp(value),hex2dec('00ff'));
    b2 = bitshift(twoComp(value),-8);
    
    list = [ardVar.ee,ardVar.WriteParam,loc,b1,b2,0,0,ardVar.ee];
    
    fwrite(USB, uint8(size(list,2)),  'uint8','sync');
    for i=1:size(list,2)
        fwrite(USB, uint8(list(i)),  'uint8','sync');
    end

    
