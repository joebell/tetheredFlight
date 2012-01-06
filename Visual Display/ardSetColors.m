function ardSetColors(oncolor, offcolor)

    global ardVar;
    panelConstants;

    disp(['Set colors: ',num2str(oncolor),',',num2str(offcolor)]);
    
    ardI2Cecho(SETDATA, ONVAL,   oncolor,0,0);
    ardI2Cecho(SETDATA, OFFVAL, offcolor,0,0);
    
    