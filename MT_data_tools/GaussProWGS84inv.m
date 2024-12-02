function [B,L] = GaussProWGS84invInversion(x,y)
% Format: x(North Position), y(East Position)
%         B: latitude (deg) & L: longitude (deg) 
y = y - 500000;
L0 = 110*pi/180; % !!!!!!!!!central meridian deg
%% Parameters of WGS84
a = 6378137;     f = 1/298.257223563;
b = a - a*f;     var = sqrt(a^2 - b^2);   
e = var/a;       e2 = var/b;
Bf = Meridian2Latitude(x,a,e);
w = sqrt(1 - e*sin(Bf)*e*sin(Bf));
Nf = a/w;        Mf = a*(1-e^2)/w^3;
nf = e2*cos(Bf); tf = tan(Bf);
clear a f e e2 var w;
%% Calculate Latitude(B)
n2 = tf/(2*Mf*Nf);         n4 = tf/(24*Mf*Nf^3);
n6 = tf/(720*Mf*Nf^5);     b1 = 5 + 3*tf^2 + nf^2 -9*nf^2*tf^2;
b2  = 61 + 90*tf*tf + 45*tf*tf*tf*tf;
B = Bf - n2*y^2 + n4*b1*y^4 - n6*b2*y^6;
clear n2 n4 n6 b1 b2;
%% Calculate Longitude(L)
n1 = 1/(Nf*cos(Bf));       n3 = 1/(6*Nf^3*cos(Bf));
n5 = 1/(120*Nf^5*cos(Bf)); l1 = 1 + 2*tf^2 + nf^2;
l2 = 5 + 28*tf^2 + 24*tf^4 + 6*nf^2 + 8*nf^2*tf^2;
L = L0 + n1*y - n3*l1*y^3 + n5*l2*y^5;
clear n1 n3 n5 l1 l2;
B = B*180/pi;       L = L*180/pi;
end

function Bf = Meridian2Latitude(x,a,e)
m0 = a*(1 - e^2);    m2 = 3*e^2*m0/2;
m4 = 5*e^2*m2/4;     m6 = 7*e^2*m4/6;
m8 = 9*e^2*m6/8;     a8 = m8/128;
a6 = m6/32 + m8/16;  a4 = m4/8 + 3*m6/16 + 7*m8/32;
a0 = m0 + m2/2 + 3*m4/8 + 5*m6/16 + 35*m8/128;
a2 = m2/2 + m4/2 + 15*m6/32 + 7*m8/16;
B0 = x/a0;
while 1
    F = -a2*sin(2*B0)/2 + a4*sin(4*B0)/4 - a6*sin(6*B0)/6 + a8*sin(8*B0)/8;
    Bf = (x - F)/a0;
    if abs(B0 - Bf)<1E-9
        break;
    end
    B0 = Bf;
end
end
