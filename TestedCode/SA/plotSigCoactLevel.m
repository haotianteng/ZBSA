function plotSigCoactLevel(activeNeurons,shuffeledCoActivity,sigAssSize,dtS,path2saveFigure, visFigure)
%% plot sum active neurons over time on real data    
    c=colormap;
    hFig1=figure;set(hFig1,'visible',visFigure);
    maxCoActivity=max([sum(activeNeurons),sum(shuffeledCoActivity)]);    
    bar([1:length(activeNeurons)]*(dtS/60),sum(activeNeurons));set(gca,'YLim',[0,maxCoActivity]),axis tight
    line([0,size(activeNeurons,2)]*(dtS/60),[sigAssSize,sigAssSize],'Color',[1,0,0]);colormap(gca,c)
    xlabel('Time (min)')
    xtickslabel=get(gca,'XTickLabel');
    xticks=get(gca,'XTick')*60*(1/dtS);
    prepareFigure4Save(false, path2saveFigure, [], 'coactbinthresh')

%% plot sum active neurons over time on shuffeled data   
    c=colormap;
    hFig2=figure;set(hFig2,'visible',visFigure)
    posFig = get(hFig2, 'Position');
    bar([1:length(activeNeurons)]*(dtS/60),sum(shuffeledCoActivity));axis tight;set(gca,'YLim',[0,maxCoActivity])
    line([0,size(activeNeurons,2)]*(dtS/60),[sigAssSize,sigAssSize],'Color',[1,0,0]);colormap(gca,c)
    xlabel('Time (min)')
    xtickslabel=get(gca,'XTickLabel');
    xticks=get(gca,'XTick')*60*(1/dtS);
    prepareFigure4Save(false, path2saveFigure, [], 'coactbinShuffthresh');

%% plot binary raster on real data
    hFig3=figure;set(hFig3,'visible',visFigure);
    imagesc(activeNeurons);colormap(gca,1-gray)
    set(gca,'FontSize',12,'XTick',xticks,'XTickLabel',xtickslabel)
    xlabel('Time (min)')
    prepareFigure4Save(false, path2saveFigure, [], 'coactBinRaster');

%% plot binary raster on shuffeled data
    hFig4=figure;set(hFig4,'visible',visFigure);
    posFig = get(hFig4, 'Position');
    imagesc(shuffeledCoActivity);colormap(gca,1-gray)
    set(gca,'XTick',xticks,'XTickLabel',xtickslabel)
    xlabel('Time (min)')
    prepareFigure4Save(false, path2saveFigure, [], 'coactBinShuffRaster');


