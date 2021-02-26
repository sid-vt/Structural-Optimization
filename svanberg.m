clear;clc;

[f,g] = call_svanberg(0.0624,1.0,[6.01602, 5.30917, 4.49433, 3.50147, 2.15267])

function [f,g] = call_svanberg(C1,C2,x)

f = C1*(x(1) + x(2) + x(3) + x(4) + x(5));
g = C2*(61/x(1)^3 + 37/x(2)^3 + 19/x(3)^3 + 7/x(4)^3 + 1/x(5)^3);

end