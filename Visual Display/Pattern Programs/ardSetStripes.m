function ardSetStripes(width, spacing)

    global ardVar;
    panelConstants;
    

    ardI2Cecho(SETDATA, X1, width, 0, 0);
    ardI2Cecho(SETDATA, X2, spacing, 0, 0);
    
    
    