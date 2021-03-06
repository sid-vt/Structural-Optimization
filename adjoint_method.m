clear;clc;

Schmit3bar;
CaseElement = 1;
dof_nc = size(find(FEM.D(:,1)),1);
% Dp = zeros([size(FEM.D),nelm]);
for i=1:size(u,2)
    zd = zeros(FEM.N,1);
    zd(u(i)) = 1;
    lambda = -K(u,u) \ zd(u);

    for e=1:nelm
        kp = truss( FEM.xyz(FEM.mesh(e,:),:), 1.0, FEM.Material.E );
        Kp = Kinit( ngrid, ndf, FEM.mesh );
        Kp = assemble( kp, Kp, FEM.mesh(e,:) );
        P = Kp(u,u)*FEM.D(u,:);
        Dp(u,:) = P*lambda;
    end
end

%%
for i=1:nelm
    xyz = FEM.xyz(FEM.mesh(i,:),:);
    L = sqrt(sum((xyz(2,:) - xyz(1,:)).^2));
    direcosine = (xyz(2,:) - xyz(1,:))/L;
    T = [direcosine, 0*direcosine; 0*direcosine, direcosine];
    B = [-1/L 1/L];
    
    lv = locvec(FEM.mesh(CaseElement,:),ndf);
    zs = zeros(FEM.N,1);
    zs(lv) = FEM.Material.E*B*T;
    lambda_s = -K( u,u ) \ zs(u);

    for e=1:nelm
        kp = truss( FEM.xyz(FEM.mesh(e,:),:), 1.0, FEM.Material.E );
        Kp = Kinit( ngrid, ndf, FEM.mesh );
        Kp = assemble( kp, Kp, FEM.mesh(e,:) );
        P = Kp(u,u)*FEM.D(u,:);
        Dp(u,:,e) = P*lambda_s;
    end

end






