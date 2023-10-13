clear all; clc;

syms f(x,y,z)

x0 = [1,1];

[x, err] = GDN(@test1, x0, 1)

x0 = [1,0];
[x, err] = GDN(@test2, x0, 1, 1e-20, 20, 5, 2)

function out = test1(vec)
    out = vec(1)^2+vec(2)^2; % sol : f[0,0]=0
end

function out = test2(vec)
    % Goldstein–Price function - sol : f[0,-1]=3
    x = vec(1);
    y = vec(2);
    out = (1+(x+y+1)^2*(19-14*x+3*x^2-14*y+6*x*y+3*y^2))*...
            (30+(2*x-3*y)^2*(18-32*x+12*x^2+48*y-36*x*y+27*y^2));
end