% fishCrawler( rootFolderStr, procedureStr)
% function fishCrawler(fishFolder)
function output=collectFishInfo(procedureStr,cond)
% function reads procedure-struct of each fish and gather them into one
% struct.
%Procedures: actProps
%cond      : "EN" or "Reg"
structName=procedureStr;
if strcmp(procedureStr,'actProps')
    fileSuffix='-actProps.mat';
end
%% setting the environment
[rootFolder,fishRootFolder,csvFilePath]=setGenEnv(cond); 
fishFolders = dir(fishRootFolder) ;                             % list of fish folder
nfish=size(fishFolders,1);

%% initializing an array of structs with the fields necessary
tempfsihFolder=3;
fishFolder=fishFolders(tempfsihFolder).name;
fishFile2Load=strcat(fishRootFolder, fishFolder,filesep,'processed',filesep, fishFolder,fileSuffix);
load(fishFile2Load);
fieldNames=fieldnames(actProps);
nfieldNames=size(fieldNames,1);
output(nfish)=actProps;

%% Collecting information from all fish structs
resultFileName=strcat('output-',procedureStr);                                    % crawler file name
resultFileFormat='csv';   
resultFullFileName=strcat(resultFileName,'.',resultFileFormat);
fileHandle=fopen(fullfile(csvFilePath,resultFullFileName),'w+');
fishInd=1;
for folderInd=3:length(fishFolders)
 fishFolder=fishFolders(folderInd).name;
 fishFile2Load=strcat(fishRootFolder, fishFolder,filesep,'processed',filesep, fishFolder,fileSuffix);
    if exist(fishFile2Load,'file')
     load(fishFile2Load);
     output(fishInd)=actProps;
     fishInd=fishInd+1;
     paramStr=['\n %s' ];
     S=sprintf(paramStr,fishFolder);
     fprintf(fileHandle,'%s',S);
    end % if file exist
    output=output(1:fishInd-1);
 end
fclose(fileHandle);
save([csvFilePath, 'output-',procedureStr,'-',cond], 'output', '-v7.3');
saveFishInfo(output, procedureStr, cond)
