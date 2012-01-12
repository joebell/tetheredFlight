
ind = find(isnan(dataMatrix));
newDataMatrix = dataMatrix;
newDataMatrix(ind) = 0;

meanTrace = mean(newDataMatrix,1);
semTrace  = std(newDataMatrix,1)./sqrt(size(newDataMatrix,1));


h = area([time;time]',[(meanTrace-semTrace);(2*semTrace)]',0);