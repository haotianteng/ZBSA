function [optimalGMM, nClust, AIC, BIC]= GMM(data,nmaxcluster)

AIC = zeros(1,nmaxcluster);
GMModels = cell(1,nmaxcluster);
options = statset('MaxIter',500);
for k = 1:nmaxcluster
    GMModels{k} = fitgmdist(data,k,'Options',options,'CovarianceType','diagonal');
    AIC(k)= GMModels{k}.AIC;
    BIC(k)= GMModels{k}.BIC;
end
[minAIC,nClust] = min(AIC);
[minBIC,nClust] = min(BIC);

optimalGMM = GMModels{nClust};
% [n,x]=hist(data,50);
% figure;bar(x,n/(sum(n)*(x(2)-x(1))),1)
% for j=1:nClust
% line(x,optimalGMM.PComponents(j)*normpdf(x,optimalGMM.mu(j),sqrt(optimalGMM.Sigma(j))),'color','r')
% end
