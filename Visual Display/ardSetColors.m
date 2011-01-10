function ardSetColors(oncolor, offcolor)

    global ardVar;
    panelConstants;

    ardI2Cecho(SETDATA, ONVAL,   oncolor,0,0);
    ardI2Cecho(SETDATA, OFFVAL, offcolor,0,0);
    
    