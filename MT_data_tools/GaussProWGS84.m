function [x,y] = GaussProWGS84(Lat,Lon)
% Lat: Latitude(rad) 
% Lon: longitude(rad)
% REF//程鹏飞,成英燕,文汉江,等.2000国家大地坐标系实用宝典[M].
%    //北京:测绘出版社,2008:144-148.
Lat = Lat*pi/180;
Lon = Lon*pi/180;
MedLon = 110*pi/180; %!!!!!!!!中央子午线经度
Eth.R0 = 6378137.0;
Eth.f = 1/298.257223563;
Eth.e12 = 2*Eth.f - Eth.f*Eth.f; % 0.00669437999014132
Eth.e22 = Eth.e12/((1 - Eth.f)*(1 - Eth.f));
%% 高斯投影正算公式
RN = Eth.R0/sqrt(1 - Eth.e12*sin(Lat)*sin(Lat));
Lon = Lon - MedLon;
Lon2 = Lon*Lon;
Lon4 = Lon2*Lon2;
tnLat = tan(Lat);
tn2Lat = tnLat*tnLat;
tn4Lat = tn2Lat*tn2Lat;
csLat = cos(Lat);
cs2Lat = csLat*csLat;
cs4Lat = cs2Lat*cs2Lat;
Eta2 = Eth.e22*cs2Lat;
NTBLP = RN*tnLat*cs2Lat*Lon2;
coe1 = (5 - tn2Lat + 9*Eta2 + 4*Eta2*Eta2)*cs2Lat*Lon2/24;
coe2 = (61 - 58*tn2Lat + tn4Lat)*cs4Lat*Lon4/720;
x = Merdian(Eth,Lat) + NTBLP*(0.5 + coe1 + coe2);
NBLP = RN*csLat*Lon;
coe3 = (1 - tn2Lat + Eta2)*cs2Lat*Lon2/6;
coe4 = (5 - 18*tn2Lat + tn4Lat + 14*Eta2 - 58*tn2Lat*Eta2)*cs4Lat*Lon4/120;
y = NBLP*(1 + coe3 + coe4) + 500000;
end

function X0 = Merdian(Eth,Lat)
% REF//过家春.子午线弧长公式的简化及其泰勒级数解释[J].测绘学报,2014,43(2):125-130.
S0 = Eth.R0*(1 - Eth.e12);
e2 = Eth.e12;
e4 = e2*e2;
e6 = e4*e2;
e8 = e6*e2;
e10 = e8*e2;
e12 = e10*e2;
A1 = 1 + 3*e2/4 + 45*e4/64 + 175*e6/256 + 11025*e8/16384 + 43659*e10/65536 + 693693*e12/1048576;
B1 = 3*e2/8 + 15*e4/32 + 525*e6/1024 + 2205*e8/4096 + 72765*e10/131072 + 297297*e12/524288;
C1 = 15*e4/256 + 105*e6/1024 + 2205*e8/16384 + 10395*e10/65536 + 1486485*e12/8388608;
D1 = 35*e6/3072 + 105*e8/4096 + 10395*e10/262144 + 55055*e12/1048576;
E1 = 315*e8/131072 + 3465*e10/524288 + 99099*e12/8388608;
F1 = 693*e10/1310720 + 9009*e12/5242880;
G1 = 1001*e12/8388608;
X0 = S0*(A1*Lat - B1*sin(2*Lat) + C1*sin(4*Lat) - D1*sin(6*Lat) +...
    E1*sin(8*Lat) - F1*sin(10*Lat) + G1*sin(12*Lat));
end
