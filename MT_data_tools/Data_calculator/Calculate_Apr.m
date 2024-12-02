function [Apparent_resistivity,phi,Var_apr,Var_phi] = Calculate_Apr(data)
%CALCULATE_APR 此函数利用data格式的数据计算视电阻率和相位
% sitename,X,Y,Z,period,Zxx,Zxy,Zyx,Zyy,Tzx,Tzy,Var_Zxx,Var_Zxy,Var_Zyx,Var_Zyy,Var_Tzx,Var_Tzy
for i = 1:size(data,1)
    period = data{i,5};
        rho_xx = [];
        rho_xy = [];
        rho_yx = [];
        rho_yy = [];

        phi_xx = [];
        phi_xy = [];
        phi_yx = [];
        phi_yy = [];
        
        Var_apr_xx = [];
        Var_apr_xy = [];
        Var_apr_yx = [];
        Var_apr_yy = [];

        Var_phi_xx = [];
        Var_phi_xy = [];
        Var_phi_yx = [];
        Var_phi_yy = [];
    for period_index = 1:length(period)
        A = period(period_index);
        unit_convert = 0.2;

        rho_xx(period_index) = abs(data{i,6}(period_index))^2*A*unit_convert; 
        rho_xy(period_index) = abs(data{i,7}(period_index))^2*A*unit_convert;
        rho_yx(period_index) = abs(data{i,8}(period_index))^2*A*unit_convert;
        rho_yy(period_index) = abs(data{i,9}(period_index))^2*A*unit_convert;

        phi_xx(period_index) = angle(data{i,6}(period_index));
        phi_xy(period_index) = angle(data{i,7}(period_index));
        phi_yx(period_index) = angle(data{i,8}(period_index));
        phi_yy(period_index) = angle(data{i,9}(period_index));
        
        Var_apr_xx(period_index) = 0.4 * period(period_index) * rho_xx(period_index) * data{i,12}(period_index);
        Var_apr_xy(period_index) = 0.4 * period(period_index) * rho_xy(period_index) * data{i,13}(period_index);
        Var_apr_yx(period_index) = 0.4 * period(period_index) * rho_yx(period_index) * data{i,14}(period_index);
        Var_apr_yy(period_index) = 0.4 * period(period_index) * rho_yy(period_index) * data{i,15}(period_index);
        
        Var_phi_xx(period_index) = 8 * cos(phi_xx(period_index))^4 * data{i,12}(period_index) * abs(data{i,6}(period_index))^2 / (2 * real(data{i,6}(period_index)));
        Var_phi_xy(period_index) = 8 * cos(phi_xy(period_index))^4 * data{i,13}(period_index) * abs(data{i,7}(period_index))^2 / (2 * real(data{i,7}(period_index)));
        Var_phi_yx(period_index) = 8 * cos(phi_yx(period_index))^4 * data{i,14}(period_index) * abs(data{i,8}(period_index))^2 / (2 * real(data{i,8}(period_index)));
        Var_phi_yy(period_index) = 8 * cos(phi_yy(period_index))^4 * data{i,15}(period_index) * abs(data{i,9}(period_index))^2 / (2 * real(data{i,9}(period_index)));
    end
    Apparent_resistivity(i,:) = {rho_xx,rho_xy,rho_yx,rho_yy};
    phi(i,:) = {phi_xx,phi_xy,phi_yx,phi_yy};
    Var_apr(i,:) =   {Var_apr_xx,Var_apr_xy,Var_apr_yx,Var_apr_yy};
    Var_phi(i,:) = {Var_phi_xx,Var_phi_xy,Var_phi_yx,Var_phi_yy};
end
end

