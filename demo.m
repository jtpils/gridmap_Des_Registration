clc;clear;close all;
addpath('./flann/');
addpath('./estimateRigidTransform');
s=100;
gridStep=0.2;
overlap=0.1;
icpSteps=300;
TrMin=0.2;
TrMax=1.0;
desNum=400;
%% ת�Ҷ�
map1=rgb2gray(imread('../map_data/pair2/1.png'));
map2=rgb2gray(imread('../map_data/pair2/3.png'));
% map2=imrotate(map2,5);
% imshowpair(map1,map2);
tic;
%% ѡȡ�����   
% 1.ѡȡharris�ǵ���ǿ��200�� 
% 2.���ȷֲ�ѡȡharris�ǵ���ǿ��200��    (current) 
% imshow(map1);hold on;
cornersM1=detectHarrisFeatures(map1);%plot(selectUniform(cornersM1,200,size(map1)));%cornersM1.selectStrongest(200)
seleCorM1=selectUniform(cornersM1,desNum,size(map1));
% plot(seleCorM1);

% figure;
% imshow(map2);hold on;
cornersM2=detectHarrisFeatures(map2);
seleCorM2=selectUniform(cornersM2,desNum,size(map2));
% plot(seleCorM2);

zSeleCorM1=cornerPoints(seleCorM1.Location/s,'Metric',seleCorM1.Metric);
zSeleCorM2=cornerPoints(seleCorM2.Location/s,'Metric',seleCorM2.Metric);
%%  ��ȡ��ά����
[pcMap3d1,pointCMap1]=exarctPCfroImg(map1);
[pcMap3d2,pointCMap2]=exarctPCfroImg(map2);
pointCMap1=pointCMap1/s;
pointCMap2=pointCMap2/s;
% pcMap3d1=pointCloud ( pcMap3d1.Location/s);
% pcMap3d2=pointCloud ( pcMap3d2.Location/s);
figure;
plot(pointCMap1(:,1),pointCMap1(:,2),'.');hold on;
plot(zSeleCorM1);
axis equal
figure;
plot(pointCMap2(:,1),pointCMap2(:,2),'.');hold on;
plot(zSeleCorM2);
axis equal
%%  ��ȡ������

[M1Desp,M1Seed,M1Norm]=exarctEIG2d(pointCMap1,gridStep,zSeleCorM1);
[M2Desp,M2Seed,M2Norm]=exarctEIG2d(pointCMap2,gridStep,zSeleCorM2);
%%  ƥ��
Motion=eigMatch2D(M1Desp,M2Desp,M1Seed,M2Seed,M1Norm,M2Norm,overlap,gridStep);


%% testcode
% close all;
% plot(s*pointCMap1(:,1),s*pointCMap1(:,2),'.');
% hold on 
% plot(s*M1Seed(1,:)',s*M1Seed(2,:)','.','MarkerSize',10 ,'color','red');
%% ��ICP
R0=Motion(1:2,1:2);
t0=Motion(1:2,3);
[R,t]=fastTrICP2D(pointCMap2',pointCMap1',R0,t0,TrMin,TrMax,icpSteps);
opMotion=[R,t;0 0 1];
toc
figure;
obtain2d(pointCMap2,'.');hold on;
transMap=opMotion*[pointCMap1';ones(1,length(pointCMap1))];
obtain2d(transMap,'.k');

obtain2d(zSeleCorM2.Location,'+r');
transFeaPoint=opMotion*[zSeleCorM1.Location';ones(1,length(zSeleCorM1.Location))];
obtain2d(transFeaPoint,'xm');
%%

to=t*s;


% reset to original scale

% merging_fixed(map2,map1,pointCMap1,R,to);
%% inverse show merge
motion_inv = inv([[R,to];[0,0,1]]);
R1 = motion_inv(1:2,1:2);
t1 = motion_inv(1:2,3);
merging_fixed(map1,map2,pointCMap2,R1,t1);

