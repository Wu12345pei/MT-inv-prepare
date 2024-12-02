function [Induction_vector] = Calculate_Inductionvector(data)
%Calculate_Inductionvector 此处显示有关此函数
% 单个cell为(Gr,Gi)，共station_num*period个cell
%% the format of data cell
% sitename,X,Y,Z,period,Zxx,Zxy,Zyx,Zyy,Tzx,Tzy,Var_Zxx,Var_Zxy,Var_Zyx,Var_Zyy,Var_Tzx,Var_Tzy
for i = 1:size(data,1)
    period = data{i,5};
    for period_index = 1:length(period)
        Tzx_r = real(data{i,10}(period_index));
        Tzx_i = imag(data{i,10}(period_index));
        Tzy_r = real(data{i,11}(period_index));
        Tzy_i = imag(data{i,11}(period_index));
        Induction_vector{i,period_index} = [-Tzx_r -Tzy_r;Tzy_i,-Tzx_i];
    end
end
end

