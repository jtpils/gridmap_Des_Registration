clc;clear;close all;
set_times=(1:0.1:6);
run('D:\matlab2019\vlfeat-0.9.21\toolbox\vl_setup.m')
addpath('./flann/');
addpath('./keypointExtraction/');
% addpath('./estimateRigidTransform');
s=100;
gridStep=0.15;
overlap=0.2;
icpSteps=100;
TrMin=0.2;
TrMax=0.8;
%尺度平衡子（让待配准的两幅图比例保持又不过多影响gridstep）
zoomVar=1;
downStep=0.08;
% ori_map1=rgb2gray(imread('..\map_data\pair5\loop6_1.png'));
% ori_map2=rgb2gray(imread('..\map_data\pair5\loop10_1.png'));
ori_map1  =imread('..\map_data\pair5\loop6_1_zoom.png');
ori_map2  =imread('..\map_data\pair5\loop10_1.png');
datasheet_report(1,:)=set_times;
iter=1;
for i=set_times


    resize_times=i;
    run("demo_resolutionDiff.m");
    datasheet_report(2,iter)= abs(scaleC-i);
    
    disp([num2str(i),': ',num2str(abs(scaleC-i))]);
    iter=iter+1;
end


x=datasheet_report(1,:);
y=datasheet_report(2,:);
figure;
handler_c = plot(x,y);

datasheet_report_loop5 = datasheet_report;

%% plot multi line

load('./result_scale/fr_scale.mat')
load('./result_scale/intel_scale.mat')
load('./result_scale/loop5_scale.mat')
figure;
hold on;
lineWid = 1;
line_handler_fr = plot(datasheet_report_fr(1,:),datasheet_report_fr(2,:));
line_handler_intel = plot(datasheet_report_intel(1,:),datasheet_report_intel(2,:));
line_handler_loop5 = plot(datasheet_report_loop5(1,:),datasheet_report_loop5(2,:));
line_handler_fr.LineStyle='--';
line_handler_intel.LineStyle='-';
line_handler_loop5.LineStyle='-.';
line_handler_fr.LineWidth=lineWid;
line_handler_intel.LineWidth=lineWid-0.3;
line_handler_loop5.LineWidth=lineWid+0.2;
grid on;
currAxis=gca;
currAxis.XTick=[1:0.5:6];
currAxis.YTick=[-1:1:4];
currAxis.XTickLabel
axis([1,6,-0.5,4]);
xlabel('{\fontsize{12}Scal{e_P} : Scal{e_Q}}')    ;
ylabel('{\fontsize{12}\DeltaScale}')    ;
legend({'Fr079','Intel/2','Loop5'},'Location','northwest')