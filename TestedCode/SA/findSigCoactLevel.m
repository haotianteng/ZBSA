%Find the significant line for significant assemblies
function [sigAssSize,shuffeledCoActivity]=findSigCoactLevel(activeNeurons, pVal)
%,plotOn,path2save, dtS visible
%Input:  activeNeurons - Thresholded activity matrix (nCellsxnFrames)
%        pVal          - significance level
%        plotOn        - true or false 
%Output: Number of co-active at the significance level requested
orgActiveNeurons=activeNeurons;
shuffeledCoActivity=activeNeurons;
nShuffles=1000; 
nTimeBins=size(activeNeurons,2);
nCells=size(activeNeurons,1);
coActive=zeros(nShuffles,nTimeBins);
for shuffInd=1:nShuffles
    shuffeledCoActivity=activeNeurons;
    for i=1:size(activeNeurons,1)
        p = randperm(size(activeNeurons,2));
        orgNeuron=orgActiveNeurons(i,:);
        shuffeledCoActivity(i,:)=orgNeuron(p);
    end
coActive(shuffInd,:)=sum(shuffeledCoActivity);
end
sigAssSize=prctile(coActive(:),(1-pVal)*100);
% maxCoActivity=max([sum(activeNeurons),sum(shuffeledCoActivity)]);
% activeFrameInd=find(sum(activeNeurons)>sigAssSize);

%--------------------------------------------------------------------------
% [pks,pksInd] = findpeaks(sum(activeNeurons));
% sigPeaksInd=find(pks>sigAssSize);
% sigPeakFrames=pksInd(sigPeaksInd);

if 0
    c=colormap;
    hFig4=figure;set(hFig4,'visible',vis);
    posFig = get(hFig4, 'Position');
    posFig(4) = posFig(4)*1.6;
    posFig(2) = posFig(2)*0.7;
    bar([1:length(activeNeurons)]*(dtS/60),sum(activeNeurons));set(gca,'YLim',[0,maxCoActivity]),axis tight
    line([0,size(activeNeurons,2)]*(dtS/60),[prctile(coActive(:),95),prctile(coActive(:),95)],'Color',[1,0,0]);colormap(gca,c)
    set(gca,'FontSize',12)
    xlabel('Time (min)')
    set(gcf, 'Color', 'w');
    set(gcf, 'Units', 'Centimeters', 'Position', [0 0 10 4]);
    export_fig(strcat(path2save,'coactbinthresh.pdf'));
    xtickslabel=get(gca,'XTickLabel');
    xticks=get(gca,'XTick')*60*(1/dtS);

    
    c=colormap;
    hFig4=figure;set(hFig4,'visible',vis)
    posFig = get(hFig4, 'Position');
    posFig(4) = posFig(4)*1.6;
    posFig(2) = posFig(2)*0.7;
    bar([1:length(activeNeurons)]*(dtS/60),sum(shuffeledCoActivity));axis tight;set(gca,'YLim',[0,maxCoActivity])
    line([0,size(activeNeurons,2)]*(dtS/60),[prctile(coActive(:),95),prctile(coActive(:),95)],'Color',[1,0,0]);colormap(gca,c)
    set(gca,'FontSize',12)
    xlabel('Time (min)')
    set(gcf, 'Color', 'w');
    set(gcf, 'Units', 'Centimeters', 'Position', [0 0 10 4]);
    export_fig(strcat(path2save,'coactbinShuffthresh.pdf'));
    xtickslabel=get(gca,'XTickLabel');
    xticks=get(gca,'XTick')*60*(1/dtS);


    
    
    hFig3=figure;set(hFig3,'visible',vis);
    posFig = get(hFig3, 'Position');
    posFig(4) = posFig(4)*1.6;
    posFig(2) = posFig(2)*0.7;
    imagesc(activeNeurons);colormap(gca,1-gray)
    set(gca,'FontSize',12,'XTick',xticks,'XTickLabel',xtickslabel)
    xlabel('Time (min)')
    set(gcf, 'Color', 'w');
    set(gcf, 'Units', 'Centimeters', 'Position', [0 0 10 6]);
    export_fig(strcat(path2save,'coactBinRaster.pdf'));

    
    hFig3=figure;set(hFig3,'visible',vis);
    posFig = get(hFig3, 'Position');
    posFig(4) = posFig(4)*1.6;
    posFig(2) = posFig(2)*0.7;
    imagesc(shuffeledCoActivity);colormap(gca,1-gray)
    set(gca,'FontSize',12,'XTick',xticks,'XTickLabel',xtickslabel)
    xlabel('Time (min)')
    set(gcf, 'Color', 'w');
    set(gcf, 'Units', 'Centimeters', 'Position', [0 0 10 6]);
    export_fig(strcat(path2save,'coactBinShuffRaster.pdf'));

    
%  %-------------------------------------------------------
%  %coactivity four panels all together
%     c=colormap;
%     figure;ax1=subplot(4,1,1);imagesc(activeNeurons);colormap(ax1,1-gray)
%     set(gca,'FontSize',12);
%     ax2=subplot(4,1,2);bar([1:length(activeNeurons)],sum(activeNeurons));set(gca,'YLim',[0,maxCoActivity]),axis tight
%     line([0,size(activeNeurons,2)],[prctile(coActive(:),95),prctile(coActive(:),95)],'Color',[1,0,0]);colormap(ax2,c)
%     set(gca,'FontSize',12)
%     axis tight
%     xlabel('Time (min)')
%     ax3=subplot(4,1,3);imagesc(shuffeledCoActivity);colormap(ax3,1-gray);
%      set(gca,'FontSize',12)
%     ax4=subplot(4,1,4);bar(sum(shuffeledCoActivity));axis tight;
%     set(gca,'YLim',[0,maxCoActivity]);
%      set(gca,'FontSize',12)
%     line([0,size(activeNeurons,2)],[prctile(coActive(:),95),prctile(coActive(:),95)],'Color',[1,0,0]);colormap(ax4,c);
%     set(gcf, 'Color', 'w');
%     export_fig(strcat(path2save,'coactbinthresh.pdf'));
% %----------------------------------------------------------------------


end