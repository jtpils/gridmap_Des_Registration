function [s,n] = svdCov(nnIdx, idx,zscale, Data, Seed)
%SVDCOV 第idX号种子点周围有nnIdx里的这些点，用他们来描述种子，
% Data为所有点的位置信息，seed为为所有种子点位置信息
nnPt = Data(:,nnIdx); %周围描述点坐标
C = matrixCompute(nnPt,Seed(:,idx),zscale);
[U,S,~] = svd(C);
s = diag(S)/sum(diag(S));   %使特征值和唯一
n = sign(dot(U(:,2),-Seed(:,idx)))*U(:,2);