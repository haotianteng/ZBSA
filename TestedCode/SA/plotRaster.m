function plotRaster(plottedSortTable, rasterAlltrials, frameRateHz,path2saveFigure,visFigure)
%% plot raster of all trials
 hFig1=figure;set(hFig1,'Visible',visFigure);
 peakVisual=prctile(rasterAlltrials(:),98);
 imagesc(rasterAlltrials,[0,peakVisual]) ;h=colorbar;
 ylabel(h,'\DeltaF/F','FontSize',12)
 detlaXTick=8; % in minutes
 nFramesperDeltaTick=detlaXTick*60*frameRateHz;
 ticks=round(nFramesperDeltaTick:nFramesperDeltaTick:size(rasterAlltrials,2));
 set(gca,'XTick',ticks,'XTicklabel',detlaXTick*[1:length(ticks)]);
 xlabel('Time(min)');
 set(gca,'YTick',[40,80,120]);
 ylabel('Neurons')
  prepareFigure4Save(false, path2saveFigure, [], 'rasterAllTrials')
end
