function [point_scale] = detectScale(Model,Data_point,grid_step,max_scale_size)
%DETECTSCALE detect maximum recall scale of given point in Model
%   此处显示详细说明

%% data format
if(size(Model,1)<size(Model,2))
    Model=Model';
end
if(size(Data_point,2)~=size(Model,2))
    Data_point=Data_point';
    if (size(Data_point,2)~=size(Model,2))
        error('Data_point size not match Model !')
    end
end
N=size(Data_point,1);
%% model searcher
kdMdl = KDTreeSearcher(Model);
%% rangesearch
range_result=[];
% detector_step=0.01;
for r=grid_step:grid_step:max_scale_size
    IDx = rangesearch(kdMdl,Data_point,r);
    mid_search_result = cellfun(@length,IDx,'UniformOutput',true);%/(2*r)
    range_result=[range_result,mid_search_result];
end

%% ring point 
diff_scale_N = size(range_result,2)-1;

ring_point_num = diff(range_result')';

ring_area = repmat(grid_step^2+(1:diff_scale_N)*grid_step*2,size(ring_point_num,1),1);
ring_num_noscale = ring_point_num./ring_area;%(1+0.5*(1:length(ring_point_num)));
%% scale peak
index=(1:size(ring_point_num,2))*grid_step;
for i=1:N
    [pks,locs,~,~] =findpeaks(ring_num_noscale(i,:),index,'MinPeakDistance',10,'NPeaks',10,'SortStr','descend');
    %% show peak
%     findpeaks(ring_num_noscale(i,:),index,'MinPeakDistance',10,'NPeaks',10,'SortStr','descend');
%     text(locs+.02,pks,num2str((1:numel(pks))'));
    %% select three highest
    point_scale(i,:) = locs(1:3);
end
end


