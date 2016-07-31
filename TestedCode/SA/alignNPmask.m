function alignNPmask(fishName,cond)
fileName=strcat(fishName,'-processedFishUnifiedTrials.mat');
[rootFolder,fishRootFolder, csvFilePath]=setGenEnv(cond);
[path2loadData,path2loadintermedData,path2saveFigures,path2saveData]=setFishEnv(fishRootFolder,fishName);
load(strcat(path2loadData,fileName));
trialnum=processedFish.trialIDs(end);
load (strcat(path2loadintermedData,fishName,'-t',num2str(trialnum),'-tformToFixed.mat'));
load (strcat(path2loadintermedData,fishName,'-t',num2str(trialnum),'-neuropilMask.mat'));


xRange = [1,400 ]; %eg 145, 512
yRange = [1, 300]; %eg 62, 418
xminval = inf;
xmaxval = -inf;
yminval = inf;
ymaxval = -inf;

dataRegCroppedTrimmedSpatialData = imref2d([size(mask,1), size(mask,2)], xRange, yRange ); %note that matlab expects the xRange and yRange order to be the conventional image x by y, not the matlab y by x
movingFrame = mask; %any frame, transform already determined
movingRef = dataRegCroppedTrimmedSpatialData;
[maskaligned] = findTransformedReference(movingFrame, movingRef, tformToFixed); 

    %find the global max and min
        if floor(maskaligned.XWorldLimits(1)) < xminval
            xminval= floor(maskaligned.XWorldLimits(1));
        end
        if ceil(maskaligned.XWorldLimits(2) )> xmaxval
            xmaxval= ceil(maskaligned.XWorldLimits(2) );
        end
        if floor(maskaligned.YWorldLimits(1)) < yminval
            yminval= floor(maskaligned.YWorldLimits(1));
        end
        if ceil(maskaligned.YWorldLimits(2)) > ymaxval
            ymaxval= ceil(maskaligned.YWorldLimits(2));
        end

    %may not do as intended
    globalRef = imref2d([ymaxval-yminval+1, xmaxval-xminval+1], [xminval, xmaxval],[yminval, ymaxval]);
    
    %align and project all trials
    
       dataGlobalAlignedSpatialData = globalRef;
        %step through each frame and apply alignment
        dataGlobalAligned = zeros([globalRef.ImageSize(1), globalRef.ImageSize(2), 1 ]);
        [npAligned, ~] = imwarp(mask, dataRegCroppedTrimmedSpatialData ,tformToFixed, 'OutputView', globalRef, 'FillValues', 0);
        
        save([path2loadintermedData,fishName '-npAligned'], 'npAligned', '-v7.3');
end
