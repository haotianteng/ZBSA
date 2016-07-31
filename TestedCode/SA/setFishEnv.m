function [path2loadData,path2loadintermedData,path2saveFigures,path2saveData]=setFishEnv(fishRootFolder, fishName)
c=computer;
if (isunix==0)
    rootFolder='C:\';
%     fishRootFolder=strcat(rootFolder,'Data',filesep, 'SA',filesep);
    path2loadData= [fishRootFolder fishName filesep 'processed' filesep];
    path2loadintermedData=[fishRootFolder fishName filesep 'intermediate' filesep];
    path2saveFigures= [fishRootFolder fishName filesep 'output' filesep];
    path2saveData= [fishRootFolder fishName filesep 'processed' filesep];
elseif (isunix==1)
    rootFolder='/';
%     fishRootFolder=strcat('ibscratch', filesep, 'users', filesep, 'uqlavita',filesep);
    path2loadData= [fishRootFolder fishName filesep 'processed' filesep];
    path2loadintermedData=[fishRootFolder fishName filesep 'intermediate' filesep];
    path2saveFigures= [fishRootFolder fishName filesep 'output' filesep];
    path2saveData= [fishRootFolder fishName filesep 'processed' filesep];
   
end