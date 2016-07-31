% path2save='C:\Reports\20160115\figs\fim\20150804-f3-6dpf\';

function assemblies = detectAssemblies(filedateStr, cond);
%Input:
%filedateStr - a string (e.g. 20150804)
%fishnumStr  - a string (e.g. 3)
% function also receives the fullname of the
% fish(i.e.filedateStr-fishnumStr), in that case only one imput argument is
% needed
%% Setting environment
addpath(genpath('D:\Dev\zf'));
fishName=filedateStr;
fileName=strcat(fishName,'-processedFishUnifiedTrials.mat');

[rootFolder,fishRootFolder, csvFilePath]=setGenEnv(cond);
[path2loadData,path2loadintermedData,path2saveFigures,path2saveData]=setFishEnv(fishRootFolder,fishName);
load(strcat(path2loadData,fileName));

%% Extract basic activity properties 
data = preAssmbProps(processedFish);
[peakPos,peakMag] = peakfinder(data.normCoActivity, 0.05, data.sigAssSize/(max(sum(data.activeNeurons))), 1, true,false);
data.peakPos=peakPos;
data.peakMag=peakMag;
data.path2saveFigures=path2saveFigures;


%%  Searching for the best assembly set
ind=1;
[dist,z]= calcDistMat(data.activeNeurons,peakPos,'dist2',path2saveFigures,'HC');
data.cosineDistMat=dist;
data.hcClusterTree=z;
cutoff=[0.3:0.1:0.8];
for cutoffInd=1:length(cutoff)
    cutoffInd
    close all;[ma gof(ind),percFrameExpl(ind),perPeakExpl(ind),motherAssGroupedFrames,strength]=groupPatterns2(data.activeNeurons,data.peakPos,data.cosineDistMat,data.hcClusterTree,data.plottedSortTable,cutoff(cutoffInd),data.path2saveFigures,strcat('HC',num2str(cutoff(cutoffInd)*10),'-'));
    possAssmbs(cutoffInd).assemblies=ma;
    possAssmbs(cutoffInd).cutoff=cutoff(cutoffInd);
    possAssmbs(cutoffInd).gof=gof(ind);
    possAssmbs(cutoffInd).pFrameExpl=percFrameExpl(ind);
    possAssmbs(cutoffInd).pPeakExpl=perPeakExpl(ind);
    possAssmbs(cutoffInd).saveString=strcat('HC',num2str(cutoff(cutoffInd)*10),'-');
    possAssmbs(cutoffInd).maGroupedFrames=motherAssGroupedFrames;
    possAssmbs(cutoffInd).maStrength=strength;
    ind=ind+1;
end
% removing plotting from the code, this is taken care of by plotfishAssmb.m
% h=figure;set(h, 'Visible', visPlot);plot(cutoff,gof,'.-');ylabel('mean peak similarity ind');xlabel('cutoff')
% prepareFigure4Save(true, path2saveFigures, [], 'HCgof');
% h=figure;set(h, 'Visible', visPlot);plot(cutoff,percFrameExpl,'.-');ylabel('% frames explained');xlabel('cutoff')
% prepareFigure4Save(true, path2saveFigures, [], 'HCpercFrameExpl');
% h=figure;set(h, 'Visible', visPlot);plot(cutoff,perPeakExpl,'.-');ylabel('% peaks explained');xlabel('cutoff')
% prepareFigure4Save(true, path2saveFigures, [], 'HCperPeakExpl');
% h=figure;set(h, 'Visible', visPlot);plot(cutoff(2:end), diff(gof));ylabel('mean similarity ind: incr change');xlabel('cutoff')
% prepareFigure4Save(true, path2saveFigures, [], 'HCdiffgof');
% h=figure;set(h, 'Visible', visPlot);plot(cutoff(2:end), diff(perPeakExpl));ylabel('change in % of peaks explained');xlabel('cutoff')
% prepareFigure4Save(true, path2saveFigures, [], 'HCdiffPerPeakExpl');

peakgofInd=peakfinder(gof, [], 0, 1, true, false);
peakdiffgofInd=peakfinder(diff(gof), [], 0, 1, true, false);
peakperPeakExplInd=peakfinder(perPeakExpl, [], 0, 1, true, false);
diffgof=diff(gof);
% if (peakfinder(diff(gof), [], 0, 1, true, false)==(x-2)); % slightly higher peak at the next cutoff
%     cut=cutoff(x-1);
%     close all;[ma meangof,pFrameExpl,pPeakExpl, assemblyFrames]=groupPatterns2(activeNeurons,peakPos,dist,z,plottedSortTable,cut,path2saveFigures,strcat('HC-chosen',num2str(cut*10),'-'));

if gof(peakgofInd-1)>0.9*gof(peakgofInd)
    if perPeakExpl(peakperPeakExplInd-1)>0.9*perPeakExpl(peakperPeakExplInd)
        cut=cutoff(peakperPeakExplInd-1);
        close all;[ma meangof,pFrameExpl,pPeakExpl, assemblyFrames]=groupPatterns2(data.activeNeurons,data.peakPos,data.cosineDistMat,data.hcClusterTree,data.plottedSortTable,cut,data.path2saveFigures,strcat('HC-chosen',num2str(cut*10),'-'));
    else
        cut=cutoff(peakperPeakExplInd);
        close all;[ma meangof,pFrameExpl,pPeakExpl, assemblyFrames]=groupPatterns2(data.activeNeurons,data.peakPos,data.cosineDistMat,data.hcClusterTree,data.plottedSortTable,cut,data.path2saveFigures,strcat('HC-chosen',num2str(cut*10),'-'));
    end
elseif  peakdiffgofInd>1
        if (diffgof(peakdiffgofInd-1)>0.9*diffgof(peakdiffgofInd)) %a clear peak
            cut=cutoff(peakdiffgofInd+1);
            close all;[ma meangof,pFrameExpl,pPeakExpl, assemblyFrames]=groupPatterns2(data.activeNeurons,data.peakPos,data.cosineDistMat,data.hcClusterTree,data.plottedSortTable,cut,data.path2saveFigures,strcat('HC-chosen',num2str(cut*10),'-'));
        end
end
if ~exist('cut','var') 
        cut=cutoff(peakgofInd);
        close all;[ma meangof,pFrameExpl,pPeakExpl, assemblyFrames]=groupPatterns2(data.activeNeurons,data.peakPos,data.cosineDistMat,data.hcClusterTree,data.plottedSortTable,cut,data.path2saveFigures,strcat('HC-chosen',num2str(cut*10),'-'));

end
%%  Struct assembly to hold assembly information
chosenAssmbls=struct('nAssemblies',length(ma));
chosenAssmbls.core=ma;
chosenAssmbls.frames=assemblyFrames;
% assembly.plottedSortTable=plottedSortTable;
% assembly = getAssemblyProp(assembly,data); % assembly spatial properties
chosenAssmbls.gof=gof;
chosenAssmbls.pFrameExpl=[possAssmbs.pFrameExpl];
chosenAssmbls.pPeakExpl=[possAssmbs.pPeakExpl];
chosenAssmbls.possCutoffs=[possAssmbs.cutoff];
chosenAssmbls.cutoff=cut;


%% Assembly match to peaks/all frames freq,temporal dynamics
patterns=data.activeNeurons(:,:)';
for ind=1:length(ma)
    maPattern=zeros(1,size(data.activeNeurons,1));
    maPattern(ma{ind})=1;
    maPatterns(ind,:)=maPattern;
end
X=[maPatterns;patterns];
dist= 1-squareform(pdist(X,'cosine'));
maCosMatch=dist(1:length(ma),length(ma)+1:end);
[mVal,mInd]=max(maCosMatch);
%% Save assembly struct
assemblies.data= data;
assemblies.chosenAssmbls=chosenAssmbls;
assemblies.possAssmbs=possAssmbs;
save([path2saveData, fishName,'-assembly'], 'assemblies', '-v7.3');