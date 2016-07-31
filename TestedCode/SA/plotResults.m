%% plot data collected from all fish
%procedure actProps

%% load data files collected from all fish (from cluster using output=collectFishInfo('actProps')
%collecting all the files from SAoutfolder)
thrshTexName={'$2 \Delta F/F$','$\mu+\sigma$','$\mu+2\sigma$'};
load(strcat('C:\Data\SAoutfiles\output-actPropsMatInd.mat'));
load(strcat('C:\Data\SAoutfiles\output-actPropsMat.mat'));
load(strcat('C:\Data\SAoutfiles\output-actPropsCell.mat'));
load(strcat('C:\Data\SAoutfiles\output-actProps.mat'));
load('C:\Data\SAoutfiles\fishNamesGroupByAge.mat');
load('C:\Data\SAoutfiles\fishNameAge.mat');
figDir = 'C:\Reports\20160406\figs\';
x=hsv;close all;
ageColors=[repmat([nan nan nan],2,1); [0,114,189];[217,83,25];...   
           [237,177,32];[126,47,142];[119 172 48];[77 190 238];[162,20,47]];
ageColors=ageColors./255;
lineWidth=1;
cols = struct('age3dpf',[1,0,0], 'age4dpf',[1,0.75,0],...
              'age5dpf',[0.5 1 0],'age6dpf',[0 1 0.25], ...
              'age7dpf',[0 1 1], 'age8dpf',[0,0.25,1],...
              'age9dpf',[0.5 0 1],'age13dpf',[1 0 0.75]);
thrshInd=3;

%% NP and PVL cells pooled alltogether
freqAllCells=[output(:).eventFreqMin]; % all frequencies of all cells
pst=cat(1,output(:).plottedSortTable); % concatenated tabel of all cells and their coordinates
npInd=find(pst(:,5)==0);               % indices of np cells 
freqNP=freqAllCells(npInd);            % freq of np cells 
PVLInd=find(pst(:,5)==1);
freqPVL=freqAllCells(PVLInd);
%NPlookuptabel is a table holding information about NP cells
% (1)fishInd,(2)cellInd,(3)fishAge,(4)mean+3std values (for noisy cells exclusion)
% (5)integral, (6) 1 if it is an active cell 0 if it is a noisy cell.
% (7) projection in minor axis (8) projection on major axis (9) frequency
NPlookupTable=[];
for fishInd=1:length(output)
    fishAge(fishInd)=fishNameAge(find(ismember(cat(1,fishNameAge{:,1}),output(fishInd).fishName,'rows')),2);
    npCellsInd{fishInd}=find(output(fishInd).plottedSortTable(:,5)==0);
    m{fishInd}=mean(output(fishInd).rasterAlltrials(npCellsInd{fishInd},:)');
    integral{fishInd}=trapz(output(fishInd).rasterAlltrials(npCellsInd{fishInd},:)')./size(output(fishInd).rasterAlltrials,2);
    sd{fishInd}=std(output(fishInd).rasterAlltrials(npCellsInd{fishInd},:)');
    cutoffValue{fishInd}=m{fishInd}+3*sd{fishInd}; % cutoff for noisy cell detection
    NPactiveCellInd=npCellsInd{fishInd}(find(cutoffValue{fishInd}>0.8));
    NPtraces{fishInd}=output(fishInd).rasterAlltrials(NPactiveCellInd,:);
    axesProj = output(fishInd).plottedSortTable(npCellsInd{fishInd},[6,7]);
    NPFreq{fishInd}=output(fishInd).eventFreqMin(npCellsInd{fishInd})';
    NPlookupTable=[NPlookupTable; repmat(fishInd,length(npCellsInd{fishInd}),1),npCellsInd{fishInd}, repmat(fishAge{fishInd},length(npCellsInd{fishInd}),1),[cutoffValue{fishInd}]',[integral{fishInd}]',repmat(0,length(npCellsInd{fishInd}),1), axesProj,NPFreq{fishInd};];
end
noNoiseNpInd=find(NPlookupTable(:,4)>0.8);        % cells which contain data
NPlookupTable(noNoiseNpInd,6)=1;                   % Marking active NP as 1 
NPlookupTable(setdiff([1:size(NPlookupTable,1)],noNoiseNpInd),6)=0; % Marking noise NP as 0 
freqNP2cluster=NPlookupTable(noNoiseNpInd,9);              % data to cluster based freq of non noisy cell
integralNP2cluster=NPlookupTable(noNoiseNpInd,5); % data to cluster based integral of non noisy cell
[optimalGMMInt, nClustInt, AICInt, BICInt]= GMM(integralNP2cluster,4); %GMM on intergral data
[optimalGMMfreq, nClustfreq, AICfreq,BICfreq]= GMM(freqNP2cluster,4); %GMM on frequency data
% %% Lowpass filtering of NP to make sure it is not the noise that drives 
% %the bimodal distribution
% NPActiveInd=find(NPlookupTable(:,4)>0.8);
% T=0.4620;tau=1;
% a=T/tau;
% close all;
% % [b,a] = butter(6,0.8,'high');
% % NPfiltlow = filter(b,a,x);
% 
% df = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',0.2);
% D = mean(grpdelay(df));
% y = filter(df,[x(1:2,:)'; zeros(D,2)]); % Append D zeros to the input data
% y = y(D+1:end,:);   
% figure;plot(x(2,:))
% hold on;
% plot(y(:,2),'r')
% for i=1:length(NPtraces)
%       x=NPtraces{i};
%       NPtracesf{i} = filter(df,[x'; zeros(D,size(x,1))]); % Append D zeros to the input data
%       activeNeurons =findActiveNeurons(NPtracesf{i}');
% %       recTimeMin  = size(activeNeurons,2)*1/(processedFish.frameRateHz)/60;
%       recTimeMin  = size(activeNeurons,2)*1/(2.1645)/60;
%       eventFreqMin{i}= sum(activeNeurons')./recTimeMin;
% end
% filteredFreq=cell2mat(eventFreqMin);
% [foptimalGMMfreq, fnClustffreq, fAICfreq,fBICfreq]= GMM(filteredFreq',4); %GMM on frequency data
% [n,x]=hist(filteredFreq,50);
% figure;bar(x,n/(sum(n)*(x(2)-x(1))),1)
% for j=1:fnClustffreq
% line(x,foptimalGMMfreq.PComponents(j)*normpdf(x,foptimalGMMfreq.mu(j),sqrt(foptimalGMMfreq.Sigma(j))),'color','r')
% end

%%
%% SINs and PVLs tagging per age
allFish={actPropsCell{:,1}}';
ages=cell2mat(fishNamesGroupByAge(:,1));
iterAgeInd=1;
for groupAgeInd=1:size(fishNamesGroupByAge,1)
    fishNames=cell2mat(fishNamesGroupByAge{groupAgeInd,2});
    fishInd=find(ismember(allFish,fishNames));
    freq=[output(fishInd).eventFreqMin];
    neuronsTotal=cat(1, output(fishInd).plottedSortTable);
    PVLcells{iterAgeInd,1}=ages(groupAgeInd);
    SINcells{iterAgeInd,1}=ages(groupAgeInd);
    PVLcells{iterAgeInd,2}=find(neuronsTotal(:,5)==1);
    SINcells{iterAgeInd,2}=find(neuronsTotal(:,5)==0);
    
    npcellsOrigin=[];
    pvlcellsOrigin=[];
    
    s=[];
    for k=1:length(fishInd)
        npcellsPerFish=find(output(fishInd(k)).plottedSortTable(:,5)==0);
        npcellsOrigin= [npcellsOrigin; repmat(fishInd(k),length(npcellsPerFish),1),npcellsPerFish];
        pvlcellsPerFish=find(output(fishInd(k)).plottedSortTable(:,5)==1);
        pvlcellsOrigin= [pvlcellsOrigin; repmat(fishInd(k),length(pvlcellsPerFish),1),pvlcellsPerFish];

    end
    freqperAge{iterAgeInd,6}=npcellsOrigin; % lookup tabel for np cells
    freqperAge{iterAgeInd,7}=pvlcellsOrigin; % lookup tabel for pvl cells

    SINind=find(neuronsTotal(:,5)==0);
    PVLind=find(neuronsTotal(:,5)==1);
    freqperAge{iterAgeInd,1}=ages(groupAgeInd);
    freqperAge{iterAgeInd,2}=freq(SINcells{iterAgeInd,2});
    freqperAge{iterAgeInd,3}=freq(PVLcells{iterAgeInd,2});
    freqperAge{iterAgeInd,4}=sum((neuronsTotal(:,5)==0)); % #  of SINs per age group
    freqperAge{iterAgeInd,5}=sum((neuronsTotal(:,5)==1)); % #  of PVLs per age group
%     freqperAge{iterAgeInd,6}= deltaF(SINcells{iterAgeInd,2});%mean df of SINs 
    SINs(iterAgeInd)=sum((neuronsTotal(:,5)==0)); % # of SINs per age group
    PVLs(iterAgeInd)=sum((neuronsTotal(:,5)==1)); % # of PVLs per age group
    nTotal(iterAgeInd)=size(neuronsTotal,1);
    meanFreqSINs(iterAgeInd)=mean(freq(SINind));
    meanFreqPVLs(iterAgeInd)=mean(freq(PVLind));
    stdFreqSINs(iterAgeInd)=std(freq(SINind));
    stdFreqPVLs(iterAgeInd)=std(freq(PVLind));
     iterAgeInd=iterAgeInd+1;
end
%% Plot a trace and the threshold:  Figure 1 report 20150406
signal=output(1).rasterAlltrials(1,:);
figure;plot(signal);
m=mean(signal);
signalstd=std(signal);
trshld=m+2*signalstd;
hold on;
plot([1,length(signal)],[trshld,trshld],'Color',[1,0,0]);
dtmin=8;
set(gca,'Xtick',[0:(dtmin*60*output(1).frameRateHz):length(signal)],'XTickLabel',[0:dtmin:output(1).recTimeMin])
xlabel('Time (mins)')
ylabel('\DeltaF/F')
prepareFigure4Save(true, figDir, [], 'trace-fish1cellInd1');

%% Plot a trace of a noisy cell  Figure 8 report 20150406
signalNoise=output(37).rasterAlltrials(33,:); %20151202-f3
figure;plot(signalNoise)
dtmin=8;
set(gca,'Xtick',[0:(dtmin*60*output(1).frameRateHz):length(signal)],'XTickLabel',[0:dtmin:output(1).recTimeMin])
set(gca,'XLim',[0,length(signalNoise)]);
xlabel('Time (mins)')
ylabel('\DeltaF/F')
prepareFigure4Save(true, figDir, [], 'NPnoise');

%% Plot a histogram of mu+3std over all cells: Figure 9 in report 20150406
%plot histogram of the values of mu+3std to dectect noisy cells
figure;hist(NPlookupTable(:,4),100)
xlabel('mean+3std \DeltaF/F ')
prepareFigure4Save(true, figDir, [], 'NPmean3stdDistr');

%% plotting PVLs profiles
%plot histogram of freq PVLs all ages pooled together: Figure 10B in report 20150406
[nPVLs,xPVLs]=hist(freqPVL,100);
figure;bar(xPVLs,nPVLs);
xlabel('Freq (events/min)')
prepareFigure4Save(true, figDir, [], 'PVLeventFreqHistAllAges');
figure;bar(xPVLs,nPVLs./sum(nPVLs))
%plot normalized histogram of freq PVLs all ages pooled together: Figure 11D in report 20150406
xlabel('Freq (events/min)')
prepareFigure4Save(true, figDir, [], 'PVLeventFreqNormHistAllAges');


%% plot PVLs normalized histograms  frequencies by age (pool cells) each in a separate: Figure 3A-F report 20150406
% this section calculates the Gamma distribution fit for each age
% histogram.
maxFreq=max(cat(2,freqperAge{:,3})); %PVLs
minFreq=min(cat(2,freqperAge{:,3})); %PVLs
maxFreqSIN=max(cat(2,freqperAge{:,2})); %SINs
minFreqSIN=min(cat(2,freqperAge{:,2})); %SINs
clear n x;
maxPropNorm=[];
maxPropPDF=[];
maxPropNormSIN=[];
for groupAgeInd=1:size(fishNamesGroupByAge,1)
    fishage=[(fishNamesGroupByAge{:,1})];
    rowInd=find(fishage==fishNamesGroupByAge{groupAgeInd,1});
    [n(groupAgeInd,:),x(groupAgeInd,:)]=hist(freqperAge{rowInd,3},50);
    maxPropNorm=max([n(groupAgeInd,:)./sum(n(groupAgeInd,:)),maxPropNorm]);
    data=freqperAge{rowInd,3};
    pd(groupAgeInd) = fitdist(data','gamma');
    [gammaParams(groupAgeInd,:),~] = gamfit(data);
    dx(groupAgeInd)=x(groupAgeInd,2)-x(groupAgeInd,1);
    pdfexphist(groupAgeInd,:)=n(groupAgeInd,:)./(sum(n(groupAgeInd,:))*dx(groupAgeInd))
    agePDF(groupAgeInd,:)=pdf(pd(groupAgeInd),x(groupAgeInd,:));
    maxPropPDF=max([agePDF(groupAgeInd,:),pdfexphist(groupAgeInd,:),maxPropPDF]);
%     [nSIN(groupAgeInd,:),xSIN(groupAgeInd,:)]=hist(freqperAge{rowInd,2},15);
%     maxPropNormSIN=max([nSIN(groupAgeInd,:)./sum(nSIN(groupAgeInd,:)),maxPropNormSIN]);
end
for groupAgeInd=1:size(fishNamesGroupByAge,1)
    rowInd=find(fishage==fishNamesGroupByAge{groupAgeInd,1});
    figure;bar(x(groupAgeInd,:),n(groupAgeInd,:)./sum(n(groupAgeInd,:)),1)
    title(strcat(num2str(fishNamesGroupByAge{groupAgeInd,1}),'dpf'))
    set(gca,'XLim',[minFreq,maxFreq]);
    set(gca,'YLim',[0,maxPropNorm]);
    xlabel('events/min');
    prepareFigure4Save(true, figDir, [], strcat('freqPVLHistByAge',num2str(fishNamesGroupByAge{groupAgeInd,1}),'t',num2str(thrshInd)));
% Plot    
%     figure;bar(xSIN(groupAgeInd,:),nSIN(groupAgeInd,:)./sum(nSIN(groupAgeInd,:)),1)
%     title(strcat(num2str(fishNamesGroupByAge{groupAgeInd,1}),'dpf'))
%     set(gca,'XLim',[minFreqSIN,maxFreqSIN]);
%     set(gca,'YLim',[0,maxPropNormSIN]);
%     xlabel('events/min');
end
data2import.tableColLabels={'k','$\theta$'};
data2import.tableRowLabels={'4','5','6','7','8','9'};
data2import.data= gammaParams;
data2import.tableLabel = strcat('table',num2str(1)); 
data2import.tableCaption = strcat('Gama distrbution parameters, thereshold ',thrshTexName{thrshInd})
latex = latexTable(data2import);
texCode2File(figDir,strcat('gamaParams',num2str(thrshInd),'.tex'),latex)

%% plot Gamma fit parameters (this plot is not included in the report)
figure;[ax,h1,h2]=plotyy([fishNamesGroupByAge{:,1}],gammaParams(:,1),...
[fishNamesGroupByAge{:,1}], gammaParams(:,2));
set(gca,'XTick',[fishNamesGroupByAge{:,1}]);
set(get(ax(1),'Ylabel'),'String','k')
set(get(ax(2),'Ylabel'),'String','\theta')
prepareFigure4Save(true, figDir, [], strcat('GammaDistrparams'));

%% plot distributions and their respective pdfs : Figure 4 A-F report 20150406
for groupAgeInd=1:size(fishNamesGroupByAge,1)
    rowInd=find(fishage==fishNamesGroupByAge{groupAgeInd,1});
    figure;bar(x(groupAgeInd,:),n(groupAgeInd,:)./(sum(n(groupAgeInd,:))*dx(groupAgeInd)),1)
    hold on;
    plot(x(groupAgeInd,:),pdf(pd(groupAgeInd),x(groupAgeInd,:)),'r','LineWidth',1)
    title(strcat(num2str(fishNamesGroupByAge{groupAgeInd,1}),'dpf'))
    set(gca,'XLim',[minFreq,maxFreq]);
    set(gca,'YLim',[0,maxPropPDF]);
    xlabel('events/min');
   prepareFigure4Save(true, figDir, [], strcat('freqPVLHistDistrPDFByAge',num2str(fishNamesGroupByAge{groupAgeInd,1}),'t',num2str(thrshInd)));
    
%     figure;bar(xSIN(groupAgeInd,:),nSIN(groupAgeInd,:)./sum(nSIN(groupAgeInd,:)),1)
%     title(strcat(num2str(fishNamesGroupByAge{groupAgeInd,1}),'dpf'))
%     set(gca,'XLim',[minFreqSIN,maxFreqSIN]);
%     set(gca,'YLim',[0,maxPropNormSIN]);
%     xlabel('events/min');
end

%plot all gamma distribution fit for all ages (PVLs) on one figure. This
%figure is not included in the report.
figure;
for groupAgeInd=1:size(fishNamesGroupByAge,1)
    rowInd=find(fishage==fishNamesGroupByAge{groupAgeInd,1});
    plot(x(groupAgeInd,:),pdf(pd(groupAgeInd),x(groupAgeInd,:)),'Color',ageColors(freqperAge{rowInd,1},:));hold on;
end
agesLegend=num2str([freqperAge{:,1}]');
agesLegendExt=repmat('dpf',size(agesLegend,1),1);
agesLegendText=strcat(agesLegend,agesLegendExt);
lh = legend(agesLegendText, 'Location', 'SouthEast');
box(lh, 'off');
prepareFigure4Save(true, figDir, [], strcat('freqPVLHistfitByAge-t',num2str(thrshInd)));




%% plot PVL frequencies by ages each cell is a dot: Figure 2A report 20150406
figure;
for rowInd=1:size(freqperAge,1)
    plot(repmat(freqperAge{rowInd,1},1,freqperAge{rowInd,5}),freqperAge{rowInd,3},'.','Color',ageColors(freqperAge{rowInd,1},:));hold on;
%     errorbar(dataCell{rowInd,1},mean(dataCell{rowInd,2}),std(dataCell{rowInd,2})/sqrt(size(dataCell{rowInd,2},2)),'Color',ageColors(dataCell{rowInd,1},:)); 
end
xlabel('Age (dpf)');
ylabel('Frequency (event/mins)');
set(gca,'YLim',[0,max(cat(2,freqperAge{:,3}))]);
set(gca,'XLim',[3,10]);
set(gca,'XTick',[4:9]);
prepareFigure4Save(true, figDir, [], strcat('PVLAllFreqByAgesth',num2str(thrshInd)));

%% plot cummulative distribution of PVLs per age : figure 2B
figure;
for rowInd=1:size(freqperAge,1)
    [n,x]=hist(freqperAge{rowInd,3},50);
    plot(x,cumsum(n)./sum(n),'Color',ageColors(freqperAge{rowInd,1},:));hold on;
end
set(gca,'XLim',[0,max(cat(2,freqperAge{:,3}))]);
set(gca,'XLim',[0,2]);
agesLegend=num2str([freqperAge{:,1}]');
agesLegendExt=repmat('dpf',size(agesLegend,1),1);
agesLegendText=strcat(agesLegend,agesLegendExt);
lh = legend(agesLegendText, 'Location', 'SouthEast');
box(lh, 'off');
xlabel('Frequency (events/mins)');
ylabel('Proportion of neurons');
prepareFigure4Save(true, figDir, [],...
    strcat('PVLfreqHistCummDistr',num2str(thrshInd)));

%% mean freq for PVLs over development: figure 5 report 20150406
figure;errorbar([freqperAge{:,1}],meanFreqPVLs,stdFreqPVLs./sqrt(PVLs),'Color',ageColors(freqperAge{1},:)); hold on;
xlabel('age (dpf)');
ylabel('Frequency (events/min)');
set(gca,'XLim',[3,10]);
set(gca,'XTick',[4:9]);
prepareFigure4Save(true, figDir, [], strcat('PVLdevelopment-t',num2str(thrshInd)));

 %% Kolmogorov-Smirnov test for statistical difference between distributions (PDFs)
 % table 2 in report 20150406
for groupAgeInd1=1:size(freqperAge,1)-1
    for groupAgeInd2=(groupAgeInd1+1):size(freqperAge,1)
        [h(groupAgeInd1,groupAgeInd2),p(groupAgeInd1,groupAgeInd2)]=...
            kstest2(freqperAge{groupAgeInd1,3},freqperAge{groupAgeInd2,3});
    end
end
pvInd=triu(ones(size(p,1),size(p,2)),1);
vectorp=p(find(pvInd));
[correctp]=mafdr(vectorp,'BHFDR','true');
cv=zeros(size(p,1),size(p,2));
cv(find(pvInd))=correctp;
data2import2.tableColLabels={'5','6','7','8','9'};
data2import2.tableRowLabels={'4','5','6','7','8'};
data2import2.data= cv(:,2:end);
data2import2.tableLabel = strcat('table',num2str(6)); % 4,5,6 for threshold 1 2 and three
data2import2.tableCaption = strcat('KS test: difference between distributions, thereshold',thrshTexName{thrshInd},'Hochberg Correction')
latex = latexTable(data2import2);
texCode2File(figDir,strcat('ks-t',num2str(thrshInd),'.tex'),latex)

% data2import.tableLabel = strcat('tabel',num2str(thrshInd));
% data2import.tableCaption = strcat('statistical difference between ages, thereshold',thrshTexName{thrshInd})


%% One way ANOVA table 3 in report 20150406
freqData=cat(2,freqperAge{:,3}); % all PVLs frequency from all 
ageData=[];
for rowInd=1:size(freqperAge,1)
    ageData=[ageData, repmat(freqperAge{rowInd,1},1,freqperAge{rowInd,5})];
end
[~,~,stats] = anova1(freqData,ageData);
[c,~,~,ageNames] = multcompare(stats,'alpha', 0.05,'CType','bonferroni');
[ageNames(c(:,1)), ageNames(c(:,2)),num2cell(c(:,3:6))]
data2import3.tableColLabels={'age','age', 'p-value'};
data2import3.data=[str2num(cell2mat(ageNames(c(:,1)))), str2num(cell2mat(ageNames(c(:,2)))),c(:,6)];
data2import3.tableLabel = strcat('table',num2str(thrshInd));
data2import3.tableCaption = strcat('Statistical difference between ages, thereshold :',thrshTexName{thrshInd}, '. Bonferroni multicomparison correction')
latex = latexTable(data2import3);
texCode2File(figDir,strcat('anova-t',num2str(thrshInd),'.tex'),latex)

%% NP cells 
% NP absolute numbers Figure 6A in rreport 20150406
figure; bar([freqperAge{:,1}],[freqperAge{:,4}])
xlabel('age (dpf)');
ylabel('# of NPs recoded');
set(gca,'XLim',[3,10]);
set(gca,'XTick',[4:9]);
prepareFigure4Save(true, figDir, [],'NPsabsoluteValues')

%NP fraction from all neurons Figure 6B in rreport 20150406
figure;bar([freqperAge{:,1}],[freqperAge{:,4}]./([freqperAge{:,4}]+[freqperAge{:,5}]))
xlabel('age (dpf)');
ylabel('NPs proportion');
set(gca,'XLim',[3,10]);
set(gca,'XTick',[4:9]);
prepareFigure4Save(true, figDir, [],'NPproportion')

%NP numbers on average per age Figure 6C in rreport 20150406
figure;bar([freqperAge{:,1}],[freqperAge{:,4}]./[7,5,7,8,9,8])
xlabel('age (dpf)');
ylabel('# NPs');
set(gca,'XLim',[3,10]);
set(gca,'XTick',[4:9]);
prepareFigure4Save(true, figDir, [],'NPsperfish')

%% NP example of high and low frequency cells (6 low and 6 high)
highrateSINs=[10,87,97,131,136,141];
lowrateSINs=[91,106,109,137,119,121];
for i=1:6
    figure;plot(output(1).rasterAlltrials(highrateSINs(i),:));
    set(gca,'YLim',[0,20]);
    prepareFigure4Save(true, figDir, [],strcat('SINhigh',num2str(i)))
    figure;plot(output(1).rasterAlltrials(lowrateSINs(i),:))
    set(gca,'YLim',[0,20]);
    prepareFigure4Save(true, figDir, [],strcat('SINlow',num2str(i)))
end
% 
% for groupAgeInd=1:size(fishNamesGroupByAge,1)
%     fishNames=cell2mat(fishNamesGroupByAge{groupAgeInd,2});
%     fishInd=find(ismember(allFish,fishNames));
%     freq=[output(fishInd).eventFreqMin];
%     neuronsTotal=cat(1, output(fishInd).plottedSortTable);
% %     figure;hist(neuronsTotal(SINcells{groupAgeInd,2},6),20);
%     nbelow(groupAgeInd)=length(find(neuronsTotal(SINcells{groupAgeInd,2},6)<0.5))./length(SINcells{groupAgeInd,2});
%     nabove(groupAgeInd)=length(find(neuronsTotal(SINcells{groupAgeInd,2},6)>0.5))./length(SINcells{groupAgeInd,2});
% end
%   figure;bar([freqperAge{:,1}],nbelow)
%   xlabel('age (dpf)');
%     ylabel('SINs prop of low');
%     set(gca,'XLim',[3,10]);
%     set(gca,'XTick',[4:9]);
%     prepareFigure4Save(true, figDir, [],'SINproplowRate')
  figure;bar([freqperAge{:,1}],nabove)  
  
  
%% GMM of NP cells - PLOT
% GMM of integral values : figure not in the report
[n,x]=hist(integralNP2cluster,50);
figure;bar(x,n/(sum(n)*(x(2)-x(1))),1)
for j=1:nClustInt
line(x,optimalGMMInt.PComponents(j)*normpdf(x,optimalGMMInt.mu(j),sqrt(optimalGMMInt.Sigma(j))),'color','r')
end
xlabel('Area underneath the trace')
prepareFigure4Save(true, figDir, [], strcat('NPIntegralnonoisycells'));
%% GMM of NP frequency figure 11 in report 20150406
% histogram of frequencies of NP cells
figure;hist(freqNP2cluster,50)
xlabel('Freq (events/min)')
ylabel ('# occurances')
prepareFigure4Save(true, figDir, [], strcat('NPeventFreqnonoisycells'));
% plot AIC figure 11A
figure;plot(AICfreq)
xlabel('# clusters')
ylabel('AIC');
prepareFigure4Save(true, figDir, [], strcat('NPFreqnonoiseAIC'));
%figure 11 B
figure;plot(BICfreq)
xlabel('# clusters')
ylabel('BIC');
prepareFigure4Save(true, figDir, [], strcat('NPFreqnonoiseBIC'));
%plot GMM figure 11C
[n,x]=hist(freqNP2cluster,50);
figure;bar(x,n/(sum(n)*(x(2)-x(1))),1)
for j=1:3
line(x,optimalGMMfreq.PComponents(j)*normpdf(x,optimalGMMfreq.mu(j),sqrt(optimalGMMfreq.Sigma(j))),'color','r')
end
xlabel('Freq(events/min)')
prepareFigure4Save(true, figDir, [], strcat('NPFreqnonoiseGMM'));
 %% Are there different NP clusters of frequency over development?
% Histograms of NP freq over age, figure 16
 for ageInd=1:size(fishNamesGroupByAge,1)
 [nNPfreqPerAge(ageInd,:),xNPfreqPerAge(ageInd,:)]=hist(NPlookupTable(intersect(find(NPlookupTable(:,3)==fishNamesGroupByAge{ageInd,1}),find(NPlookupTable(:,6)==1)),9),50)
end
yLimHigh=max(max(nNPfreqPerAge));
xLimLow=min(min(xNPfreqPerAge));
xLimHigh=max(max(xNPfreqPerAge));
for ageInd=1:size(fishNamesGroupByAge,1)
 figure;bar(xNPfreqPerAge(ageInd,:),nNPfreqPerAge(ageInd,:),1);
 set(gca,'XLim',[xLimLow,xLimHigh]);
 set(gca,'YLim',[0,yLimHigh]);
 title(num2str(fishNamesGroupByAge{ageInd,1}))
 prepareFigure4Save(true, figDir, [], strcat('NPFreqHistPerAge',num2str(fishNamesGroupByAge{ageInd,1})));
end
%% Maybe we can find a difference over development if we grouped ages
% figure 17 A-C
group1=[4];
group2=[5,6,7];
group3=[8,9];
rowIndgrp1=[find(NPlookupTable(:,3)==4)];
rowIndgrp2=[find(NPlookupTable(:,3)==5);find(NPlookupTable(:,3)==6);find(NPlookupTable(:,3)==7)];
rowIndgrp3=[find(NPlookupTable(:,3)==8);find(NPlookupTable(:,3)==9)];
[nNPfreqPerAge(1,:),xNPfreqPerAge(1,:)]=hist(NPlookupTable(intersect(rowIndgrp1,find(NPlookupTable(:,6)==1)),9),50)
[nNPfreqPerAge(2,:),xNPfreqPerAge(2,:)]=hist(NPlookupTable(intersect(rowIndgrp2,find(NPlookupTable(:,6)==1)),9),50)
[nNPfreqPerAge(3,:),xNPfreqPerAge(3,:)]=hist(NPlookupTable(intersect(rowIndgrp3,find(NPlookupTable(:,6)==1)),9),50)
maxx=max(xNPfreqPerAge(:));
maxy=max(nNPfreqPerAge(:));

% plot absolute number on the histogram - figure 17
figure;bar(xNPfreqPerAge(1,:),nNPfreqPerAge(1,:));
set(gca,'XLim',[0,maxx],'YLim',[0,maxy]);
title(num2str(group1));
prepareFigure4Save(true, figDir, [], strcat('freqNPHistByAge-grp1'));
figure;bar(xNPfreqPerAge(2,:),nNPfreqPerAge(2,:));
set(gca,'XLim',[0,maxx],'YLim',[0,maxy]);
title(num2str(group2));
prepareFigure4Save(true, figDir, [], strcat('freqNPHistByAge-grp2'));
figure;bar(xNPfreqPerAge(3,:),nNPfreqPerAge(3,:));
set(gca,'XLim',[0,maxx],'YLim',[0,maxy]);
title(num2str(group3));
prepareFigure4Save(true, figDir, [], strcat('freqNPHistByAge-grp3'));

%plot normalized numbers on the histogram figure 17 D-F
maxx=max(xNPfreqPerAge(:));
maxy=max(max(nNPfreqPerAge./repmat(sum(nNPfreqPerAge')',1,size(nNPfreqPerAge,2))));

figure;bar(xNPfreqPerAge(1,:),nNPfreqPerAge(1,:)./sum(nNPfreqPerAge(1,:)));
set(gca,'XLim',[0,maxx],'YLim',[0,maxy]);
title(num2str(group1));
prepareFigure4Save(true, figDir, [], strcat('freqNPnormHistByAge-grp1'));
figure;bar(xNPfreqPerAge(2,:),nNPfreqPerAge(2,:)./sum(nNPfreqPerAge(2,:)));
set(gca,'XLim',[0,maxx],'YLim',[0,maxy]);
title(num2str(group2));
prepareFigure4Save(true, figDir, [], strcat('freqNPnormHistByAge-grp2'));
figure;bar(xNPfreqPerAge(3,:),nNPfreqPerAge(3,:)./sum(nNPfreqPerAge(3,:)));
set(gca,'XLim',[0,maxx],'YLim',[0,maxy]);
title(num2str(group3));
prepareFigure4Save(true, figDir, [], strcat('freqNPnormHistByAge-grp3'));



%%
%% Are this clusters spatially segragated on the NP
% figure 12 A
figure;plot(NPlookupTable(find(NPlookupTable(:,6)==1),7), NPlookupTable(find(NPlookupTable(:,6)==1),9),'.');
xlabel('Relative distance from the skin');
ylabel('Frequency (events/min)')
prepareFigure4Save(true, figDir, [], strcat('NPPopulationsonMinorAxis'));

%Figure 12B
figure;plot(NPlookupTable(find(NPlookupTable(:,6)==1),8), NPlookupTable(find(NPlookupTable(:,6)==1),9),'.')
xlabel('Relative position on the major axis');
ylabel('Frequency (events/min)')
prepareFigure4Save(true, figDir, [], strcat('NPPopulationsonMajorAxis'));


%projection on the major axis with the regression- figure 12C
projOnMajorAxis=NPlookupTable(find(NPlookupTable(:,6)==1),8);
tempfreq= NPlookupTable(find(NPlookupTable(:,6)==1),9);
s=regstats(tempfreq,projOnMajorAxis,'linear')
pval=s.fstat.pval;
rsqr=s.rsquare;
regressionLine=s.beta(1) + s.beta(2).*sort(projOnMajorAxis,'ascend'); 
figure;plot(NPlookupTable(find(NPlookupTable(:,6)==1),8), NPlookupTable(find(NPlookupTable(:,6)==1),9),'.')
xlabel('Relative position on the major axis');
ylabel('Frequency (events/min)')
hold on;plot(sort(projOnMajorAxis,'ascend'), regressionLine,'Color',[0,0,0]);
prepareFigure4Save(true, figDir, [], strcat('NPPopulationsonMajorAxisRegress'));

%SINs and NPs freq histograms figure 13 A-B
%testing is there a difference in frequency between SINs and NPs
activeNPInd=find(NPlookupTable(:,6)==1);
SINsInd=find(NPlookupTable(:,7)<0.3);
NPInd=find(NPlookupTable(:,7)>0.3);
[nSINs,xSINs]=hist(NPlookupTable(intersect(activeNPInd,SINsInd),9),50);
[nNPs,xNPs]=hist(NPlookupTable(intersect(activeNPInd,NPInd),9),50);
maxn=max([nSINs,nNPs]);
maxx=max([xSINs,xNPs])
figure;bar(xSINs,nSINs);
set(gca,'XLim',[0,maxx],'YLim', [0,maxn]);
prepareFigure4Save(true, figDir, [], strcat('SINsFreqHistohram'));
figure;bar(xNPs,nNPs);
set(gca,'XLim',[0,maxx],'YLim', [0,maxn]);
prepareFigure4Save(true, figDir, [], strcat('NPsFreqHistohram'));

%normalized histograms of frequency (SINs and PVLs) figure 13C-D
maxn=max([nSINs./sum(nSINs),nNPs./sum(nNPs)]);
maxx=max([xSINs,xNPs]);
figure;bar(xSINs,nSINs./sum(nSINs));
set(gca,'XLim',[0,maxx],'YLim', [0,maxn]);
prepareFigure4Save(true, figDir, [], strcat('SINsFreqnormHistohram'));
figure;bar(xNPs,nNPs./sum(nNPs));
set(gca,'XLim',[0,maxx],'YLim', [0,maxn]);
prepareFigure4Save(true, figDir, [], strcat('NPsFreqnormHistohram'));

% position vs frequency ttest - figure 12D
freqabv1=find(NPlookupTable(:,9)>1);
freqblw1=find(NPlookupTable(:,9)<1);
positionHigh=NPlookupTable(intersect(noNoiseNpInd,freqabv1),7);
positionLow=NPlookupTable(intersect(noNoiseNpInd,freqblw1),7);
figure;bar(1:2,[mean(positionLow),mean(positionHigh)]);hold on;
set(gca,'XLim',[0,3]);
errorbar(1,mean(positionLow),std(positionLow),'Color',[0,0,0]);
errorbar(2,mean(positionHigh),std(positionHigh),'Color',[0,0,0]);
set(gca,'XTick', [1,2],'XTickLabel',{'Low freq';'High Freq'});
ylabel('Cells depth')
[h,p,ci,stats] = ttest2(positionLow,positionHigh);
prepareFigure4Save(true, figDir, [], strcat('NPHighvsLowFreqTtest'));


%plot the difference between SINs and PVLs on two bars ( ttest)
grp1=NPlookupTable(intersect(activeNPInd,SINsInd),9);
grp2=NPlookupTable(intersect(activeNPInd,NPInd),9);
[h,p,ci,stats] = ttest2(grp1,grp2);
grpmean=[mean(grp1),mean(grp2)];
grpstd=[std(grp1),std(grp2)];
figure;bar(1:2,grpmean);hold on;
errorbar(1,grpmean(1),grpstd(1),'Color',[0,0,0]);
errorbar(2,grpmean(2),grpstd(2),'Color',[0,0,0]);
set(gca,'XLim',[0,3])
set(gca,'XTick', [1,2],'XTickLabel',{'SINs';'NPs'});
ylabel('Event frequency (events/min)')
prepareFigure4Save(true, figDir, [], strcat('SINsvsNPsTtest'));

%Project all cells on a universal NP- figure 14
majAx=200;minAx=100;
a=zeros(minAx,majAx);
allNP=[round(NPlookupTable(activeNPInd,7)*minAx),round(NPlookupTable(activeNPInd,8)*majAx),NPlookupTable(activeNPInd,9)];
figure; plotellipse([majAx/2;minAx/2],majAx/2,minAx/2,0);hold on;
freq=allNP(:,3); freq(find(freq>3))=3;
scatter(allNP(:,2),allNP(:,1),20,freq,'filled')
p=get(gca,'position'); % save position
cbh=(colorbar);
cbp=get(cbh,'Position');
set(cbh,'Location','EastOutside');
set(gca,'position',[p(1)*0.7,p(2:4)]);
set(cbh,'Position',[0.89, p(2)+0.1,0.7*cbp(3),0.87*p(4)]);%0.7*cbp(3),0.9*cbp(4)
set(gca,'XTick',[],'YTick',[]);
prepareFigure4Save(true, figDir, [], strcat('universalNP'));

%prepare a universal NP for each age - figure 15
for ageInd=1:size(fishNamesGroupByAge,1)
clear ageCellInd;
fishage=[(fishNamesGroupByAge{ageInd,1})];
majAx=200;minAx=100;
a=zeros(minAx,majAx);
ageCellInd=find(NPlookupTable(:,3)==fishage);
allNPperAge=[(NPlookupTable(intersect(activeNPInd,ageCellInd),7)*minAx),(NPlookupTable(intersect(activeNPInd,ageCellInd),8)*majAx),NPlookupTable(intersect(activeNPInd,ageCellInd),9)];
freqNPage=NPlookupTable(intersect(activeNPInd,ageCellInd),9);
freqNPage(find(freqNPage>3))=3;
figure; plotellipse([majAx/2;minAx/2],majAx/2,minAx/2,0);hold on;
freq=allNP(:,3); freq(find(freq>3))=3;
scatter(allNPperAge(:,2),allNPperAge(:,1),20,freqNPage,'filled');
caxis([0,3])
p=get(gca,'position'); % save position
cbh=(colorbar);
cbp=get(cbh,'Position');
set(cbh,'Location','EastOutside');
set(gca,'position',[p(1)*0.7,p(2:4)]);
set(cbh,'Position',[0.89, p(2)+0.1,0.7*cbp(3),0.87*p(4)]);
set(gca,'XTick',[],'YTick',[]);
title(num2str(fishage));
prepareFigure4Save(true, figDir, [], strcat('universalNP-age',num2str(fishage)));
end



%%
