function histReadyX = histReady(wrappedX)

    histReadyX = wrappedX;
    ind = find(histReadyX == 0);   histReadyX(ind) = 360;
    ind = find(isnan(histReadyX)); histReadyX(ind) = 360;
    histReadyX = histReadyX'; 