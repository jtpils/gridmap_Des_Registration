function [pCloud3d,points2d] = exarctPCfroImg(img)
%EXARCTPCFROIMG �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
binImg=edge(img);
[Y,X] = find(binImg==1);
points2d=[X,Y];
pCloud3d=pointCloud([X Y zeros(length(X),1)]);

end

