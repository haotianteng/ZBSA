
function getActProp(filedateStr, cond)
%Input:
%filedateStr - receives the fullname of the fish(i.e.filedateStr-fishnumStr)
%cond: Reg for regular dataset, no conditions
%      EN for enucleated dataset
%% Setting environment
fishName=filedateStr;
fileName=strcat(fishName,'-processedFishUnifiedTrials.mat');
[rootFolder,fishRootFolder, csvFilePath]=setGenEnv(cond);
[path2loadData,path2loadintermedData,path2saveFigures,path2saveData]=setFishEnv(fishRootFolder,fishName);

%% Extract basic activity properties 
%plottedSortTable - tagging PVL NP cells and their relative positions on
%the NP Major and Minor axes.
load(strcat(path2loadData,fileName));
[plottedSortTable, rasterAlltrials] = getRaster(processedFish);
load(strcat(path2loadintermedData,fishName,'-npAligned.mat'));
load(strcat(path2loadintermedData,fishName,'-NPSpatialProps.mat'));
if(strcmp(cond,'EN'))
    load(strcat(path2loadintermedData,fishName,'-nonTectumOfInterest.mat'));
end
xcoord=[round(plottedSortTable(:,3))]';
xcoord(find(xcoord>size(npAligned,1)))=size(npAligned,1);
ycoord=[round(plottedSortTable(:,4))]';
ycoord(find(ycoord>size(npAligned,2)))=size(npAligned,2);
isPVLCell=npAligned(sub2ind([size(npAligned,1),size(npAligned,2)],xcoord,ycoord));
if(strcmp(cond,'EN'))
    isPVLCell2=nonTectumOfIneterestMask(sub2ind([size(nonTectumOfIneterestMask,1),size(nonTectumOfIneterestMask,2)],xcoord,ycoord));
    isPVLCell(find((isPVLCell-isPVLCell2)==1))=0;
end
plottedSortTable(:,5)=isPVLCell'; % is PVL(1) NP(0)
activeNeurons =findActiveNeurons(rasterAlltrials);
NPNeuronsPoints=plottedSortTable(find(plottedSortTable(:,5)==0),[4,3])- repmat(NP.refMinor,size(find(plottedSortTable(:,5)==0),1),1);
plottedSortTable(find(plottedSortTable(:,5)==0),6)=...
    (dot(NPNeuronsPoints,repmat(NP.MinorVec,size(NPNeuronsPoints,1),1),2))./dot(NP.MinorVec,NP.MinorVec); % projection of NP cell onto the minor axis of the ellipse fitted to the NP
NPNeuronsPoints=plottedSortTable(find(plottedSortTable(:,5)==0),[4,3])- repmat(NP.refMajor,size(find(plottedSortTable(:,5)==0),1),1);
plottedSortTable(find(plottedSortTable(:,5)==0),7)=...
    (dot(NPNeuronsPoints,repmat(NP.MajorVec,size(NPNeuronsPoints,1),1),2))./dot(NP.MajorVec,NP.MajorVec); % projection of NPs cell onto the major axis of the ellipse fitted to the NP
PVLNeuronsPoints=plottedSortTable(find(plottedSortTable(:,5)==1),[4,3])- repmat(NP.refMajor,size(find(plottedSortTable(:,5)==1),1),1);
plottedSortTable(find(plottedSortTable(:,5)==1),7)=...
    (dot(PVLNeuronsPoints,repmat(NP.MajorVec,size(PVLNeuronsPoints,1),1),2))./dot(NP.MajorVec,NP.MajorVec); % projection of NP cell onto the major axis of the ellipse fitted to the NP
%% Frequency properties
recTimeMin  = size(activeNeurons,2)*1/(processedFish.frameRateHz)/60;
eventFreqSec= sum(activeNeurons')./size(activeNeurons,2).* processedFish.frameRateHz; % freqpersec
eventFreqMin= sum(activeNeurons')./recTimeMin;
plottedSortTable(:,8)=eventFreqMin';
meanEventFreqMin=mean(eventFreqMin);
stdEventFreqMin=std(eventFreqMin);
neuronsNum  = size(activeNeurons,1);
meanCellDeltaF= mean(rasterAlltrials');
meanActiveDeltaF = mean(rasterAlltrials(find(activeNeurons==1))); %mean df over all active bins
df=zeros(size(rasterAlltrials,1),size(rasterAlltrials,2));
df(find(activeNeurons==1))=rasterAlltrials(find(activeNeurons==1));
actNeuronsInd=find(sum(activeNeurons')>=1); 
deltaF=sum(df(actNeuronsInd,:)')./sum(activeNeurons(actNeuronsInd,:)'); % df per neurons
numActNeurons=length(actNeuronsInd);
% numNPCells=length(plottedSortTable(:,5)==0);
% [sigAssSize,shuffeledCoActivity]=findSigCoactLevel(activeNeurons, 0.05);
% normCoActivity = sum(activeNeurons)./max(sum(activeNeurons));
% numActNeurons=size(activeNeurons,1);
% [peakPos,peakMag] = peakfinder(normCoActivity, 0.05, sigAssSize/(max(sum(activeNeurons))), 1, true,false);
% numPeaks = size(peakPos,2);
% meanPeakMag = mean(peakMag);

NPmaskFile2Load=[path2loadintermedData,fishName '-npAligned.mat'];
if exist(NPmaskFile2Load,'file')==0
    alignNPmask(fishName);
end
    
%%  Struct actProps to hold activation properties information
actProps=struct('fishName',fishName,...
            'plottedSortTable',plottedSortTable,...
            'rasterAlltrials',rasterAlltrials,...
            'activeNeurons',activeNeurons,...
            'eventFreqMin',eventFreqMin,...
            'meanEventFreqMin', meanEventFreqMin,...
            'recTimeMin',recTimeMin,...
            'frameRateHz',processedFish.frameRateHz,...
            'meanActiveDeltaF',meanActiveDeltaF,...
            'meanCellDeltaF',meanCellDeltaF,...
            'deltaF',deltaF,...
            'numActNeurons',numActNeurons,...
            'cond',cond);

%% Save fish Activity Properties struct
save([path2saveData, fishName,'-actProps'], 'actProps', '-v7.3');
