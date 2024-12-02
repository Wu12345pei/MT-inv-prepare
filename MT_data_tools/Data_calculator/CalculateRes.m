function [Residual_by_period,station_loc] = CalculateRes(data_filename,res_filename)
%CALCULATERes 此文件计算
%   此处显示详细说明
data_cell = readZ_3D_deprecatedforchar(data_filename);
res_cell = readZ_3D_deprecatedforchar(res_filename);

for i = 1:size(data_cell,2)
    data_ZT = data_cell{i}.Z;
    res_ZT = res_cell{i}.Z;
    station_loc = data_cell{i}.siteLoc;
    relative_res = abs(res_ZT)./abs(data_ZT);
    Residual_by_period{i} = relative_res;
end
end

