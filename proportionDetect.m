function resolutionVerse = proportionDetect(grayMap1,grayMap2,gridStep,overlap,s)
%�Ҷ�ͼΪ����
%% ѡȡ�����   
% 1.ѡȡharris�ǵ���ǿ��200�� 
% 2.���ȷֲ�ѡȡharris�ǵ���ǿ��200��    (current) 
cornersM1=detectHarrisFeatures(grayMap1);%plot(selectUniform(cornersM1,200,size(map1)));%cornersM1.selectStrongest(200)
seleCorM1=selectUniform(cornersM1,300,size(grayMap1));
cornersM2=detectHarrisFeatures(grayMap2);
seleCorM2=selectUniform(cornersM2,300,size(grayMap2));

%% 
zSeleCorM1=cornerPoints(seleCorM1.Location/s,'Metric',seleCorM1.Metric);
zSeleCorM2=cornerPoints(seleCorM2.Location/s,'Metric',seleCorM2.Metric);

%% ȡΪ����
[pcMap3d1,pointCMap1]=exarctPCfroImg(grayMap1);
[pcMap3d2,pointCMap2]=exarctPCfroImg(grayMap2);
pointCMap1=pointCMap1/s;
pointCMap2=pointCMap2/s;
pcMap3d1=pointCloud ( pcMap3d1.Location/s);
pcMap3d2=pointCloud ( pcMap3d2.Location/s);
fig=figure('Position',[1000 300 500 600]);
axesUp=subplot(2,1,1);
title('Map 1')
plot(axesUp,pointCMap1(:,1),pointCMap1(:,2),'.');hold on;
plot(zSeleCorM1);
axis equal
axesDown=subplot(2,1,2);
title('Map 2')
plot(axesDown,pointCMap2(:,1),pointCMap2(:,2),'.');hold on;
plot(zSeleCorM2);
axis equal
%%  ��ȡ������

[M1Desp,M1Seed,M1Norm]=exarctEIG2d(pointCMap1,gridStep,zSeleCorM1);
[M2Desp,M2Seed,M2Norm]=exarctEIG2d(pointCMap2,gridStep,zSeleCorM2);

%%  ��ȡ������ƥ��
pairInfo=DespMatch(M2Desp,M1Desp);
M2point=M2Seed(:,pairInfo(1,1))';
plot(axesDown,M2point(1),M2point(2),'o');hold on;
plot(axesUp,M1point(1,1),M1point(2,1),'o');
end