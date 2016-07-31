function plotfishAssmb(assmblStruct)
rawActivity=assmblStruct.data;
possAssmb=assmblStruct.possAssmbs;
chosenAssmb=assmblStruct.chosenAssmbls;
%% Plot raster all trials
    hFig1=figure;
    imagesc(rawActivity.rasterAlltrials,[0,rawActivity.peakVisual]) ;h=colorbar;
    ylabel(h,'\DeltaF/F')
    axesPos=get(gca,'Position');
    set(gca,'Position',[0.8*axesPos(1),1.2*axesPos(2),1.1*axesPos(3),0.7*axesPos(4)])
    detlaXTick=8; % in minutes
    nFramesperDeltaTick=detlaXTick*60*rawActivity.frameRateHz;
    ticks=round(nFramesperDeltaTick:nFramesperDeltaTick:size(rawActivity.rasterAlltrials,2));
    set(gca,'XTick',ticks,'XTicklabel',detlaXTick*[1:length(ticks)]);
    xlabel('Time(min)');
    ylabel('Neurons');
    set(gca,'FontSize',8);
    set(gcf, 'Color', 'w');
    set(gcf, 'Units', 'Centimeters', 'Position', [0 0 12 8]);
    export_fig(strcat(rawActivity.path2saveFigures,'rasterAllTrials.pdf'));

%% Plot coactivity
    hFig2=figure; 
    bar(sum(rawActivity.activeNeurons));axis tight;
    set(gca,'XTick',[],'XTickLabel',[])
    set(gca,'Position',[0.8*axesPos(1),axesPos(2),1.1*axesPos(3),0.7*axesPos(4)])
    line([1,length(rawActivity.activeNeurons)],[rawActivity.sigAssSize,rawActivity.sigAssSize],'Color',[1,0,0])
    ylabel('co-activity');
    set(gca,'FontSize',8);
    set(gcf, 'Color', 'w');
    set(gcf, 'Units', 'Centimeters', 'Position', [0 0 12 4]);
    export_fig(strcat(rawActivity.path2saveFigures,'rastercoactivity.pdf'));
%% Plot coactivity with xTicks and label
    hFig3=figure;
    bar([1:length(rawActivity.activeNeurons)],sum(rawActivity.activeNeurons));set(gca,'YLim',[0,rawActivity.maxCoActivity]);axis tight
    line([0,size(rawActivity.activeNeurons,2)],[rawActivity.sigAssSize,rawActivity.sigAssSize],'Color',[1,0,0]);
    detlaXTick=8; % in minutes
    nFramesperDeltaTick=detlaXTick*60*rawActivity.frameRateHz;
    ticks=round(nFramesperDeltaTick:nFramesperDeltaTick:size(rawActivity.rasterAlltrials,2));
    set(gca,'XTick',ticks,'XTicklabel',detlaXTick*[1:length(ticks)]);
    xlabel('Time(min)');
    set(gca,'FontSize',8);
    set(gcf, 'Color', 'w');
    set(gcf, 'Units', 'Centimeters', 'Position', [0 0 12 4]);
    export_fig(strcat(rawActivity.path2saveFigures,'coactbinthresh.pdf'));
%% Plot coactivity of shuffeled data
    hFig4=figure;
    bar([1:length(rawActivity.activeNeurons)],sum(rawActivity.shuffeledActiveNeurons));axis tight;set(gca,'YLim',[0,rawActivity.maxCoActivity])
    line([0,size(rawActivity.activeNeurons,2)],[rawActivity.sigAssSize,rawActivity.sigAssSize],'Color',[1,0,0]);
    detlaXTick=8; % in minutes
    nFramesperDeltaTick=detlaXTick*60*rawActivity.frameRateHz;
    ticks=round(nFramesperDeltaTick:nFramesperDeltaTick:size(rawActivity.rasterAlltrials,2));
    set(gca,'XTick',ticks,'XTicklabel',detlaXTick*[1:length(ticks)]);
    xlabel('Time (min)');
    set(gca,'FontSize',8);
    set(gcf, 'Color', 'w');
    set(gcf, 'Units', 'Centimeters', 'Position', [0 0 12 8]);
    export_fig(strcat(rawActivity.path2saveFigures,'coactbinShuffthresh.pdf'));
%% Plot binary raster
    hFig5=figure;
    imagesc(rawActivity.activeNeurons);colormap(gca,1-gray)
    detlaXTick=8; % in minutes
    nFramesperDeltaTick=detlaXTick*60*rawActivity.frameRateHz;
    ticks=round(nFramesperDeltaTick:nFramesperDeltaTick:size(rawActivity.rasterAlltrials,2));
    set(gca,'XTick',ticks,'XTicklabel',detlaXTick*[1:length(ticks)]);
    xlabel('Time (min)');
    set(gca,'FontSize',8);
    set(gcf, 'Color', 'w');
    set(gcf, 'Units', 'Centimeters', 'Position', [0 0 12 8]);
    export_fig(strcat(rawActivity.path2saveFigures,'binaryRaster.pdf'));

 %%   Plot binary shuffeled raster
    hFig6=figure;
    imagesc(rawActivity.shuffeledActiveNeurons);colormap(gca,1-gray)
    detlaXTick=8; % in minutes
    nFramesperDeltaTick=detlaXTick*60*rawActivity.frameRateHz;
    ticks=round(nFramesperDeltaTick:nFramesperDeltaTick:size(rawActivity.rasterAlltrials,2));
    set(gca,'XTick',ticks,'XTicklabel',detlaXTick*[1:length(ticks)]);
    xlabel('Time (min)');
    set(gca,'FontSize',8);
    set(gcf, 'Color', 'w');
    set(gcf, 'Units', 'Centimeters', 'Position', [0 0 12 8]);
    export_fig(strcat(rawActivity.path2saveFigures,'coactBinShuffRaster.pdf'));
  %% Plot Distance Matrix and Distribution
  hFig7=figure;%set(hFig,'visible',vis);
  imagesc(rawActivity.cosineDistMat);colorbar;
  axis equal;axis tight;
  set(gca,'XTick',[],'YTick',[],'XTickLabel',[],'YTickLabel',[]);
  set(gca,'FontSize',12)
  set(gcf, 'Color', 'w');
  set(gcf, 'Units', 'Centimeters', 'Position', [0 0 8 6]);
  export_fig(strcat(rawActivity.path2saveFigures,[],'cosDistMat','.pdf'));
 %%  Plot histogram of distance matrix
  hFig8=figure;
  hist(rawActivity.cosineDistMat(:),50);
  set(gcf, 'Color', 'w');
  set(gca,'FontSize',12)
  set(gcf, 'Units', 'Centimeters', 'Position', [0 0 8 6]);
  export_fig(strcat(rawActivity.path2saveFigures,'distanceDistr','.pdf'));
%% Plot Distance Tree
hFig9=figure;
[h,t,perm] =dendrogram(rawActivity.hcClusterTree,size(rawActivity.peakPos,2),'colorthreshold','default');
set(gca,'XTickLabel',[],'XTick',[])
set(gca,'YTickLabel',[],'YTick',[])
set(gca,'Visible','off')
set(gcf, 'Color', 'w');
set(gca,'FontSize',12)
set(gcf, 'Units', 'Centimeters', 'Position', [0 0 8 6]);
export_fig(strcat(rawActivity.path2saveFigures,'reorgTree','.pdf'));
%% Plot Reorganized Matrix
reorgSigCorrMatdef=rawActivity.cosineDistMat(perm,perm);colorbar;%default
hFig11=figure;;imagesc(reorgSigCorrMatdef); colorbar;axis equal;axis tight
set(gca,'FontSize',12)
set(gca,'XTick',[],'YTick',[],'XTickLabel',[],'YTickLabel',[]);
set(gcf, 'Color', 'w');
set(gcf, 'Units', 'Centimeters', 'Position', [0 0 8 6]);
export_fig(strcat(rawActivity.path2saveFigures,'reorgCosDistMat','averageLink','.pdf'));

%% Plot grouped Frames for each assembly -taken from compMotherAss
hFig12=figure;
nCols=4;
for posAssmblInd=1:size(possAssmb,2)
    nGroups=size(possAssmb(posAssmblInd).maGroupedFrames,2);
    if nGroups>1
    for grpInd=1:nGroups
        figure;
        nFramesInGroup=size(possAssmb(posAssmblInd).maGroupedFrames{1,grpInd},2);
        for i=1:nFramesInGroup
            fNumber=possAssmb(posAssmblInd).maGroupedFrames{1,grpInd}(i);
            assembly=find(rawActivity.activeNeurons(:,fNumber)==1);
            if mod(nFramesInGroup+1,4)==0
                nRows=(nFramesInGroup+1)/4;
            else
                nRows=floor((nFramesInGroup+1)/4)+1;
            end
            s(i)=subplt(nRows,nCols,i);plot(rawActivity.plottedSortTable(:,4),rawActivity.plottedSortTable(:,3),'o','MarkerEdgeColor',[1,1,1]);hold on;
            set(gca,'YDir','reverse');axis equal;
            set(gca,'XLim',[1,max(rawActivity.plottedSortTable(:,4))+20],'YLim',[1,max(rawActivity.plottedSortTable(:,3))+20])
            set(gca,'XTickLabel',[],'YTickLabel',[]);
            pos=get(s(i), 'Position');
            set(s(i), 'Position', [pos(1) pos(2) 0.75*pos(3) pos(4)]);
            plot(rawActivity.plottedSortTable(assembly,4),rawActivity.plottedSortTable(assembly,3),'.r','MarkerSize',18)
            title(strcat(num2str(fNumber/rawActivity.frameRateHz),'s'),'FontSize',12);
        end % nFramesInGroup
        i=i+1;
       s(i)=subplt(nRows,nCols,i);plot(rawActivity.plottedSortTable(:,4),rawActivity.plottedSortTable(:,3),'o','MarkerEdgeColor',[1,1,1]);hold on;
        set(gca,'YDir','reverse');axis equal;
        set(gca,'XLim',[1,max(rawActivity.plottedSortTable(:,4))+20],'YLim',[1,max(rawActivity.plottedSortTable(:,3))+20])
        set(gca,'XTickLabel',[],'YTickLabel',[]);
        pos=get(s(i), 'Position');
        set(s(i), 'Position', [pos(1) pos(2) 0.75*pos(3) pos(4)]);
        plot(rawActivity.plottedSortTable(possAssmb(posAssmblInd).assemblies{grpInd},4),rawActivity.plottedSortTable(possAssmb(posAssmblInd).assemblies{grpInd},3),'.r','MarkerSize',18)

        ma=possAssmb(posAssmblInd).assemblies{grpInd};
        s(i)=subplt(nRows,nCols,i);
        cm=[repmat(1,1,101);0:0.01:1;0:0.01:1];
        for cellInd=1:size(ma,2)
                plot(rawActivity.plottedSortTable(ma(cellInd),4),rawActivity.plottedSortTable(ma(cellInd),3),'.','Color',[1,1-possAssmb(posAssmblInd).maStrength(grpInd,ma(cellInd)),1-possAssmb(posAssmblInd).maStrength(grpInd,ma(cellInd))],'MarkerSize',18);hold on;
        end
        set(gca,'YDir','reverse');axis equal;
        set(gca,'XLim',[1,max(rawActivity.plottedSortTable(:,4))+20],'YLim',[1,max(rawActivity.plottedSortTable(:,3))+20])
        set(gca,'XTickLabel',[],'YTickLabel',[]);
         pos=get(s(i), 'Position');
         set(s(i), 'Position', [pos(1) pos(2) 0.75*pos(3) pos(4)]);
        colormap(cm')
        h = colorbar('Location','EastOutside','YDir', 'reverse','YTick',[0,0.5,1],'YTickLabel',{'1';'0.5';'0'});
       title('Prob assembly');
       set(s(i),'position',[pos(1) pos(2) 0.75*pos(3) pos(4)]);
       cbPos=get(h,'Position');
       cbPos(3)=0.5*cbPos(3);
       cbPos(1)=0.98*cbPos(1);
       set(h, 'Position',cbPos );
        set(gcf, 'Color', 'w');
        export_fig(strcat(rawActivity.path2saveFigures,'PossC',num2str(possAssmb(posAssmblInd).cutoff*10),...
            'assmbl',num2str(grpInd),'.pdf'));
    end
    end %if nGroups>1 if there are frames assigned to the assembly
end
%% Plot all mother asseblies for all possible cutoffs
for posAssmbInd=1:size(possAssmb,2)
hFig13=figure;
nCols=3;
nmaAssmbl=size(possAssmb(posAssmbInd).assemblies,2);
motherAss=possAssmb(posAssmbInd).assemblies;
saveString=possAssmb(posAssmbInd).saveString;
plotMothAss(rawActivity.plottedSortTable,motherAss);
set(gcf, 'Color', 'w');
if (possAssmb(posAssmbInd).cutoff==chosenAssmb.cutoff)
    stringChosen='C';
else
    stringChosen=[];
end
export_fig(strcat(rawActivity.path2saveFigures,saveString,'mothAss',stringChosen,'.pdf'));
end


%% plot goodness of fit
assmblsCutoff=[possAssmb.cutoff];
gof=chosenAssmb.gof;
pFrameExpl=[possAssmb.pFrameExpl];
pPeakExpl=[possAssmb.pFrameExpl];
cutInd=find(chosenAssmb.possCutoffs==chosenAssmb.cutoff)
hFig14=figure;plot(assmblsCutoff,gof,'-');ylabel('mean peak similarity ind');xlabel('cutoff')
hold on; plot(chosenAssmb.cutoff, gof(cutInd),'.r');
set(gca,'FontSize',8);
set(gcf, 'Color', 'w');
set(gcf, 'Units', 'Centimeters', 'Position', [0 0 8 6]);
export_fig(strcat(rawActivity.path2saveFigures,[],'HCgof','.pdf'));

h=figure;plot(assmblsCutoff,pFrameExpl,'-');ylabel('% frames explained');xlabel('cutoff')
set(gca,'FontSize',8);
set(gcf, 'Color', 'w');
set(gcf, 'Units', 'Centimeters', 'Position', [0 0 8 6]);
export_fig(strcat(rawActivity.path2saveFigures,[],'HCpercFrameExpl','.pdf'));

h=figure;plot(assmblsCutoff,pPeakExpl,'-');ylabel('% peaks explained');xlabel('cutoff')
set(gca,'FontSize',8);
set(gcf, 'Color', 'w');
set(gcf, 'Units', 'Centimeters', 'Position', [0 0 8 6]);
export_fig(strcat(rawActivity.path2saveFigures,[],'HCperPeakExpl','.pdf'));

h=figure;;plot(assmblsCutoff(2:end), diff(gof));ylabel('mean similarity ind: incr change');xlabel('cutoff')
set(gca,'FontSize',8);
set(gcf, 'Color', 'w');
set(gcf, 'Units', 'Centimeters', 'Position', [0 0 8 6]);
export_fig(strcat(rawActivity.path2saveFigures,[],'HCdiffgof','.pdf'));


h=figure;plot(assmblsCutoff(2:end), diff(pPeakExpl));ylabel('change in % of peaks explained');xlabel('cutoff')
set(gca,'FontSize',8);
set(gcf, 'Color', 'w');
set(gcf, 'Units', 'Centimeters', 'Position', [0 0 8 6]);
export_fig(strcat(rawActivity.path2saveFigures,[],'HCdiffPerPeakExpl','.pdf'));



  
  