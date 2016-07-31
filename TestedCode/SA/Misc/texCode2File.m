
function texCode2File(path,fileName,code)
fid = fopen(fullfile(path,fileName), 'wt+') 
for i = 1 : size(code,1) 
fprintf(fid, '%s\t\n', code{i,:}); 
end 
fclose(fid);