function plotRealTrajectory(src, eventdata, fileList,epochRanges, preTime, postTime)

    parentAxis = get(src,'Parent');
    point = get(parentAxis,'CurrentPoint');
    
    startingPoint = point(1,1:2);

tolX = 2;
toldX = 5;
length = .75;
smoothX = false;
[xTraces, dXTraces, WBATraces, dWBATraces, times] = getTrajectories(fileList,epochRanges, preTime, postTime, startingPoint, tolX, toldX, length, smoothX);
disp(['Found ',num2str(size(xTraces,1)),' segments.']);
for i=1:size(xTraces,1)
    xTrace = xTraces(i,:);
    diffX = diff(xTrace);
    ind = find(abs(diffX) > 180);
    xTrace(ind+1) = NaN;
    plot(xTrace,dXTraces(i,:),'b');
end