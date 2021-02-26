function [stress, L] = truss_stress( d, xyz, E, A )
%  TRUSS_STRESS calculates normal axial stress for a truss element.
%
%--INPUT
%
%  d........ Truss element's nodal displacement matrix 
%            for global degrees of freedom (2 by #coordinates matrix)
%  xyz...... List of coordinates for two nodes in the element
%  E........ Elastic Modulus for this element (scalar)
%  A........ Cross-sectional area of truss element (scalar)
% 
%--OUTPUT
%
%  stress... Truss element axial normal stress (scalar)
%

%% Echo input values
%  Remove this code after unit tests are complete.
% disp(' ')
% disp('truss_stress stub - echo inputs')
% disp(' ')
% disp('nodal displacement matrix, d =')
% disp(d)
% disp('List of coordinates for two nodes in the element, xyz =')
% disp(xyz)
% disp('Elastic Modulus for this element, E =')
% disp(E)
% if nargin>3
%     disp('Cross-sectional area of truss element, A = ')
%     disp(A)
% end

%% Create vector of output stresses set to "Not a Number"
%  Replace this code with proper calculations for stress
nlc = size(d,2);

[npe,ndf]=size(xyz);

x = xyz(:,1); dx = diff(x); dy = 0; dz = 0;
if ndf == 2, y = xyz(:,2); dy = diff(y); end
if ndf == 3, z = xyz(:,3); dz = diff(z); end

L = sqrt( dx^2 + dy^2 + dz^2 ); % Truss element length

switch ndf
case 1
    T=eye(npe,npe);
case 2
   c = dx / L;
   s = dy / L;
   T = [c s 0 0
        0 0 c s];
case 3
   dc = [dx dy dz] / L;
   T  = [dc    0 0 0
         0 0 0 dc   ];
end
if isreal(T) % For aesthetic reasons, zero out nearly zero terms
   nearzero = find(abs(T(:))<100*eps);
   if any(nearzero), T(nearzero)=0; end
end

stress = E*[-1/L 1/L]*T*d;