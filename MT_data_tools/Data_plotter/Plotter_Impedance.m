function PlotImpedance(data)
%PLOT_APPARENTRESISTIVITY 绘制阻抗图
% sitename, X, Y, Z, period, Zxx, Zxy, Zyx, Zyy, Tzx, Tzy, Var_Zxx, Var_Zxy, Var_Zyx, Var_Zyy, Var_Tzx, Var_Tzy

n_plot = round(size(data,1)/16)+1;
for i_plot = 1:n_plot
    figure;
    tiledlayout(4,4);
    
    for station_id = 1+(i_plot-1)*16:min(size(data,1),16+(i_plot-1)*16)
        period_id = data{station_id,5};
        ax = nexttile;
        hold on;
        
        for i = 1:4
            Z = [data{station_id,6}',data{station_id,7}',data{station_id,8}',data{station_id,9}'];
            Z_err = [data{station_id,12}',data{station_id,13}',data{station_id,14}',data{station_id,15}']; 
            select_period = period_id<10000;
            h(i)=errorbar(log10(period_id(select_period)), abs(Z(select_period,i)), Z_err(select_period,i), 'LineWidth', 1.5);
        end
        
        % 设置图形属性
        title(['Station ', num2str(station_id)], 'FontSize', 12, 'FontWeight', 'bold');
        xlabel('Log10(Period)', 'FontSize', 10);
        ylabel('Log10(Impedance)', 'FontSize', 10);
        grid on;
        set(gca, 'FontSize', 10, 'LineWidth', 1.2);
        set(gca,'yscale','log');
    end
% 在最后一个子图外面添加图例
lgd = legend(h, {'Rxx', 'Rxy', 'Ryx', 'Ryy'}, 'FontSize', 8);
lgd.Layout.Tile = 'east'; % 将图例放在整个布局的底部
% 全局设置
sgtitle('Apparent Resistivity for All Stations', 'FontSize', 14, 'FontWeight', 'bold');
end

