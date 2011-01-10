function remapPanelAddress(from, to)

    if (isstr(from))
        src = hex2dec(from);
    else 
        src = from;
    end

    if (isstr(to))
        dest = hex2dec(to);
    else
        dest = to;
    end


    FIRMWARE    = hex2dec('02');
    ardI2Cecho(FIRMWARE, src, 0, dest, 0);
