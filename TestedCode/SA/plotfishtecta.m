%This script runs in a bulk on all processed fish and marks the NP, fits an
%ellipse and find the minor and major axis 
% figDir = 'C:\Reports\20160316\figs\';
[rootFolder,fishRootFolder,csvFilePath]=setGenEnv(); 
fishFolders = dir(fishRootFolder) ;                             % list of fish folder
nfish=size(fishFolders,1);
for folderInd=8:8%length(fishFolders)
 NPSpatialProps(fishFolders(folderInd).name)    
 end