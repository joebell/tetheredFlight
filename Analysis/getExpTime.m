%%
% With 3 arguments: histogramBounds, a Sync signal, and daqParams
% this function will maximize timing correlation with the sync signal
%
% With one argument (a number of samples) it will spit out timing based on
% the last analyzed file. Timing seems pretty stable, so that's fine.
%
%%
function expTime = getExpTime(varargin)

   if nargin == 3
       
       histogramBounds = varargin{1};
       Sync = varargin{2};
       daqParams = varargin{3};
       
       nSamples = size(Sync,1);
       disp('Generating new timing sync from file.');
   else
       nSamples = varargin{1};       
       load('timingSync.mat');     
       expTime = (1:nSamples)./(rawRate + rateError) + tOffset;
       return;
   end
   
   
   ind = find(Sync < 2.5);
   Sync(ind) = 0;
   ind = find(Sync > 2.5);
   Sync(ind) = 1;

   diffSync = abs(diff(Sync)); diffSync(end+1) = 0;
   boundsList = nonzeros(histogramBounds(:));
   
   % Range to search for best alignment
   offsetRange = -.25:.0008:-.15;
   rateRange   =  -.5:.0008:-.4;
   
   scores = [];
   [offsetNs, rateNs] = meshgrid(1:size(offsetRange,2),1:size(rateRange,2));
   for point=1:size(offsetNs(:),1) 
       offset = offsetRange(offsetNs(point));
       rate = rateRange(rateNs(point));
       alignmentScore = 0;
       for boundN=1:size(boundsList,1)
           boundTime = boundsList(boundN);
           boundSample = round((boundTime - offset).*(daqParams.SampleRate + rate));
           alignmentScore = alignmentScore + diffSync(boundSample);
           alignmentScore = alignmentScore + diffSync(boundSample+1)/2;
           alignmentScore = alignmentScore + diffSync(boundSample-1)/2;
           alignmentScore = alignmentScore + diffSync(boundSample+2)/4;
           alignmentScore = alignmentScore + diffSync(boundSample-2)/4;
           alignmentScore = alignmentScore + diffSync(boundSample+3)/8;
           alignmentScore = alignmentScore + diffSync(boundSample-3)/8;
       end
       scores(offsetNs(point),rateNs(point)) = alignmentScore;
       scoreList(point) = alignmentScore;
   end

   [bestScore,bestInd] = max(scoreList);
   bestOffset = offsetRange(offsetNs(bestInd));
   bestRate = rateRange(rateNs(bestInd));
   
   h = pcolor(offsetRange,rateRange,scores');
   set(h,'EdgeColor','none');
   hold on;
   line(xlim(),[bestRate bestRate],'Color','k');
   line([bestOffset, bestOffset],ylim(),'Color','k');
   xlabel('Timing offset (sec)');
   ylabel('Sample rate error (Hz)');
   title('Fitting to histogram bounds');
   
   expTime = (1:nSamples)./(daqParams.SampleRate + bestRate) + bestOffset;
   
   boundsRaster = zeros(nSamples,1);
   for boundN=1:size(boundsList,1)
       boundTime = boundsList(boundN);
       boundSample = round((boundTime - bestOffset).*(daqParams.SampleRate + bestRate));
       boundsRaster(boundSample) = 1;
   end
   figure();
   for n=1:10
       subplot(10,1,n);
       stSample =  round(1 + (n-1)*nSamples/10);
       endSample = round(n*nSamples/10);
       range = stSample:endSample;
       plot(expTime(range),diffSync(range),'b','LineWidth',2); hold on;
       plot(expTime(range),boundsRaster(range),'r');
       set(gca,'YTick',[]);
   end
   xlabel('Time (sec)');
   subplot(10,1,1);
   title('Timing synchronization');
   
   % Save computed offsets to file
   tOffset = bestOffset;
   rateError = bestRate;
   rawRate = daqParams.SampleRate;
   save('./timingSync.mat','tOffset','rateError','rawRate');
   
   
   
