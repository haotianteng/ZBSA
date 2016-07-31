function sortFishByAge(savePrefix)
if nargin<1
    savePrefix=[];
end
[rootFolder,fishRootFolder,csvFilePath]=setGenEnv();
load(fullfile(csvFilePath,'fishNameAge.mat'))
FishNameCol=1;
FishAgeCol=2;
ages=unique(cell2mat(fishNameAge(:,FishAgeCol)));
fishNamesGroupByAge=cell(size(ages,1),2); % a cell holding for each age group the fishnames relevant
for ageInd=1:length(ages)
   fishIndPerAge=find(cell2mat(fishNameAge(:,FishAgeCol))==ages(ageInd));
   fishNamesGroupByAge{ageInd,1}=ages(ageInd);
   fishNamesGroupByAge{ageInd,2}={fishNameAge{fishIndPerAge,FishNameCol}}';
end
save([csvFilePath, strcat(savePrefix, 'fishNamesGroupByAge')], 'fishNamesGroupByAge');
