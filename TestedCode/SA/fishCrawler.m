% fishCrawler( rootFolderStr, procedureStr)
function fishCrawler(procedureStr)
%function for local use only
%on the cluster use the fishcrawler.sh script under scripts folder
[rootFolder,fishRootFolder,csvFilePath]=setGenEnv(); 
outputfilePath='C:\Data\'
fishFolders = dir(fishRootFolder) ;                             % list of fish folder
resultFileName=procedureStr;                                    % crawler file name
resultFileFormat='csv';                                         % result file format
output= struct('name',[]);
fn=strcat(csvFilePath,resultFileName,'.','csv');
fileHandle=fopen(fn,'w+');
fishInd=1;
tic
for folderInd=3:length(fishFolders)
fishFolder=fishFolders(folderInd).name
fishFile2Load=strcat(fishRootFolder, fishFolder,filesep,'processed',filesep, fishFolder,'-processedFishUnifiedTrials.mat');
    if exist(fishFile2Load,'file')
        if strcmp(procedureStr,'actProps')
            getActProp(fishFolder);
            paramStr=['\n %s' ];
            S=sprintf(paramStr,fishFolder);
            fprintf(fileHandle,'%s',S);
           output(fishInd).name=fishFolder;
           fishInd=fishInd+1;
        end
    end
end
fclose(fileHandle);




