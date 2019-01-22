function [srcDesp,srcScale,srcSeed,srcNorm] = exarctEIG2d(srcData,gridStep,specPoint,zoomVar)
% This code is the modified version of source code of Matlab implimentation
% of the paper, -vickylzy
% "Fast Descriptors and Correspondence Propagation for Robust Global Point Cloud Registration,"
% IEEE transactions on Image Processing, 2017.
% This code should be used only for academic research.         
% any other useage of this code should not be allowed without Author agreement.
% If you have any problem or improvement idea about this code, please
% contact with Guang JIANG, Xidian University. gjiang@mail.xidian.edu.cn.


radii = (0.5:0.5:2)*gridStep;
srcSeed=specPoint.Location';
srcData=srcData';
%% compute descriptors for seed points in the source point cloud
K = length(radii);

srcIdx = rangeSearchDiffR(srcData,radii(1),specPoint,zoomVar);
%已改编写为函数rangeSearchDiffR以改进速度srcIdx2=arrayfun(@(a)rangesearch(srcData',[a.Location(1,1),a.Location(1,2)],radii(1)*a.Scale/zoomVar),specPoint,'UniformOutput', true);

%srcIdx = rangesearch(srcData',srcSeed',radii(1));%等长搜查 %寻找seed周radii(1)内的所有点云点
idxSz = cellfun(@length,srcIdx,'uni',true);
srcIdx = srcIdx(idxSz>10);          %选取周遭点超过10个的有代表性兴趣点（好生成描述）
srcSeed = srcSeed(:,idxSz>10);
srcScale = num2cell((specPoint.Scale(idxSz>10))/zoomVar);
specPoint = specPoint(idxSz>10);
M = sum(idxSz>10);
idx = num2cell((1:M)');
[s,n] = cellfun(@(x,y,z)svdCov(x,y,z,srcData,srcSeed),srcIdx,idx,srcScale,'uni',false);
s = cell2mat(s); %每个specialpoint 的特征值 2*n   变成 1*2n
n = cell2mat(n); %每个specialpoint 的第二个特征值的特征向量 2*n 变成 1*2n
for k = 2:K
    srcIdx = rangeSearchDiffR(srcData,radii(k),specPoint,zoomVar);
%  %等长搜查   srcIdx = rangesearch(srcData',srcSeed',radii(k));
    [sk,nk] = cellfun(@(x,y,z)svdCov(x,y,z,srcData,srcSeed),srcIdx,idx,srcScale,'uni',false);
    s = [s cell2mat(sk)];
    n = [n cell2mat(nk)];
end
s = s';
ds = diff(s);
srcDesp = reshape(ds,2*(K-1),[]);    %得到特征值差值后变回来 ，每个点有3组特征值差值，每组差值有两个特征值差 6维
n = mat2cell(n,2*ones(M,1),K);
srcNorm = cellfun(@(x)reshape(x,[],1),n','uni',false);
srcNorm = cell2mat(srcNorm);

end

