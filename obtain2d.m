function   obtain2d(Location,type)
%OBTAIN2D �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[r,c]=size(Location);
if (r<c)
    Location=Location';
end
plot(Location(:,1),Location(:,2),type);
axis equal;
end

