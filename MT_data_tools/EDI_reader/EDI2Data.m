function [data_cell] = EDI2Data(file)
%EDI2DATA 此函数将EDI文件读取并转化成可以用于后续工作的data数据格式

%% the format of data cell
% sitename,X,Y,Z,period,Zxx,Zxy,Zyx,Zyy,Tzx,Tzy,Var_Zxx,Var_Zxy,Var_Zyx,Var_Zyy,Var_Tzx,Var_Tzy
threshold_Var = 0.05;
[data]=EDIreader(file);
Z_list = cell(size(data.spectra,1),1);
VarZ_list = cell(size(data.spectra,1),1);
T_list = cell(size(data.spectra,1),1);
VarT_list = cell(size(data.spectra,1),1);


for i = 1:length(Z_list)
    [Z,T,VarZ,VarT] = Spectra2ZVT(data.spectra{i},1);
    Zxx(i) = Z(1,1);
    Zxy(i) = Z(1,2);
    Zyx(i) = Z(2,1);
    Zyy(i) = Z(2,2);
    Tzx(i) = T(1,1);
    Tzy(i) = T(1,2);
    VarZxx(i) = abs(max(VarZ(1,1),threshold_Var*Z(1,1)));
    VarZxy(i) = abs(max(VarZ(1,2),threshold_Var*Z(1,2)));
    VarZyx(i) = abs(max(VarZ(2,1),threshold_Var*Z(2,1)));
    VarZyy(i) = abs(max(VarZ(2,2),threshold_Var*Z(2,2)));
    VarTzx(i) = abs(max(VarT(1,1),threshold_Var*T(1,1)));
    VarTzy(i) = abs(max(VarT(1,2),threshold_Var*T(1,2)));
end
    sitename = data.sitename;
    [loc_X,loc_Y] =GaussProWGS84(data.lat,data.lon);
    loc_Z = 0;
    period = 1./(data.frq);
    str = file;
    str_to_remove = '.edi';
    file_name = regexprep(str,str_to_remove,'');
    data_cell = {sitename,loc_X,loc_Y,loc_Z,period',Zxx,Zxy,Zyx,Zyy,Tzx,Tzy,VarZxx,VarZxy,VarZyx,VarZyy,VarTzx,VarTzy,data.lat,data.lon,file_name};
end

