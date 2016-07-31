% function Succeed = Distance_Correlation(Fishes,FilterTag,FigureOn,NullTest)
% if (nargin <4)
%     NullTest = true;
%     if(nargin <3)
%         FigureOn = true;
%         if(nargin<2)
%             FilterTag = true;
%         end
%     end
% end
FilterTag = true;
FigureOn = true;
NullTest = true;
Succeed = 1;
XInterval = 25;
YInterval = 0.2;

FishNum = size(Fishes,2);
accumCorrelation = [];
accumDistance = [];
accumIndex = 0;
accumNum= [];
accumShuffledCorr=[];

for FishIndex = 1:FishNum
accumIndex = accumIndex + 1;
Fish = Fishes(:,FishIndex);
ChosenCellInd = Fish.cellsOfInterest;
CellNum = size(ChosenCellInd,2);
Distance = DistanceMatrix(Fish);
    if(FilterTag == false)
        Trials = Fish.rasterAlltrials(Fish.cellsOfInterest,:);
        Correlation = Fish.corrMat;
    else
        Trials = Fish.filtedTrial;
        Correlation = Fish.filtedCorrMat;
    end
Distance = Distance(and(triu(true(size(Distance))),not(diag(diag(true(size(Distance)))))));%Take the upper triangular without the diagonal part
Correlation = Correlation(and(triu(true(size(Correlation))),not(diag(diag(true(size(Correlation))))))); %Take the upper triangular without the diagonal part
Histogram = zeros(CellNum,2);
Histogram = hist3([Distance,Correlation],[15,15]);
accumDistance = [accumDistance;Distance];
accumCorrelation = [accumCorrelation;Correlation];
accumNum(FishIndex) = size(Distance,1);

if(NullTest == true)
    [ShuffledTrials,ShuffledCorrMat] = MyShuffle(Trials);
    ShuffledCorrelation = ShuffledCorrMat(and(triu(true(size(ShuffledCorrMat))),not(diag(diag(true(size(ShuffledCorrMat)))))));
    accumShuffledCorr = [accumShuffledCorr;ShuffledCorrelation];
    FilterOrder = 5;
    FilterCoefficient = 0.10;
    [b,a] = butter(FilterOrder,FilterCoefficient);
    freqz(b,a)
    A=1;
    B=ones(1,20)*0.05;
    dataOut = filtfilt(b,a,ShuffledTrials')';
    dataOut2 = filter(B,A,dataOut')';
    dataOut2 = dataOut2';
    ShuffledCorrMat = cov(dataOut2)./(std(dataOut2)'*std(dataOut2));
    dataOut2 = dataOut2';
end


%figure;
%splot(Distance,Correlation,'.')
%figure;
%surf(Histogram);
end



if(FigureOn == true)
figure;
plot(accumDistance,accumCorrelation,'.');
xlabel('Distance');ylabel('Accumulation Correlation')
title('Distribution')
Histogram = hist3([accumDistance,accumCorrelation],{0:XInterval:500,-0.4:YInterval:1});
figure;
surf(0:XInterval:500,-0.4:YInterval:1,Histogram');
title('Histogram');
xlabel('Distance');ylabel('Accumulation Correlation');
if(NullTest == true)
    figure;
    plot(accumDistance,accumShuffledCorr,'.');
    xlabel('Distance');ylabel('Shuffled Accumulation Correlation')
    title('Distribution')
    
end

end
for d = 50:50:500

    InDistance = and(accumDistance<d , accumDistance>(d-50));
    InCorrelation = accumCorrelation(InDistance);
    if(FigureOn == true)
    figure;
    Histogram = histogram(InCorrelation,20);
    Histogram.Normalization = 'probability';
    hold on;
    xx = Histogram.BinLimits(1):Histogram.BinWidth:Histogram.BinLimits(2);
    xx = xx';
    [optimalGMM, nClust, AIC, BIC] = GMM(InCorrelation,2);
    gm = optimalGMM;
    plot(xx,pdf(gm,xx)*Histogram.BinWidth);
    for j=1:2
        line(xx,gm.PComponents(j)*normpdf(xx,gm.mu(j),sqrt(gm.Sigma(j)))*Histogram.BinWidth,'color','r')
    end
    
    
    xlabel('Correlation');ylabel('Count');
    title(['Histogram of Regular fish with a neuron distance d: ',num2str(d-50),' < d < ',num2str(d)]);
    hold off;
    end
    saveas(gcf,['Histogram_Regular_fish_',num2str(d-50),'_d_',num2str(d)],'jpg');
end


