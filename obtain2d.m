function   obtain2d(Location,type)
%OBTAIN2D 此处显示有关此函数的摘要
%   此处显示详细说明
[r,c]=size(Location);
if (r<c)
    Location=Location';
end
plot(Location(:,1),Location(:,2),type);
axis equal;
end

