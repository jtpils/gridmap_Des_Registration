function T = eigMatch2D(srcDesp,tarDesp,srcSeed,tarSeed,srcNorm,tarNorm,overlap,gridStep)
%% parameter configuration for flann search
params.algorithm = 'kdtree';
params.trees = 8;
params.checks = 64;
radii = (0.5:0.5:2)*gridStep;
% srcSeed3d=[srcSeed;zeros(1,size(srcSeed,2))];
% tarSeed3d=[tarSeed;zeros(1,size(tarSeed,2))];
[srcIdx,dist] = flann_search(srcDesp,tarDesp,1,params); % match with descriptors ����ֵ
[dist,id]= sort(dist);
%% aggregating each pair of correspondence for finding the best match
M = size(srcSeed,2);    %���ӵ�����
N = size(tarSeed,2);    %���ӵ�����
seedIdx = srcIdx; 
Err = inf(N,1);
tform = cell(1,N); 
ovNum = ceil(overlap*N);   %���ܹ��е���������Ŀ
distThr = 0.2/4*length(radii); 
thetaThr = 10; 
threshold = gridStep*gridStep;
%��ÿһ��ƥ�����һ��ѭ�������һ�����ű任
for i = 1:ceil(0.2*N)
    n= id(i);
%   for n = 1:N
    seed = srcSeed(:,seedIdx(n));
    seedNorm = srcNorm(:,seedIdx(n));
     %%  ��ǰ�������������������������ăȻ�
    % source point cloud
    d = bsxfun(@minus,srcSeed,seed);
    d = sqrt(sum(d.^2,1)); % distance of �����������뵱ǰ��������
    inProd = bsxfun(@times,srcNorm,seedNorm);    %��ǰ������ĸ����������������������ĸ����������ڻ�
    inProd = inProd(1:2:end,:) + inProd(2:2:end,:) ;
    theta = real(acosd(inProd));  % inner product

    % target point cloud
    r = bsxfun(@minus,tarSeed,tarSeed(:,n));
    r = sqrt(sum(r.^2,1)); % distance
    inProd = bsxfun(@times,tarNorm,tarNorm(:,n));
    inProd = inProd(1:2:end,:) + inProd(2:2:end,:);
    alpha = real(acosd(inProd));  % inner product   

    IDX = rangesearch(r',d',gridStep/2,'distance','cityblock');
    
    matches = [seedIdx(n) n];
    for m = [1:seedIdx(n)-1 seedIdx(n)+1:M]        
        idx = IDX{m};%find(abs(r-d(m))<gridStep/2);%
        if(isempty(idx))
            continue;
        end
        dTheta = bsxfun(@minus,alpha(:,idx),theta(:,m));
        dTheta = abs(dTheta);
        Tab = dTheta<thetaThr;
        Tab = sum(Tab,1);
        if(all(Tab<size(theta,1)))
            continue;
        end
        sim = mean(dTheta,1);
        sim(Tab<size(theta,1)) = inf;
        [minSim,ol] = min(sim);
        R = norm(srcDesp(:,m)-tarDesp(:,idx(ol)));
        if(minSim<thetaThr && R<distThr)
            matches = [matches; m idx(ol)];
        end
    end
    if(size(matches,1)>10)
        match_srcSeed = srcSeed(:,matches(:,1));
        match_tarSeed = tarSeed(:,matches(:,2));
        match_srcSeed3d=[match_srcSeed;zeros(1,size(match_srcSeed,2))];
        match_tarSeed3d=[match_tarSeed;zeros(1,size(match_tarSeed,2))];
        CS = ransac(double(match_srcSeed3d),double(match_tarSeed3d),threshold);   
        %��̭���ɿ��ĶԶ���Ȼ���ÿɿ��Զ�ȥ�����˶�
        if(sum(CS)<3)
            continue;
        end
        
        match_srcSeed3d = match_srcSeed3d(:,CS);
        match_tarSeed3d = match_tarSeed3d(:,CS);
        [T, Eps] = estimateRigidTransform(match_tarSeed3d, match_srcSeed3d);
        T2d=[T(1:2,1:2),T(1:2,4); [0 0 1]];
        tarEst = T2d*[srcSeed;ones(1,M)];
        tarEst = tarEst(1:2,:);
        tform{n} = T2d;
        
        [index,dist] = flann_search(tarEst,tarSeed,1,params);
        [dist,ind] = sort(dist);        
        Err(n) = sum(sum((tarEst(:,index(ind(1:ovNum)))-tarSeed(:,ind(1:ovNum))).^2));
    end
    if (size(matches,1)> 0.65*size(srcDesp,2))
        break;
    end
 end
[v,idx] = min(Err);
T = tform{idx};
% if(isempty(T))
%     disp(['match Failed with tarseed:' num2str(length(tarSeed)) ' srcSeed:' num2str(length(srcSeed)) ]);
% end
end
