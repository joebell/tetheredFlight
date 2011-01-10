function resetArenaCoords()

    FIRMWARE    = hex2dec('02');

     for addr=1:48
        xStart = 1 + mod(addr-1,12)*8;
        yStart = floor((addr-1)/12)*8 + 1;
        ardI2Cecho(FIRMWARE, addr, 1, xStart, yStart);
        pause(.25);
        disp(['Prog: ',num2str(addr),' to X: ',num2str(xStart),' Y: ',num2str(yStart)]);
     end

     ardI2Cecho(FIRMWARE, 22, 1, 1, 1);
     pause(.25);
     ardI2Cecho(FIRMWARE, 28, 9, 1, 1);
     pause(.25);
     ardI2Cecho(FIRMWARE, 49, 1, 1, 9);
     pause(.25);
     ardI2Cecho(FIRMWARE, 50, 9, 1, 9);