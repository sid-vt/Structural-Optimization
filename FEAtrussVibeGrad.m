clear;clc;

% Schmit3bar;
TenBar;

% FEAtrussVibe;
TenBarVibe;

[eigvec,~]=eig( M(u,u)\K(u,u) );
D_bar = zeros(FEM.N,size(eigval,1));
D_bar(u,:) = eigvec;

[eigval,idx] = sort(eigval);

for cnt = 1:size(eigval,1)
    i=idx(cnt);
    phi(:,cnt) = D_bar(:,i)/sqrt(D_bar(:,i)'*M*D_bar(:,i));
end

lambda_prime = zeros(nelm, size(eigval,2));

for e = 1:nelm
    
    k_cap_prime = truss(FEM.xyz(FEM.mesh(e,:),:), 1, FEM.Material.E);
    m_cap_prime = truss_mass(FEM.Material.density, 1, FEM.L(e), ndf);
    lv = locvec(FEM.mesh(e,:),ndf);
    phi_cap = phi(lv,:);

    for n = 1:size(eigval,1)
        lambda_prime(e,n) = phi_cap(:,n)'*(k_cap_prime - eigval(n)*m_cap_prime)*phi_cap(:,n);
    end
end

disp('')
disp('Gradient of eigenvalue')
disp(lambda_prime)

