function Distance =  DistanceMatrix(Fish,DistanceCoordinateSystem)
if nargin<2
    DistanceCoordinateSystem = 'Normal';
end
    Coor = Fish.plottedSortTable; %Fish coordinate
    Distance = 1;
    ChosenCellInd = Fish.cellsOfInterest;
    if(DistanceCoordinateSystem == 'Normal')
        x = Coor(ChosenCellInd,3); %X coordinate of the cell
        y = Coor(ChosenCellInd,4); %Y coordinate of the cell
    elseif(DistanceCoordinateSystem == 'Topology')
        x = Coor(ChosenCellInd,3); %X coordinate of the cell
        y = Coor(ChosenCellInd,4); %Y coordinate of the cell
    end
    CellNum = size(x,1);
    Distance = zeros(CellNum);
    for i = 1:CellNum
        for j = 1:CellNum
            
            Distance(i,j) = sqrt((x(i)-x(j))^2 + (y(i)-y(j))^2);
            
        end
    end
end
