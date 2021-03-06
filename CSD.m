%  CSD: Complex Step Derivative, a subroutine to compute nodal
%  displacment derivatives w.r.t element cross-sectional areas.
% 
% -- Definitions
%     loadCond.... Loading Condition for particular caseInput
%     uNode....... Node number for nodal displacement
% 
% -- INPUT
%     FEM......... Finite Element Model structure
%     D........... Nodal Displacement 3D array, D(#elem, #node, #LoadCond)
%     h........... step size
% 
% -- OUTPUT
%     err......... relative error
%     duVec....... Computing U or V
%     res..........Analytical results for relative comparison
%
% function [duVec_csd, err_u] = CSD(FEM, D, h)

direct_method;
loadCond = 1;   %given in question
uDirec = 1;     %given in question
uNode = 4;      %given in question
% h = linspace(0.005,0.000001,200);
h=10^-15;

if uDirec == 1
    Dp_uindex = 7;
else 
    Dp_uindex = 8;
end

% res(Area1, Area2)
res_Dp = zeros(nelm,1);
res_Dp(:) = Dp(Dp_uindex,loadCond,:);
res_stress_prime = stress_prime(:,loadCond);

FEM.Area0 = FEM.Area;
uold = D(:,:,loadCond);

% For loop to iterate for new area
switch CaseElement
    case 1
        for i=1:size(h,2)
            FEM.Area = FEM.Area0 + [h(i)*1i 0 0];
            FEAtruss;
            unew = D(:,:,loadCond);
            du(:,:,i) = imag((unew + uold))/h(i);
        end

    case 2
        for i=1:size(h,2)
            FEM.Area = FEM.Area0 + [0 h(i)*1i 0];
            FEAtruss;
            unew = D(:,:,loadCond);
            du(:,:,i) = imag((unew + uold))/h(i);
        end

    case 3
        for i=1:size(h,2)
            FEM.Area = FEM.Area0 + [0 0 h(i)*1i];
            FEAtruss;
            unew = D(:,:,loadCond);
            du(:,:,i) = imag((unew + uold))/h(i);
        end
end
duVec_csd = reshape(du(uDirec,uNode,:),[i,1]);
err_u = abs((res_Dp(CaseElement) - duVec_csd)./duVec_csd);
err_sigma = abs((res_stress_prime(2) - duVec_csd)./duVec_csd);

figure(2)
plot(h,duVec_csd)
grid on
title('$\frac{du}{dx}$ vs step size','Interpreter','latex')
xlabel('step size') 
ylabel('$\frac{du}{dx}$','Interpreter','latex')


figure(3)
loglog(h,err_u)
grid on
title('log(relative_error) vs log(step size)')
xlabel('log(step size)') 
ylabel('log(relative_error)')

% end