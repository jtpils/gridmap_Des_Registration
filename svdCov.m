function [s,n] = svdCov(nnIdx, idx, Data, Seed)
%SVDCOV ��idX�����ӵ���Χ��nnIdx�����Щ�㣬���������������ӣ�
% DataΪ���е��λ����Ϣ��seedΪΪ�������ӵ�λ����Ϣ
nnPt = Data(:,nnIdx); %��Χ����������
C = matrixCompute(nnPt,Seed(:,idx));
[U,S,~] = svd(C);
s = diag(S)/sum(diag(S));   %ʹ����ֵ��Ψһ
n = sign(dot(U(:,2),-Seed(:,idx)))*U(:,2);