function [FSDArea,cnt] = FEAtrussFSD(FEM,nelm,nlc)

Amin = 0.01;
stress_ratio(nelm, nlc) = 0;
tolerence = 10e-6;
tensionVec = FEM.Material.tension;
compressVec = FEM.Material.compress;
cnt = 0;
while true
    cnt = cnt+1;
    A0 = FEM.Area;
    
    % since it is a indeterminate problem, stress should be re-calculated 
    FEAtruss;
    for i = 1:nelm
        if FEM.Area(i) < Amin
            FEM.Area(i) = Amin;
        else
           for j = 1:nlc
                   if size(tensionVec)==1
                       if FEM.stress(i,j)>=0
                           stress_ratio(i,j) = FEM.stress(i,j)/tensionVec;
                       else
                           stress_ratio(i,j) = abs(FEM.stress(i,j)/compressVec);
                       end
                   else
                       if FEM.stress(i,j)>=0
                           stress_ratio(i,j) = FEM.stress(i,j)/tensionVec(i);
                       else
                           stress_ratio(i,j) = abs(FEM.stress(i,j)/compressVec(i));
                       end
                   end
           end
        end
        FEM.Area(i) = max(sqrt(stress_ratio(i,:))*FEM.Area(i));
    end
    A_star = FEM.Area;
    if abs(A_star - A0) < tolerence
        break;
    end
end
FSDArea = A_star;
end