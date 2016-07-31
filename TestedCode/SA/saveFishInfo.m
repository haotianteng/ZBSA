function saveFishInfo(outputObj, procedureStr, savePrefix)
%function recieved an all fish struct and extracts the information of
%interest based on the procedure-struct receieved.
if nargin<3
    savePrefix='';
end
    if strcmp(procedureStr,'actProps')
        fishName={outputObj.fishName}';
        meanEventFreqMin=[outputObj.meanEventFreqMin]';
        recTimeMin=[outputObj.recTimeMin]';
%         sigAssSize=[outputObj.sigAssSize]';
%         numPeaks=[outputObj.numPeaks]';
%         meanPeakMag=[outputObj.meanPeakMag]';
        meanActiveDeltaF=[outputObj.meanActiveDeltaF]';
        nNeurons=[outputObj.numActNeurons]';
        actPropsCell = [cellstr(fishName) num2cell([meanEventFreqMin,meanActiveDeltaF,nNeurons]) ];
        actPropsMat=[meanEventFreqMin meanActiveDeltaF  nNeurons   ]
        actPropsMatInd={1,'fishName'; 2,'meanEventFreqMin'; 3, 'meanActiveDeltaF'; 4, 'nNeurons'; }
        [rootFolder,fishRootFolder,csvFilePath]=setGenEnv(savePrefix);
        save(fullfile(csvFilePath,strcat('output-',savePrefix,'actPropsCell')),'actPropsCell');
        save(fullfile(csvFilePath,strcat('output-',savePrefix,'actPropsMat')),'actPropsMat');
        save(fullfile(csvFilePath,strcat('output-',savePrefix,'actPropsMatInd')),'actPropsMatInd');
    end
end