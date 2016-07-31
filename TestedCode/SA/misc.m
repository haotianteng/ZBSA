% fagename=[3	20150824	1
% 4	20150825	1
% 4	20150915	1...]
cond='EN'; % or %Reg (at the moment for Reg you can leave cond empty [].

%% generating a matrix of fish name and fish age
%fagename is a matrix copied from excel
fishname=cellstr([num2str(fagename(:,2)),repmat('-f',size(fagename,1),1),num2str((fagename(:,3)))])
fishNameAge=[fishname,num2cell(fagename(:,1))];
[rootFolder,fishRootFolder,SAOutPath]=setGenEnv(cond);
savePrefix='';
save([SAOutPath, strcat(savePrefix, 'fishNameAge',cond)], 'fishNameAge');

%for the EN condition linking two tecta to one fish
fishList = [5	20160315	31	32;
7	20160316	11	12;
8	20160317	11	12;
9	20160318	11	12;];
% 7	20160316	21	22;
% 5	20160315	21	21;];
fishNameENTectum= cellstr([num2str(fishList(:,2)),repmat('-f',size(fishList,1),1),num2str((fishList(:,3)))]);      
fishNameIntctTectum= cellstr([num2str(fishList(:,2)),repmat('-f',size(fishList,1),1),num2str((fishList(:,4)))]);      
fishListEN=[num2cell(fishList(:,1)),fishNameENTectum,fishNameIntctTectum];
save([SAOutPath, strcat(savePrefix, 'fishList',cond)], 'fishListEN');
scope=['s','s','s','s','i','i'];
save([SAOutPath, strcat(savePrefix, 'fishList',cond,'scope')], 'scope');


%