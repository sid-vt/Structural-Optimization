% function [Kp, Dp, stress_prime] = direct_method(FEM, nelm, ndf, ngrid)
%%
clc;clear;
Schmit3bar;
% TenBar;
CaseElement = 1;

%%
Dp = zeros([size(FEM.D),nelm]);
for e=1:nelm
    kp = truss( FEM.xyz(FEM.mesh(e,:),:), 1.0, FEM.Material.E );
    Kp = Kinit( ngrid, ndf, FEM.mesh );
    Kp = assemble( kp, Kp, FEM.mesh(e,:) );
    P = Kp(u,u)*FEM.D(u,:);
    Dp(u,:,e) = -K(u,u) \ P;
end

%%
switch CaseElement
    case 1
        for e=1:nelm  
            lv = locvec(FEM.mesh(CaseElement,:),ndf);
            stress_prime(e,:) = truss_stress( Dp(lv,:,e), FEM.xyz(FEM.mesh(CaseElement,:),:), FEM.Material.E );
        end
    case 2
        for e=1:nelm         
            lv = locvec(FEM.mesh(CaseElement,:),ndf);
            stress_prime(e,:) = truss_stress( Dp(lv,:,e), FEM.xyz(FEM.mesh(CaseElement,:),:), FEM.Material.E );
        end
    case 3
        for e=1:nelm         
            lv = locvec(FEM.mesh(CaseElement,:),ndf);
            stress_prime(e,:) = truss_stress( Dp(lv,:,e), FEM.xyz(FEM.mesh(CaseElement,:),:), FEM.Material.E );
        end
        
    case 4
        for e=1:nelm  
            lv = locvec(FEM.mesh(CaseElement,:),ndf);
            stress_prime(e,:) = truss_stress( Dp(lv,:,e), FEM.xyz(FEM.mesh(CaseElement,:),:), FEM.Material.E );
        end
    case 5
        for e=1:nelm         
            lv = locvec(FEM.mesh(CaseElement,:),ndf);
            stress_prime(e,:) = truss_stress( Dp(lv,:,e), FEM.xyz(FEM.mesh(CaseElement,:),:), FEM.Material.E );
        end
    case 6
        for e=1:nelm         
            lv = locvec(FEM.mesh(CaseElement,:),ndf);
            stress_prime(e,:) = truss_stress( Dp(lv,:,e), FEM.xyz(FEM.mesh(CaseElement,:),:), FEM.Material.E );
        end
        
    case 7
        for e=1:nelm  
            lv = locvec(FEM.mesh(CaseElement,:),ndf);
            stress_prime(e,:) = truss_stress( Dp(lv,:,e), FEM.xyz(FEM.mesh(CaseElement,:),:), FEM.Material.E );
        end
        
    case 8
        for e=1:nelm         
            lv = locvec(FEM.mesh(CaseElement,:),ndf);
            stress_prime(e,:) = truss_stress( Dp(lv,:,e), FEM.xyz(FEM.mesh(CaseElement,:),:), FEM.Material.E );
        end
        
    case 9
        for e=1:nelm  
            lv = locvec(FEM.mesh(CaseElement,:),ndf);
            stress_prime(e,:) = truss_stress( Dp(lv,:,e), FEM.xyz(FEM.mesh(CaseElement,:),:), FEM.Material.E );
        end
        
    case 10
        for e=1:nelm         
            lv = locvec(FEM.mesh(CaseElement,:),ndf);
            stress_prime(e,:) = truss_stress( Dp(lv,:,e), FEM.xyz(FEM.mesh(CaseElement,:),:), FEM.Material.E );
        end
end
%%
disp(' ')
disp(['Displacement derivative for element Area 1,2,3'])
% disp(['Displacement derivative for element Area 1,2,3,4,5,6,7,8,9,10'])
Dp
disp(' ')
disp(['Stress derivative for element ', num2str(CaseElement),' w.r.t element 1,2,3'])
% disp(['Stress derivative for element ', num2str(CaseElement),' w.r.t element 1,2,3,4,5,6,7,8,9,10'])
stress_prime