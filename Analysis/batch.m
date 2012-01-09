%% batch

%fileList = returnFileList('111229-ACV-2-POLBS');
fileList = 14;

epochRanges = [2];
preTime = -2;
postTime = 2;

figure(); hold on;
[traces, timeTrace] = accumulateXTraces(fileList,epochRanges, preTime, postTime);
for i=1:size(traces,1)
    plot(timeTrace,traces(i,:));
end
xlim([timeTrace(1) timeTrace(end)]);
ylim([0 360]);

figure(); hold on;
[traces, timeTrace] = accumulatedXTraces(fileList,epochRanges, preTime, postTime);
for i=1:size(traces,1)
    plot(timeTrace,traces(i,:));
end
xlim([timeTrace(1) timeTrace(end)]);
ylim([-200 200]);