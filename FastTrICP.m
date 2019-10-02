function [s, R, t, TriKSIB, phi] = FastTrICP( Model, Data,s, R, t, MoveStep, TrMin, TrMax)
 
minBPhi= 0;  phi= 10;
CurrStep = 0;
TData = transform_to_global(Data, R, t, s); 
Mns= createns(Model');

while ((CurrStep < MoveStep)&(abs(phi-minBPhi)>10^(-3)))
    
    [corrB,TDB] = knnsearch(Mns,TData');
    
%     [corrB,TDB] = nearest_neighbour(TData, Model, +inf);
    
%     corrB= corrB';
%     TDB= TDB';
    SortTDB2 = sortrows(TDB.^2); % Sort the correspongding points
    minTDBIndex = floor(TrMin*length(TDB)); % Get minimum index of TD
    maxTDBIndex = ceil(TrMax*length(TDB)); % Get maxmum index of TD
    TDBIndex = [minTDBIndex : maxTDBIndex]';
    mTrB = TDBIndex./length(TDB);
    mCumTDB2 = cumsum(SortTDB2); % Get accumulative sum of sorted TD.^2
    mBMSE = mCumTDB2(minTDBIndex : maxTDBIndex)./TDBIndex; % Compute all MSE
    mBPhi = ObjectiveFunction(mBMSE, mTrB);
    [minBPhi, nBIndex] = min(mBPhi);
    TriKSIB = mTrB(nBIndex);% Update Tr for next step
    corrB(:,2) = [1 : length(corrB)]';
    corrTDB = [corrB, TDB];
    SortCorrTDB = sortrows(corrTDB, 3);
    [s, R, t,TCorrB, TData, MSE, phi] = CalRtPhi(TData, SortCorrTDB, TriKSIB,Model,Data);
    % return the MSE and the minimized function value
    CurrStep= CurrStep+1;
end


%%%%%%%%%%%%%%%%%%%%Integrated Function%%%%%%%%%%%%%%%%%%%%
%% Calculate R,t,Phi based on current overlap parameter
function [s, R, t, TCorrB, TData, MSE, phi] = CalRtPhi(TData,SortCorrTDB,TrB,Model,Data)


TrBLength = floor(TrB*size(SortCorrTDB,1)); % The number of corresponding points after trimming
TCorrB = SortCorrTDB(1:TrBLength, 1:2);     % Trim the corresponding points according to overlap parameter Tr
% Register MData with TData
[s, R, t] = reg(TCorrB,Model,Data);
% To obtain the transformation data
TData = transform_to_global(Data, R, t, s);
MSE= sum(sum((Model(:,TCorrB(:,1))-TData(:,TCorrB(:,2))).^2, 2))/(TrBLength);
phi = ObjectiveFunction(MSE, TrB);

%%%%%%%%%%%%%%% Calculate the registration matrix %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% T(TData)->MData %%%%%%%%%%%%%%%%%%%%%%%%%
% SVD solution
function [s1, R1, t1] = reg(corrB,Model,Data)

n = length(corrB); 
M = Model(:,corrB(:,1));
mm = mean(M,2);
S = Data(:,corrB(:,2));
ms = mean(S,2); 
Sshifted = [S(1,:)-ms(1); S(2,:)-ms(2)];
Mshifted = [M(1,:)-mm(1); M(2,:)-mm(2)];
K = Sshifted*Mshifted';
K = K/n;
[U A V] = svd(K);
R1 = V*U';
if det(R1)<0
    B = eye(2);
    B(2,2) = det(V*U');
    R1 = V*B*U';
end
a = sum(sum(Sshifted.*Sshifted));
b = sum(sum((Sshifted'*R1')'.*Mshifted));
s1 = b/a;
t1 = mm - s1*R1*ms;

