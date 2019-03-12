clc;clear;close all;
load dataBestMatch2d.mat
map2=rgb2gray(imread('Fr1_5.png','png'));
map1=rgb2gray(imread('Fr2_5.png','png'));
[pcMap3d1,pointCMap1]=exarctPCfroImg(map1);
[pcMap3d2,pointCMap2]=exarctPCfroImg(map2);
s=100;
% match_srcSeed3d
% match_tarSeed3d
mapPair = joinImage(map1,map2);
figure('Position', [100 100 size(mapPair,2) size(mapPair,1)]);
imshow(mapPair);
axis on
hold on
%差距map2
xdistance = size(map1,2);
% close all
%% show map2 feature
shownum=8;
x2=xdistance + s*match_srcSeed3d(1,1:shownum)';
y2=s*match_srcSeed3d(2,1:shownum)';
plot(x2,y2,'.','Marker','*','MarkerSize',9);
plot(x2(1),y2(1),'.','Marker','o','MarkerSize',6,'MarkerFaceColor','r');
%% map2 inner line
for i=2:shownum
    line([x2(1),x2(i)],[y2(1),y2(i)],'Color','m','LineStyle','--');
end

%% show map1 feature
shownum=8;
x1=s*match_tarSeed3d(1,1:shownum)';
y1=s*match_tarSeed3d(2,1:shownum)';
plot(x1,y1,'.','Marker','*','MarkerSize',9);
plot(x1(1),y1(1),'.','Marker','o','MarkerSize',6,'MarkerFaceColor','r');
%% map1 inner line
for i=2:shownum
    line([x1(1),x1(i)],[y1(1),y1(i)],'Color','m','LineStyle','--');
end

%% cross line
line([x1(1),x2(1)],[y1(1),y2(1)],'Color','b','LineStyle',':','LineWidth',1.5);

%% show all selected point
showPoint(s*tarSeed)
spointMap2 = s*srcSeed;
spointMap2(1,:) = spointMap2(1,:)+xdistance;
showPoint(spointMap2);

%% 多尺度描述子说明
currPointN = randi([0 size(tarSeed,2)],1,1) ;
currPointN = 90
point = tarSeed(:,currPointN)';
% for r=[0.5 1 1.5 2]*gridStep
%     r=r*s;
%     rectangle('Position',[point(1)*s-r,point(2)*s-r,2*r,2*r],'Curvature',[1,1],'LineWidth',1.5);
%     
%     % rectangle(axes2,'Position',[M2point(1)-r,M2point(2)-r,2*r,2*r],'Curvature',[1,1]);
%     % plot(axesUp,M1point(1),M1point(2),'x');
%     % plot(axesUp,M1point(1),M1point(2)+0.3,'x');
%     % plot(axesDown,M2point(1),M2point(2),'x');
%     % plot(axesDown,M2point(1),M2point(2)+0.3,'x');
% end

% 
% plot(pointCMap1(:,1),pointCMap1(:,2),'.','MarkerSize',18);
% plot(pointCMap2(:,1)+xdistance,pointCMap2(:,2),'.','MarkerSize',9);
% plot(point(1)*s,point(2)*s,'.r','MarkerSize',26);