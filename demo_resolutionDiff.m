clc;clear;close all;
addpath('./flann/');
addpath('./estimateRigidTransform');
s=100;
gridStep=0.3;
overlap=0.2;
%% ת�Ҷ�
map1=rgb2gray(imread('Fr1_5.png','png'));
map2=rgb2gray(imread('Fr2_5.png','png'));
proportionDetect(map1,map2,gridStep,overlap);




% tic;
% %% ѡȡ�����   
% % 1.ѡȡharris�ǵ���ǿ��200�� 
% % 2.���ȷֲ�ѡȡharris�ǵ���ǿ��200��    (current) 
% cornersM1=detectHarrisFeatures(map1);
% seleCorM1=selectUniform(cornersM1,300,size(map1));
% 
% 
% % figure;
% % imshow(map2);hold on;
% cornersM2=detectHarrisFeatures(map2);
% seleCorM2=selectUniform(cornersM2,300,size(map2));
% 
% 
% zSeleCorM1=cornerPoints(seleCorM1.Location/s,'Metric',seleCorM1.Metric);
% zSeleCorM2=cornerPoints(seleCorM2.Location/s,'Metric',seleCorM2.Metric);
% %%  ��ȡ��ά����
% [pcMap3d1,pointCMap1]=exarctPCfroImg(map1);
% [pcMap3d2,pointCMap2]=exarctPCfroImg(map2);
% pointCMap1=pointCMap1/s;
% pointCMap2=pointCMap2/s;
% pcMap3d1=pointCloud ( pcMap3d1.Location/s);
% pcMap3d2=pointCloud ( pcMap3d2.Location/s);
% figure;
% plot(pointCMap1(:,1),pointCMap1(:,2),'.');hold on;
% plot(zSeleCorM1);
% axis equal
% figure;
% plot(pointCMap2(:,1),pointCMap2(:,2),'.');hold on;
% plot(zSeleCorM2);
% axis equal
% %%  ��ȡ������
% 
% [M1Desp,M1Seed,M1Norm]=exarctEIG2d(pointCMap1,gridStep,zSeleCorM1);
% [M2Desp,M2Seed,M2Norm]=exarctEIG2d(pointCMap2,gridStep,zSeleCorM2);
% %%  ƥ��
% Motion=eigMatch2D(M1Desp,M2Desp,M1Seed,M2Seed,M1Norm,M2Norm,overlap,gridStep);
% toc
% figure;
% obtain2d(pointCMap2,'.');hold on;
% transMap=Motion*[pointCMap1';ones(1,length(pointCMap1))];
% obtain2d(transMap,'.');

