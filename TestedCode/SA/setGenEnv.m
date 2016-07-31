function [rootFolder,fishRootFolder,csvFilePath]=setGenEnv(cond)
% rootFolder     : the system root folder (C:\- for PC or / for Unix)
% fishRootFolder : folder where all fish folders are
% csvFilePath    : a folder to where all integrated products are
%


if (isunix==0)
    rootFolder='D:\';
    if strcmp(cond,'EN') % Enucleated condition
        fishRootFolder=strcat(rootFolder,'Data',filesep, 'SA',filesep,'EN',filesep);
    elseif strcmp(cond,'Reg') % regular condition
        fishRootFolder=strcat(rootFolder,'Data',filesep, 'SA',filesep);
    end
    csvFilePath=strcat(rootFolder,'Data\SAoutfiles\');
    addpath([rootFolder,'Dev',filesep,'zf',filesep,'zfbrain',filesep,'3rdParty',filesep,'export_fig']);
    addpath([rootFolder,'Dev',filesep,'zf',filesep,'zfbrain',filesep,'SA']);
    addpath(genpath([rootFolder,'Dev',filesep,'zf',filesep,'zfbrain',filesep,'AssemblyDetection']));

elseif (isunix==1)
    rootFolder='/';
    if strcmp(cond,'EN')
       fishRootFolder=strcat(rootFolder, 'ibscratch', filesep, 'users', filesep, 'uqlavita',filesep,'EN',filesep);
    elseif strcmp(cond,'Reg')
        fishRootFolder=strcat(rootFolder, 'ibscratch', filesep, 'users', filesep, 'uqlavita',filesep);
    end
    set(0, 'DefaultFigureVisible', 'off');
    csvFilePath='/clusterdata/lilacha/SAoutfiles/';
%     addpath([rootFolder,'clusterdata',filesep,'lilacha',filesep,'zfbrain',filesep,'3rdParty',filesep,'export_fig'])
%     addpath([rootFolder,'clusterdata',filesep,'lilacha',filesep,'zfbrain',filesep,'SA']);
end