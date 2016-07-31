function [plottedSortTable, rasterAlltrials] = getRaster(processedFish, overlapRange,sortBy)
%returns raster  from processedFish
%overlapRange number of trials neurons must appear in to be plotted 
%   eg [3,4] plots neurons appearing in 3 and 4 trials. defaults to max
%sortBy is a string that must be one of:
%'unsorted' [default - 'unsorted']
%'sortByX'
%'sortByY'
%'response' - sort by global response magnitude
%'prefers' - sort by strongest stimulus 
%'corrMean' - sort by mean correlation 
%'peaktime' - sort by mean timing of  peak response
%reorderByStim 'on' or 'off' -[default - 'off'] shuffle data so stimulus presentations appear consecutively and not randomly
%plotPresentLines 'on' or 'off' [default - 'on'] - plot lines at the time points stimuli are presented, color coded
%plotMotionLines 'on' or 'off' [default - 'off'] - plot black lines at the times motion artefacts were recorded
%useUnresponsiveNeurons 'on' or 'off' or 'only' [default - 'off'] - include neurons that do not respond strongly
%to the stimulus. 'only' means only include unresponsive neurons and exclude responsive neurons
%handle default parameters
%'visPlot'  'on' or 'off'
if nargin < 2
    overlapRange = size(processedFish.neuronMappings, 2) -1;
end
if nargin < 3
    sortBy = 'unsorted';
end

if strcmp(sortBy,'sortByX')
    sortOrder = [1, 4, 3, 2];
elseif strcmp(sortBy, 'sortByY')
    sortOrder = [1, 3, 4, 2];
elseif strcmp(sortBy, 'response')
    sortOrder = [1, 5, 2, 3, 4, 6, 7, 8];
elseif strcmp(sortBy,'unsorted')
    sortOrder = [1, 2, 3, 4];
else 
    error('The sortBy entered was ''%s''. It must be one of ''sortByX'',  ''sortByY'', ''response'', ''prefers'', ''corrMin'', ''corrMean'', ''peaktime'' or ''unsorted''', sortBy);
end

% pathsplit=strsplit(processedFish.fileBase,'\');
% newpath={pathsplit{1},pathsplit{2},pathsplit{3},pathsplit{4}};
% path2save=path2saveFigures;


sortTable = [];
for overlap = overlapRange
    for overlapNeuronNum = 1:size(processedFish.neuronMappings{overlap},1)
        temp = processedFish.neuronsUnified(overlap).neurons(overlapNeuronNum);
        sortTable = [sortTable; overlap, overlapNeuronNum, temp.centrei, temp.centrej];
    end
end
sortTable = sortrows(sortTable, sortOrder);

%this variable is  a list of frames, one per trial. It is cropped and trimmed and shuffled such that
%it can be used as a mapping between the desired user output and the data in processedFish
trialPlottingTemplates = {};

for trial = 1:size(processedFish.trial, 2)
    trialPlottingTemplates{trial}=1:(size((processedFish.trial(1,trial).traces),2));
end

%with the sorted neuron numbers, get the traces
maxTraceLength = 0;
for trial = 1:size(trialPlottingTemplates, 2)
    if maxTraceLength < size(trialPlottingTemplates{trial}, 2)
        maxTraceLength = size(trialPlottingTemplates{trial}, 2);
    end
end

neuronsToUse = 1:size(sortTable(:, 4), 1);
plottedSortTable = sortTable(neuronsToUse, :); 


%generate trace arrays
traceArrays = zeros(size(neuronsToUse, 2), maxTraceLength, size(processedFish.trial, 2));
rasterAlltrials=[];
for r = 1:size(neuronsToUse, 2);
    overlap = sortTable(neuronsToUse(r), 1);
    overlapNeuronNum = sortTable(neuronsToUse(r), 2);
    for trial = 1:size(processedFish.trial, 2)
        currentTrace = processedFish.neuronsUnified(overlap).neurons(overlapNeuronNum).smoothTraces{trial};
        traceArrays(r, 1:size(trialPlottingTemplates{trial},2), trial) = currentTrace(trialPlottingTemplates{trial});
    end
end
peakVisual=max(max(max(traceArrays)));
peakVisual=prctile(traceArrays(:),98);


peakMagTemp = max(max(traceArrays, [],  2), [], 1);
peakVisualmatrix = max(max(traceArrays,[],1),[],2);
for trial = 1:size(processedFish.trial, 2)
     rasterAlltrials=[rasterAlltrials,traceArrays(:,:,trial)];
end



% % 
% % % -------------------------------------------------------------
% % %% plot raster per each trial
% %     hFig = figure;set(hFig,'visible',visPlot);
% %     posFig = get(hFig, 'Position');
% %     posFig(4) = posFig(4)*1.3;
% %     posFig(2) = posFig(2)*0.7;
% %     set(hFig, 'Position', posFig, 'PaperPositionMode', 'auto');
% %     peakMagTemp = max(max(traceArrays, [],  2), [], 1);
% %     peakVisualmatrix = max(max(traceArrays,[],1),[],2);
% % 
% %    for trial = 1:size(processedFish.trial, 2)
% %         %peakVisual =peakVisualmatrix(:,:,trial); 
% %         ax(trial) = subplot(size(processedFish.trial, 2), 1, trial);
% %         imagesc(traceArrays(:,:,trial), [0,peakVisual]);
% %         rasterAlltrials=[rasterAlltrials,traceArrays(:,:,trial)];
% %         set(gca,'XTickLabel',[])
% %         ylabel(['Trial ' int2str(processedFish.trialIDs(trial)) ],'FontSize',20);
% %        if trial==size(processedFish.trial, 2) 
% %            h = colorbar('Location','EastOutside');
% %            ylabel(h,'\DeltaF/F')
% %        end
% %     end
% %     %set(h, 'Position', [.8314 .11 .0581 .8150])
% %   for i=1:size(processedFish.trial, 2)
% %           pos=get(ax(i), 'Position');
% %           set(ax(i), 'Position', [pos(1) pos(2) 0.85*pos(3) pos(4)]);
% %   end
% %   detlaXTick=2; % in minutes
% %   nFramesperDeltaTick=detlaXTick*60*processedFish.frameRateHz;
% %   ticks=round(nFramesperDeltaTick:nFramesperDeltaTick:size(rasterAlltrials,2));
% %   set(gca,'XTick',ticks,'XTicklabel',detlaXTick*[1:length(ticks)]);
% %   set(gca,'FontSize',12);
% %   xlabel('Time(min)');
% %   set(gca,'FontSize',12);
% %   set(gcf, 'Color', 'w');
% %   set(gcf, 'Units', 'Centimeters', 'Position', [0 0 10 10]);
% %   export_fig(strcat(path2saveFigures,'rasterByTrials.pdf'));
% % % %-------------------------------------------------------------
% % % 
    
%     fcoact=figure;ax(1)=subplot(2,1,1);imagesc(rasterAlltrials,[0,peakVisual]) ;colorbar;
%     pos=get(ax(1), 'Position');
%     set(ax(1), 'Position', [pos(1) pos(2) 0.85*pos(3) pos(4)]);
%     detlaXTick=4; % in minutes
%     nFramesperDeltaTick=detlaXTick*60*processedFish.frameRateHz;
%     ticks=round(nFramesperDeltaTick:nFramesperDeltaTick:size(rasterAlltrials,2));
%     set(gca,'XTick',ticks,'XTicklabel',detlaXTick*[1:length(ticks)]);
%     xlabel('Time(min)');
%     mNeurons=mean(rasterAlltrials,2);
%     stdNeurons=std(rasterAlltrials')';
%     thrsholdMat=repmat(mNeurons+3*stdNeurons,1,size(rasterAlltrials,2));
%     activeNeurons=zeros(size(rasterAlltrials,1),size(rasterAlltrials,2));
%     activeNeurons=rasterAlltrials-thrsholdMat;
%     activeNeurons(activeNeurons>0)=1;
%     activeNeurons(activeNeurons<=0)=0;
%     ax(2)=subplot(2,1,2);bar(sum(activeNeurons));axis tight;
%     pos=get(ax(2), 'Position');
%     set(ax(2), 'Position', [pos(1) pos(2) 0.85*pos(3) pos(4)]);
%     set(gca,'XTick',ticks,'XTicklabel',detlaXTick*[1:length(ticks)]);
%     xlabel('Time(min)');
%     ylabel('Coactivation level (#Cells)')
%     print('-depsc','-tiff','-r300', strcat(path2saveFigures,'coactivity'))
%     set(gcf, 'Color', 'w');
%     export_fig(strcat(path2saveFigures,'coactivity.pdf'));
% % %% plot raster of all trials
% %     hFig3=figure;set(hFig3,'visible',visPlot);
% %     posFig = get(hFig3, 'Position');
% %     posFig(4) = posFig(4)*1.6;
% %     posFig(2) = posFig(2)*0.7;
% %   
% %   imagesc(rasterAlltrials,[0,peakVisual]) ;h=colorbar;
% %   ylabel(h,'\DeltaF/F','FontSize',12)
% %   pos=get(gcf, 'Position');
% %   set(gcf, 'Position', [pos(1) pos(2) 0.85*pos(3) pos(4)]);
% %   axesPos=get(gca,'Position');
% %   detlaXTick=8; % in minutes
% %   nFramesperDeltaTick=detlaXTick*60*processedFish.frameRateHz;
% %   ticks=round(nFramesperDeltaTick:nFramesperDeltaTick:size(rasterAlltrials,2));
% %   set(gca,'XTick',ticks,'XTicklabel',detlaXTick*[1:length(ticks)]);
% %   set(gca,'FontSize',12);
% %   xlabel('Time(min)');
% %   set(gca,'YTick',[40,80,120]);
% %   ylabel('Neurons')
% %   set(gcf, 'Color', 'w');
% %   set(gcf, 'Units', 'Centimeters', 'Position', [0 0 10 6]);
% %   export_fig(strcat(path2saveFigures,'rasterAllTrials.pdf'));
% %   axpos=get(gca,'Position');
% %   
% % 
% % %% plot coactivity level
% % 
% %   mNeurons=mean(rasterAlltrials,2);
% %   stdNeurons=std(rasterAlltrials')';
% %   thrsholdMat=repmat(mNeurons+3*stdNeurons,1,size(rasterAlltrials,2));
% %   activeNeurons=zeros(size(rasterAlltrials,1),size(rasterAlltrials,2));
% %   activeNeurons=rasterAlltrials-thrsholdMat;
% %   activeNeurons(activeNeurons>0)=1;
% %   activeNeurons(activeNeurons<=0)=0;
% %   [sigAssSize]=findSigCoat(activeNeurons, 0.05,true,path2saveFigures,0.462);
% % 
% %    hFig2=figure; set(hFig2,'visible',visPlot)
% %    posFig = get(hFig2, 'Position');
% %    posFig(4) = posFig(4)*1.6;
% %    posFig(2) = posFig(2)*0.7;
% %    set(hFig2, 'Position', posFig, 'PaperPositionMode', 'auto');
% %   bar(sum(activeNeurons));axis tight;
% %   pos=get(gca, 'Position');
% %   pos(3)=axpos(3);
% % %   set(gca, 'Position', [pos(1) pos(2) 0.85*pos(3) pos(4)]);
% %     set(gca,'Position',pos);
% % %   set(gca,'XTick',ticks,'XTicklabel',detlaXTick*[1:length(ticks)]);
% % %     xlabel('Time(min)');
% % set(gca,'XTick',[],'XTickLabel',[],'FontSize',12,'Position',pos)
% % line([1,length(activeNeurons)],[sigAssSize,sigAssSize],'Color',[1,0,0])
% % ylabel('co-activity')
% % set(gcf, 'Color', 'w');
% % set(gcf, 'Units', 'Centimeters', 'Position', [0 0 10 4]);
% % export_fig(strcat(path2saveFigures,'rastercoactivity.pdf'));

   
    
end
