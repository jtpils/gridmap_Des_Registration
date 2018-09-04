function [pairInfoSorted] = DespMatch(srcDesp,tarDesp)%,srcSeed,tarSeed,srcNorm,tarNorm,overlap,gridStep
%DESPMATCH �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
params.algorithm = 'kdtree';
params.trees = 8;
params.checks = 64;
% radii = (0.5:0.5:2)*gridStep;
[srcIdx,dist] = flann_search(srcDesp,tarDesp,1,params); % match with descriptors ����ֵ
pairInfo = [srcIdx',(1:size(tarDesp,2))',dist'];
pairInfoSorted = sortrows(pairInfo,3);

end

