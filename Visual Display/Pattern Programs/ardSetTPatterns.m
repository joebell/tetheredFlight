function ardSetTPatterns(Twidth, Tlength, Theight, Xinterval, Yinterval)

    global ardVar;
    panelConstants;
    
    ardI2Cecho(SETDATA, 14, Twidth, 0, 0);
    ardI2Cecho(SETDATA, 15, Tlength, 0, 0);
    ardI2Cecho(SETDATA, 17, Theight, 0, 0);
    ardI2Cecho(SETDATA, 11, Xinterval, 0, 0);
    ardI2Cecho(SETDATA, 18, Yinterval, 0, 0);
    

    
    