% Fishes = load('C:\UQ\GoodhillIntern\Distance\output-EN-graphProps.mat');
% Normal = Normal.output;
dpf6FishIndex = [1 3 8 13 14 18 28 29 39];
%Normal = Normal(dpf6FishIndex);
Fishes = load('C:\UQ\GoodhillIntern\Distance\output-DR-graphProps.mat');
% Fishes = load('C:\UQ\GoodhillIntern\Distance\output-Reg-graphProps.mat');
% dpf6FishIndex = [1 3 5 7 9 11 13]%14 18 28 29 39];
Fishes = Fishes.output;
% Fishes = Fishes(dpf6FishIndex);
close all;
FishNum = size(Fishes,2);
TestIndex = 10;

FilterOrder = 5;
FilterCoefficient = 0.10;
[b,a] = butter(FilterOrder,FilterCoefficient);
freqz(b,a)
A=1;
B=ones(1,20)*0.05;


for FishIndex = 1:FishNum
Fish = Fishes(:,FishIndex);
rastertrails = Fish.rasterAlltrials(Fish.cellsOfInterest,:);
dataOut = filtfilt(b,a,rastertrails')';
dataOut2 = filter(B,A,dataOut')';
Fish.filterAlltrails = dataOut2;
dataOut2 = dataOut2';
Fishes(:,FishIndex).filtedCorrMat = cov(dataOut2)./(std(dataOut2)'*std(dataOut2));
dataOut2 = dataOut2';
Fishes(:,FishIndex).filtedTrial = dataOut2;
end
plot(dataOut2(TestIndex,:));
figure;
TestTrial = dataOut2(TestIndex,:);
Histogram = histogram(TestTrial,10);
Histogram.Normalization = 'probability';
figure;
plot(dataOut2(TestIndex,:));
figure;
plot(rastertrails(TestIndex,:));
title('trails after low-pass filter');

% MinS = prctile(dataOut(TestIndex,:),15);
% x = dataOut(TestIndex,:);
% x(x<MinS) = 0;
% figure;
% plot(x);
% 
% x = dataOut(TestIndex,:);
% x = x - mean(x);
% figure;
% plot(x);