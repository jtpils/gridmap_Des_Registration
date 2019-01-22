function [srcIdx] = rangeSearchDiffR(srcData,grid,specPoint,zoomVar)
%RANGESEARCHDIFFR 变化半径的rangesearch
%   此处显示详细说明
%  arrayfun(@()(sqrt),specPoint)
 C=srcData;
 dN=length(C);    
 id=(1:dN);
 srcIdx=cell(1,length(specPoint));
 for i=1:length(specPoint)
    P=specPoint(i).Location;
    distance = sqrt(P.^2*ones(size(C))+[1,1]*(C).^2-2*P*C);
    srcIdx{i} = id(distance<(grid*specPoint(i).Scale/zoomVar));
 end
srcIdx=srcIdx';
end

% sqrt(P.^2*ones(size(C'))+ones(size(P))*(C').^2-2*P*C')