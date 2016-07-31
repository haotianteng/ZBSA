function NPSpatialProps(fishName,cond)  
%posthoc , after fish are already preprocessed
%fits an ellipse to the NP and find the coordinates of the major and
%cond: "EN" or "Reg" i.e enucleated fish or regular SA fish no special condition
    %the minor axis
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
        [x, y] = getpts(gca);
        points=[x';y';];
        [zb, ab, bb, alphab] = fitellipse(points, 'linear');
        hold on;
        plotellipse(zb, ab, bb, alphab, 'r--');
        if ab<bb   %ab is the semi minor and bb is the semi major
            NP.ellipseCentre  = zb; % ellipse centre
            NP.ellipseSemiMin = ab; %ellipse semi minor axis
            NP.ellipseSemiMaj = bb; %ellipse semi major axis
            NP.ellipseRot     = alphab; %ellipse rotation
            xMinor1 = zb(1) + ab * cos(alphab);
            xMinor2 = zb(1) - ab * cos(alphab);
            yMinor1 = zb(2) + ab * sin(alphab);
            yMinor2 = zb(2) - ab * sin(alphab);
            line([xMinor1,xMinor2],[yMinor1,yMinor2],'Color',[1,0,0])
            xMajor1 = zb(1) + bb * cos(alphab+pi/2);
            xMajor2 = zb(1) - bb * cos(alphab+pi/2);
            yMajor1 = zb(2) + bb * sin(alphab+pi/2);
            yMajor2 = zb(2) - bb * sin(alphab+pi/2);
            line([xMajor1,xMajor2],[yMajor1,yMajor2],'Color',[1,1,0]);
        else %%bb semin minor and ab semi major
            NP.ellipseCentre  = zb; % ellipse centre
            NP.ellipseSemiMin = bb; %ellipse semi major axis
            NP.ellipseSemiMaj = ab; %ellipse semi minor axis
            NP.ellipseRot     = alphab; %ellipse rotation
            xMajor1 = zb(1) + ab * cos(alphab);
            xMajor2 = zb(1) - ab * cos(alphab);
            yMajor1 = zb(2) + ab * sin(alphab);
            yMajor2 = zb(2) - ab * sin(alphab);
            line([xMajor1,xMajor2],[yMajor1,yMajor2],'Color',[1,1,0])
            xMinor1 = zb(1) + bb * cos(alphab+pi/2);
            xMinor2 = zb(1) - bb * cos(alphab+pi/2);
            yMinor1 = zb(2) + bb * sin(alphab+pi/2);
            yMinor2 = zb(2) - bb * sin(alphab+pi/2);
            line([xMinor1,xMinor2],[yMinor1,yMinor2],'Color',[1,0,0]);
        end
        
        [pvlsideMinorx, pvlsideMinory] = getpts(fig); %minor close to PVL
        [anteriorMajorx,anteriorMajory]=getpts(fig);  %major anterior
        
        distToMinor1=pdist([pvlsideMinorx, pvlsideMinory;xMinor1,yMinor1],'euclidean');
        distToMinor2=pdist([pvlsideMinorx, pvlsideMinory;xMinor2,yMinor2],'euclidean');
        
        distToMajor1=pdist([anteriorMajorx, anteriorMajory;xMajor1,yMajor1],'euclidean');
        distToMajor2=pdist([anteriorMajorx, anteriorMajory;xMajor2,yMajor2],'euclidean');

        if distToMinor1<distToMinor2
            pvlMinorPoint=[xMinor1,yMinor1];
            skinMinorPoint=[xMinor2,yMinor2];
        else
            pvlMinorPoint=[xMinor2,yMinor2];
            skinMinorPoint=[xMinor1,yMinor1];
        end
        if distToMajor1<distToMajor2
            antMajorPoint=[xMajor1,yMajor1];
            postMajorPoint=[xMajor2,yMajor2];
        else
            antMajorPoint=[xMajor2,yMajor2];
            postMajorPoint=[xMajor1,yMajor1];
        end
        
        NP.ellipseMinorPvlSide=pvlMinorPoint;
        NP.ellipseMinorskinSide=skinMinorPoint;
        NP.ellipseMajorAnterior=antMajorPoint;
        NP.ellipseMajorPosterior=postMajorPoint;
        NP.MinorVec=pvlMinorPoint-skinMinorPoint;
        NP.MajorVec=postMajorPoint-antMajorPoint;
        NP.refMinor=skinMinorPoint;
        NP.refMajor=antMajorPoint;
        NP.frame=m; % mean of 200 frames od DataRealignedNP of the last trial processed
        NP.frameClipLow=cliplow;
        NP.frameClipHigh=cliphigh;
        prepareFigure4Save(true, path2saveFigures, [], strcat(fishName,'-EllipseFit'));
        save(strcat(path2loadintermedData,fishName,'-NPSpatialProps'),'NP');
    end
end