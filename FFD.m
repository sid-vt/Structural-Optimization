%  FFD: Forward Finite Difference, a subroutine to compute nodal
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
function [duVec, err] = FFD(FEM, D, h)
loadCond = 1;   %given in question
uDirec = 1;     %given in question
uNode = 4;      %given in question

% 
% res(Area1, Area2)
res = [-21.048655683119794, 5.002248968506029];%given in question

FEM.Area0 = FEM.Area;
uold = D(:,:,loadCond);

% For loop to iterate for new area
for i=1:size(h,2)
    FEM.Area = FEM.Area0 + [0 h(i) 0];
    FEAtruss;
    unew = D(:,:,loadCond);
    du(:,:,i) = (unew - uold)/h(i);
end
du
duVec = reshape(du(uDirec,uNode,:),[i,1]);
err = abs((res(2) - duVec)./duVec);

%% Plots
figure(2)
plot(h,duVec)
grid on
title('$\frac{du}{dx}$ vs step size','Interpreter','latex')
xlabel('step size') 
ylabel('$\frac{du}{dx}$','Interpreter','latex')


figure(3)
loglog(h,err)
grid on
title('log(relative_error) vs log(step size)')
xlabel('log(step size)') 
ylabel('log(relative_error)')

end