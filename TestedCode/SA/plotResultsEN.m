%PlotResults EN
load(strcat('C:\Data\SAoutfiles\output-EN-actPropsMatInd.mat'));
load(strcat('C:\Data\SAoutfiles\output-EN-actPropsMat.mat'));
load(strcat('C:\Data\SAoutfiles\output-EN-actPropsCell.mat'));
load(strcat('C:\Data\SAoutfiles\output-EN-actProps.mat'));
% load('C:\Data\SAoutfiles\fishNamesGroupByAge.mat');
load('C:\Data\SAoutfiles\fishNameAgeEN.mat');
load ('C:\Data\SAoutfiles\fishListEN.mat');
load ('C:\Data\SAoutfiles\fishListENscope.mat');
figDir = 'C:\Reports\20160503\figs\';


for fishInd=1:size(fishListEN,1) % comparing two tecta from the same fish
    [fishInd,fishListEN{fishInd,2}]
    indexC=strfind({output.fishName},fishListEN{fishInd,2}); % find no eye tectum
    cutInd = find(not(cellfun('isempty', indexC)));
    indexC=strfind({output.fishName},fishListEN{fishInd,3}); % find tectum with eye
    intactInd = find(not(cellfun('isempty', indexC)));
    PVLIndCut=find(output(cutInd).plottedSortTable(:,5)==1); %pvl cells in cut tectum
    NPIndCut=find(output(cutInd).plottedSortTable(:,5)==0);  %np cells in cut tectum
    PVLIndIntct=find(output(intactInd).plottedSortTable(:,5)==1); %pvl cells in intact tectum
    NPIndIntct=find(output(intactInd).plottedSortTable(:,5)==0);  %np cells in intact tectum

    %% find change in number of active cells in precentage
    nCellsCut=output(cutInd).numActNeurons;
    nCellsIntct=output(intactInd).numActNeurons;
    propActiveCells(fishInd)=nCellsCut/nCellsIntct; % change in number of active cells
    %% distinguish between PVL and NP in active cells
    propActiveCellsPVL(fishInd)=length(PVLIndCut)/length(PVLIndIntct);
    propActiveCellsNP(fishInd)=length(NPIndCut)/length(NPIndIntct);
    
    %% compare mean event frequency % NP and PVL together
    meventFreqCut = output(cutInd).meanEventFreqMin;
    meventFreqIntct = output(intactInd).meanEventFreqMin;
    meverntFreqCutPVL = mean(output(cutInd).eventFreqMin(PVLIndCut));
    meverntFreqIntctPVL = mean(output(intactInd).eventFreqMin(PVLIndIntct));
    meverntFreqCutNP = mean(output(cutInd).eventFreqMin(NPIndCut));
    meverntFreqIntctNP= mean(output(intactInd).eventFreqMin(NPIndIntct));
    propMeanFreq(fishInd)= meventFreqCut/meventFreqIntct;
    %% distinguish PVL and NP when inspecting frequency
    freqCutPVL=output(cutInd).eventFreqMin(PVLIndCut); %freq pvl in cut tectum
    freqCutNP=output(cutInd).eventFreqMin(NPIndCut);   %freq np in cut tectum
    freqIntctPVL=output(intactInd).eventFreqMin(PVLIndIntct);%freq pvl in cut tectum
    freqIntctNP=output(intactInd).eventFreqMin(NPIndIntct); %freq np in cut tectum
    propMeanFreqPVL(fishInd)=mean(freqCutPVL)/mean(freqIntctPVL);      %proportion mean freq PVL (cut/intct)
    propMeanFreqNP(fishInd) = mean(freqCutNP)/mean(freqIntctNP);      %proportion mean freq NP (cut/intct)  
   
    %% coactivity measures
    coActiveBinsIndCut= find(sum(output(cutInd).activeNeurons)>3);
    coActiveBinsIndIntct= find(sum(output(intactInd).activeNeurons)>3);
    propcoActiveBinsCut(fishInd)= length(coActiveBinsIndCut)/size(output(cutInd).activeNeurons,2);
    propcoActiveBinsIntct(fishInd)= length(coActiveBinsIndIntct)/size(output(intactInd).activeNeurons,2);
    coActivityCut=sum(output(cutInd).activeNeurons);
    coActivityIntct=sum(output(intactInd).activeNeurons);
    mcoActSizeCut(fishInd)=mean(sum(output(cutInd).activeNeurons(:,coActiveBinsIndCut)));
    mcoActSizeIntct(fishInd)=mean(sum(output(intactInd).activeNeurons(:,coActiveBinsIndIntct)));
    maxcoActSizeCut(fishInd)=max(sum(output(cutInd).activeNeurons(:,coActiveBinsIndCut)));
    maxcoActSizeIntct(fishInd)=max(sum(output(intactInd).activeNeurons(:,coActiveBinsIndIntct)));

 data(fishInd)=struct( 'fishName', fishListEN{fishInd,2},...
        'scope',scope(fishInd),...
        'nActiveCells',[nCellsIntct,nCellsCut],...
        'nPVLs',[length(PVLIndIntct),length(PVLIndCut)],...
        'nNPs',[length(NPIndIntct),length(NPIndCut),],...
        'meventFreq',[meventFreqIntct,meventFreqCut],...
        'meventFreqPVL',[meverntFreqIntctPVL,meverntFreqCutPVL],...
        'meventFreqNP',[meverntFreqIntctNP,meverntFreqCutNP],...
        'freqCutPVL',freqCutPVL,... % list of freq per cell
        'freqIntctPVL',freqIntctPVL,...% list of freq per cell
        'freqNP',[freqIntctNP,freqCutNP],...
        'coActivityCut',coActivityCut,...
        'coActivityIntct',coActivityIntct,...
        'propcoActiveBins',[propcoActiveBinsIntct(fishInd),propcoActiveBinsCut(fishInd)],...
        'coActiveBins',[size(coActiveBinsIndIntct,2),size(coActiveBinsIndCut,2)],...
        'propActiveCells',propActiveCells(fishInd),...
        'propActiveCellsPVL',propActiveCellsPVL(fishInd),...
        'propActiveCellsNP',propActiveCellsNP(fishInd),...
        'propMeanFreq',propMeanFreq(fishInd),...%meventFreqCut/meventFreqIntct;
        'propMeanFreqPVL', propMeanFreqPVL(fishInd),...
        'propcoMeanFreqNP',propMeanFreqNP(fishInd));
            
end
%% plot number of cells trend between cut and intact
mPropActCells=mean(propActiveCells);
% total number of cells
figure;plot([1,2],(reshape([data(:).nActiveCells],2,size(fishListEN,1))),'.-')
set(gca,'XLim',[0,3])
set(gca,'XTick',[1,2], 'XTickLabel',{'Intact','cut'});
ylabel('# Neurons');
prepareFigure4Save(true, figDir, [], 'totalNumCells');
% only PVLS
figure;plot([1,2],(reshape([data(:).nPVLs],2,size(fishListEN,1))),'.-')
set(gca,'XLim',[0,3])
set(gca,'XTick',[1,2], 'XTickLabel',{'Intact','cut'});
ylabel('# Neurons');
prepareFigure4Save(true, figDir, [], 'totalNumCellsPVLs');
% only NPs
figure;plot([1,2],(reshape([data(:).nNPs],2,size(fishListEN,1))),'.-')
set(gca,'XLim',[0,3])
set(gca,'XTick',[1,2], 'XTickLabel',{'Intact','cut'});
ylabel('# Neurons');
prepareFigure4Save(true, figDir, [], 'totalNumCellsNPs');

%% plot frequency differences between cut and intact tecta
% All cells event Frequency
figure;plot([1,2],(reshape([data(:).meventFreq],2,size(fishListEN,1))),'.-')
set(gca,'XLim',[0,3])
set(gca,'XTick',[1,2], 'XTickLabel',{'Intact','cut'});
ylabel('Event frequency');
prepareFigure4Save(true, figDir, [], 'totalEventFreq');
%frequency PVLs only - histogram
invfish=find([data.scope]=='i');
sahfish=find([data.scope]=='s');
figure; hist([data(sahfish).freqCutPVL]);
xlabel('Event Frequency')
prepareFigure4Save(true, figDir, [], 'eventFreqHistPVLscutSah');
figure; hist([data(sahfish).freqIntctPVL])
xlabel('Event Frequency')
prepareFigure4Save(true, figDir, [], 'evetFreqHistPVLsIntctSah');
figure; hist([data(invfish).freqCutPVL]);
xlabel('Event Frequency')
prepareFigure4Save(true, figDir, [], 'eventFreqHistPVLscutInv');
figure; hist([data(invfish).freqIntctPVL])
xlabel('Event Frequency')
prepareFigure4Save(true, figDir, [], 'evetFreqHistPVLsIntctInv');

% frequency PVLs only
figure;plot([1,2],(reshape([data(:).meventFreqPVL],2,size(fishListEN,1))),'.-')
set(gca,'XLim',[0,3])
set(gca,'XTick',[1,2], 'XTickLabel',{'Intact','cut'});
ylabel('Event frequency');
prepareFigure4Save(true, figDir, [], 'meventFreqPVLs');
% frequency NPs only
figure;plot([1,2],(reshape([data(:).meventFreqNP],2,size(fishListEN,1))),'.-')
set(gca,'XLim',[0,3])
set(gca,'XTick',[1,2], 'XTickLabel',{'Intact','cut'});
ylabel('Event frequency');
prepareFigure4Save(true, figDir, [], 'meventFreqNPs');

%% plot coactivity
% histogram of coactivity levels
invfish=find([data.scope]=='i');
sahfish=find([data.scope]=='s');
[nc,xc]=hist([data(sahfish).coActivityCut]);
[nit,xit]=hist([data(sahfish).coActivityIntct],xc);
figure;bar(xc,nc./sum(nc));
xlabel('coactive grp size');
ylabel('proportion of time bins')
prepareFigure4Save(true, figDir, [], 'coactivityCutSah');
figure;bar(xc,nit./sum(nit));
xlabel('coactive grp size')
ylabel('proportion of time bins')
prepareFigure4Save(true, figDir, [], 'coactivityIntctSah');
% the same histogram for the inverted fish
[nc,xc]=hist([data(invfish).coActivityCut]);
[nit,xit]=hist([data(invfish).coActivityIntct],xc);
figure;bar(xc,nc./sum(nc));
xlabel('coactive grp size');
ylabel('proportion of time bins')
prepareFigure4Save(true, figDir, [], 'coactivityCutInv');
figure;bar(xc,nit./sum(nit));
xlabel('coactive grp size')
ylabel('proportion of time bins')
prepareFigure4Save(true, figDir, [], 'coactivityIntctInv');
% prop coactive>3  bins
figure;plot([1,2],(reshape([data(:).propcoActiveBins],2,size(fishListEN,1))),'.-')
set(gca,'XLim',[0,3])
set(gca,'XTick',[1,2], 'XTickLabel',{'Intact','cut'});
ylabel('co-activity>3 frequency');
prepareFigure4Save(true, figDir, [], 'propcoActivity');
