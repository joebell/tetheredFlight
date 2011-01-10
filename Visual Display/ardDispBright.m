function ardDispBright() 

    CLEARBUFF   = hex2dec('00');
    FLIPBUFF    = hex2dec('01');

    ardDispOff();
    ardI2Cecho(CLEARBUFF,1,0,0,0);
    ardI2Cecho(FLIPBUFF,0,0,0,0);
    