function T = eigMatch2D(srcDesp,tarDesp,srcScale,tarScale,srcSeed,tarSeed,srcNorm,tarNorm,overlap,gridStep,srcMap,tarMap,s)
%% parameter configuration for flann search
params.algorithm = 'kdtree';
params.trees = 8;
params.checks = 64;
radii = (0.5:0.5:2)*gridStep;
% srcSeed3d=[srcSeed;zeros(1,size(srcSeed,2))];
% tarSeed3d=[tarSeed;zeros(1,size(tarSeed,2))];
[srcIdx,dist] = flann_search(srcDesp,tarDesp,1,params); % match with descriptors 特征值,找src中tar最近的点
[dist,id]= sort(dist);
%% aggregating each pair of correspondence for finding the best match
M = size(srcSeed,2);    %source种子点数量
N = size(tarSeed,2);    %target种子点数量
seedIdx = srcIdx; 
Err = inf(N,1);
tform = cell(1,N); 
ovNum = ceil(overlap*N);   %可能共有的特征点数目
distThr = 0.2/4*length(radii); 
thetaThr = 10; 
threshold = gridStep*gridStep;
%对每一对匹配进行一次循环，求得一个最优变换
for i = 1:ceil(0.5*N) %对每一对儿  0.2
    n= id(i);
%   for n = 1:N
    seed = srcSeed(:,seedIdx(n));
    seedNorm = srcNorm(:,seedIdx(n));
    seedScale = srcScale(seedIdx(n));
     %%  当前点特征向量与所有其他特殊点的內积
    % source point cloud
    d = bsxfun(@minus,srcSeed,seed);
    d = sqrt(sum(d.^2,1)); % distance of 其他特殊点距离当前特殊点距离
    d = d./(seedScale);%尺度还原
    inProd = bsxfun(@times,srcNorm,seedNorm);    %当前特殊点四个特征向量与其他特征点四个特征向量内积
    inProd = inProd(1:2:end,:) + inProd(2:2:end,:) ;
    theta = real(acosd(inProd));  % inner product

    % target point cloud
    r = bsxfun(@minus,tarSeed,tarSeed(:,n));
    r = sqrt(sum(r.^2,1)); % distance of 其他特殊点距离当前特殊点距离
    r = r./(tarScale(n));
    inProd = bsxfun(@times,tarNorm,tarNorm(:,n));
    inProd = inProd(1:2:end,:) + inProd(2:2:end,:);
    alpha = real(acosd(inProd));  % inner product   
    
%% r,d 分别是当前特殊点与其他各个特殊点欧氏距离，IDX求距离接近的可能的拓展点对儿
    %由于修正 rd为已经平衡过尺度的距离描述
    IDX = rangesearch(r',d',gridStep/2,'distance','cityblock');    %cityblock曼哈顿距离，这里是一维数据可能只是为了加快速度
    
    matches = [seedIdx(n) n];
    for m = [1:seedIdx(n)-1 seedIdx(n)+1:M]     %除了当前点外所有     M为顺序排列的点云
        idx = IDX{m};%find(abs(r-d(m))<gridStep/2);%
        if(isempty(idx))
            continue;
        end
        dTheta = bsxfun(@minus,alpha(:,idx),theta(:,m));
        dTheta = abs(dTheta);
        Tab = dTheta<thetaThr;
        Tab = sum(Tab,1);
        if(all(Tab<size(theta,1)))%只有在每个维度特征向量上都接近的才算扩展点对，但有一个接近点对就继续执行
            continue;
        end
        sim = mean(dTheta,1);
        sim(Tab<size(theta,1)) = inf; %不全接近的都置为无穷
        [minSim,ol] = min(sim);       %每个潜在对应点都有差值
        R = norm(srcDesp(:,m)-tarDesp(:,idx(ol)));%描述子差距大小限制
        if (minSim<thetaThr && R<distThr)
            matches = [matches; m idx(ol)];
        end
    end
    %% 辅助
%     figure;
%     mapPair = joinImage(srcMap,tarMap);
%     imshow(mapPair);
%     xdistance = size(srcMap,2);
%     match_srcSeed = srcSeed(:,matches(:,1));
%     match_tarSeed = tarSeed(:,matches(:,2));
%     showTarSeed = match_tarSeed*s;
%     showTarSeed(1,:)=showTarSeed(1,:)+xdistance;
%     showLineMulti(match_srcSeed',showTarSeed');
%     close all
    %%
    if(size(matches,1)>4)
        match_srcSeed = srcSeed(:,matches(:,1));
        match_tarSeed = tarSeed(:,matches(:,2));
        %% 辅助
%         figure;
%         mapPair = joinImage(srcMap,tarMap);
%         imshow(mapPair);
%         xdistance = size(srcMap,2);
%         showTarSeed = match_tarSeed*s;
%         showTarSeed(1,:)=showTarSeed(1,:)+xdistance;
%         showLineMulti(match_srcSeed'*s,showTarSeed');
%         close 
        %%
        try
            [T2d,inliners,inliners2] = estimateGeometricTransform(match_srcSeed',match_tarSeed','similarity');
        catch
            continue
        end
        T2d = T2d.T';
%         match_srcSeed3d=[match_srcSeed;zeros(1,size(match_srcSeed,2))];
%         match_tarSeed3d=[match_tarSeed;zeros(1,size(match_tarSeed,2))];
%         CS = ransac(double(match_srcSeed3d),double(match_tarSeed3d),threshold);   
        %淘汰不可靠的对儿，然后用可靠对儿去估计运动
%         if(length(inliners)<2)%可靠对儿少于3时不再计算
%             continue;
%         end
        
%         match_srcSeed3d = match_srcSeed3d(:,CS);
%         match_tarSeed3d = match_tarSeed3d(:,CS);
%         [T, Eps] = estimateRigidTransform(match_tarSeed3d, match_srcSeed3d);
%         T2d=[T(1:2,1:2),T(1:2,4); [0 0 1]];
        tarEst = T2d*[srcSeed;ones(1,M)];
        tarEst = tarEst(1:2,:);
        tform{n} = T2d;
        
        [index,dist] = flann_search(tarEst,tarSeed,1,params);
        [dist,ind] = sort(dist);        
        Err(n) = sum(sum((tarEst(:,index(ind(1:ovNum)))-tarSeed(:,ind(1:ovNum))).^2));
        
        if(n==120)
            1==1;
        end
        
    end
    if (size(matches,1)> 0.65*size(srcDesp,2))
        break;
    end
 end
[v,idx] = min(Err);
T = tform{idx};
if(isempty(T))
    error(['match Failed with tarseed:' num2str(length(tarSeed)) ' srcSeed:' num2str(length(srcSeed)) ]);
end
end
