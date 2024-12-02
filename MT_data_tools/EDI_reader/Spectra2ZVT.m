function [Z,T,VZ,VT] = Spectra2ZVT(S,if_ref)
%SPECTRA2ZVT 此函数用于将7*7功率谱矩阵转化为功率谱，并计算出阻抗张量，倾子矢量和误差
% S为7*7功率谱矩阵，上三角记录实部，下三角记录虚部 

%% 初始化复数互功率谱矩阵
n = size(S, 1);
S_complex = zeros(n);

%% 构建复数矩阵
for i = 1:n
    for j = i:n
        if i == j
            S_complex(i, j) = S(i, j);  % 对角线是实数
        else
            S_complex(i, j) = 1i * S(i, j);  % 上三角是虚部
            S_complex(j, i) = S(j, i);  % 下三角是实部
        end
    end
end
S_complex = S_complex + S_complex' - diag(diag(S_complex));
 
%% S_complex（i,j）代表ij通道之间的互功率谱，依次为Hx,Hy,Hz,Ex,Ey,Ref_Hx,Ref_Hy
% 提取各个分量的互功率谱
A_chan = 6;
B_chan = 7;
HxA = S_complex(1,A_chan); % Hx与Ref_Hx (A) 的互功率谱
HxB = S_complex(1,B_chan); % Hx与Ref_Hy (B) 的互功率谱

HyA = S_complex(2,A_chan); % Hy与Ref_Hx (A) 的互功率谱
HyB = S_complex(2,B_chan); % Hy与Ref_Hy (B) 的互功率谱

HzA = S_complex(3,A_chan); % Hz与Ref_Hx (A) 的互功率谱
HzB = S_complex(3,B_chan); % Hz与Ref_Hy (B) 的互功率谱

ExA = S_complex(4,A_chan); % Ex与Ref_Hx (A) 的互功率谱
ExB = S_complex(4,B_chan); % Ex与Ref_Hy (B) 的互功率谱

EyA = S_complex(5,A_chan); % Ey与Ref_Hx (A) 的互功率谱
EyB = S_complex(5,B_chan); % Ey与Ref_Hy (B) 的互功率谱

% 计算阻抗张量 Z 的其他分量
Zxx = (ExA*HyB - ExB*HyA) / (HxA*HyB - HxB*HyA);
Zxy = (ExA*HxB - ExB*HxA) / (HyA*HxB - HyB*HxA);
Zyx = (EyA*HyB - EyB*HyA) / (HxA*HyB - HxB*HyA);
Zyy = (EyA*HxB - EyB*HxA) / (HyA*HxB - HyB*HxA);

% 计算倾子 T 的分量
Tzx = (HzA*HyB - HzB*HyA) / (HxA*HyB - HxB*HyA);
Tzy = (HzB*HxA - HzA*HxB) / (HxA*HyB - HxB*HyA);

% 输出结果
Z = [Zxx Zxy; Zyx Zyy];
T = [Tzx Tzy];

%% 误差计算
if if_ref == 1
    VZ = ([ExA ExB;EyA EyB]-Z*[HxA HxB;HyA HyB]) / [HxA HxB;HyA HyB];
    VT = ([HzA HzB] - T*[HxA HxB;HyA HyB]) / [HxA HxB;HyA HyB];
    VZ = abs(VZ).^2;
    VT = abs(VT).^2;
end
end

