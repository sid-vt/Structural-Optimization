function [weight] = FEAtrussSR(FEM, FSDArea, BarAngle)

rho = FEM.Material.density;

for i=1:size(FSDArea,2)
    if size(rho,2)==1
        % Case when rho vector is singular
        w(i) = rho*FSDArea(i)/sind(BarAngle(i));
    else
        % Case when rho vector is provided in the Schmit3bar
        w(i) = rho(i)*FSDArea(i)/sind(BarAngle(i));
    end
end

weight = sum(w)
end