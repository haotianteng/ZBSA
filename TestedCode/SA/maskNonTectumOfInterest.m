function maskNonTectumOfInterest(fishName,cond)
% an ad-hoc aid function to mark all regions outside of the tectum of interest
% for the enucleated data, and to save the mask as a file in the
% intermediate folder of the respective fish. This procedure will be
% added to preprocess2 to be part of masking phase (nonPVL(NP), and
% nonTectumOfInterest).

    [rootFolder,fishRootFolder,csvFilePath]=setGenEnv(cond);     
    [path2loadData,path2loadintermedData,path2saveFigures,path2saveData]=setFishEnv(fishRootFolder, fishName);
    fishFile2Load=strcat(fishRootFolder, fishName,filesep,'processed',filesep, fishName,'-processedFishUnifiedTrials.mat');
    if exist(fishFile2Load,'file')
         load(fishFile2Load);
        trialID=processedFish.trialIDs(end);
    end
    filetoload= strcat(fishRootFolder, fishName,filesep,'intermediate',filesep, fishName,'-t',num2str(trialID),'-dataGlobalAlignednp.mat');  
    if exist(filetoload,'file')
        load(filetoload);
        m=mean(dataGlobalAlignednp(:,:,1:200),3);
        cliplow = min(min(m))
        cliphigh = prctile(m(:),95);
        fig=figure;imagesc(m, [cliplow,cliphigh]);
        set(gca,'XTickLabel',[],'YTickLabel',[]);
        colormap gray;
        title(fishName)
        disp('Please crop NP region')
        h=impoly;
        bw=createMask(h);
        npAligned=1-bw;
        save(strcat(path2loadintermedData,fishName,'-npAligned'),'npAligned');
        disp('Please crop non tectum -of -interest region')
        h=impoly;
        bw=createMask(h);
        nonTectumOfIneterestMask=1-bw;
        save(strcat(path2loadintermedData,fishName,'-nonTectumOfInterest'),'nonTectumOfIneterestMask');
    end
