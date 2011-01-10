function ardSetBox(width, length, height);

    panelConstants;

         ardI2Cecho(SETDATA, X1, width, 0, 0);
         ardI2Cecho(SETDATA, Y1, length, 0, 0);
         ardI2Cecho(SETDATA, Y3, height, 0, 0);