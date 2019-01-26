function [matchedPts1, matchedPts2]=SURFFeat(I1,I2)
% Get the Key Points
    Options.upright=true;
    Options.tresh=0.0001;
    disp('Finding SURF points on image 1:');
    tic();
    Ipts1=OpenSurf(I1,Options);
    toc();
    disp('Finding SURF points on image 2:');
    tic();
    Ipts2=OpenSurf(I2,Options);
    toc();
    % Put the landmark descriptors in a matrix.
    disp('matching:');
    tic();
    D1 = reshape([Ipts1.descriptor],64,[]); 
    D2 = reshape([Ipts2.descriptor],64,[]); 
    % Find the best matches
    err=zeros(1,length(Ipts1));
    cor1=1:length(Ipts1); 
    cor2=zeros(1,length(Ipts1));
    for i=1:length(Ipts1),
      distance=sum((D2-repmat(D1(:,i),[1 length(Ipts2)])).^2,1);
      [err(i),cor2(i)]=min(distance);
    end
    % Sort matches on vector distance
    [err, ind]=sort(err); 
    cor1=cor1(ind); 
    cor2=cor2(ind);
    toc();
    
    UsePointCount = 200;
    if length(cor1) < UsePointCount
        error('too little features to match');
    end
    
    % Show the best matches
    matchedPts1=zeros(UsePointCount,2);
    matchedPts2=zeros(UsePointCount,2);
    figure('name','matching');
    subH1=subplot(1,2,1); imshow(I1);
    subH2=subplot(1,2,2); imshow(I2);
    txt=sprintf('matched points: %d, Using the top %d matches',length(cor1), UsePointCount);
    text(.1,.5,txt);
    for i=1:UsePointCount
      c=rand(1,3);
      
      h=impoint(subH1, Ipts1(cor1(i)).x, Ipts1(cor1(i)).y); setColor(h,c);
      h=impoint(subH2, Ipts2(cor2(i)).x, Ipts2(cor2(i)).y); setColor(h,c);
      
      matchedPts1(i,1) = Ipts1(cor1(i)).x;
      matchedPts1(i,2) = Ipts1(cor1(i)).y;
      matchedPts2(i,1) = Ipts2(cor2(i)).x;
      matchedPts2(i,2) = Ipts2(cor2(i)).y;
    end
end