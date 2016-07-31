function [FishIndex,CellIndex] = FindIndex(Index,AccumNum)
%This function is used to find the origin index of from Acuumation Index
CellIndex = zeros(2,1);
for i = 1:length(AccumNum)

    if (Index < AccumNum(i))
        FishIndex = i;
        break;
    
    end
    Index = Index - AccumNum(i);
    
end
CellNum = floor(sqrt(AccumNum(FishIndex)*2))+1;
CellIndex(1) = ceil((sqrt(1+8*Index)-1)/2);
CellIndex(2) = Index - CellIndex(1)*(CellIndex(1)-1)/2;
CellIndex(1) = CellIndex(1)+1;
end