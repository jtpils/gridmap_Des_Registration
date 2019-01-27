function  showLineMulti(start,ends)
%SHOWLINEMULTI 此处显示有关此函数的摘要
%   此处显示详细说明
hold on;
for i=1:size(start,1)
    line([start(i,1);ends(i,1)],[start(i,2);ends(i,2)],'LineStyle','-','Marker','o');
end
end

