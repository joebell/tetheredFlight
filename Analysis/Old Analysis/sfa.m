% Function to address a subfigure by row/column
function nOut = sfa(nRows,nCols,row,col)
    
    nOut = (row - 1)*nCols + col;

