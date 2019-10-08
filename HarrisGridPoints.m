classdef HarrisGridPoints
    %UNTITLED2 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties (SetAccess = public)
        Location;
        ScaleRadius;
        N;
        scale_step_num;
    end
    
    methods
        
        function obj = HarrisGridPoints(in_Location,in_ScaleRadius)
            %HarrisGridPoints 构造此类的实例
            %   此处显示详细说明
            %% check input
            if((size(in_Location,1)~=size(in_ScaleRadius,1)) || size(in_Location,2)~=2 )
                error("check input size");
            end
            %% init
            obj.scale_step_num=size(in_ScaleRadius,2);
            obj.Location = repmat(in_Location,obj.scale_step_num,1);
            scales_stack=[];
            for i=1:obj.scale_step_num
                scales_stack=[scales_stack;in_ScaleRadius(:,i)];
            end
            obj.ScaleRadius = scales_stack;
            obj.N = size(scales_stack,1);
        end
       
    end
end

