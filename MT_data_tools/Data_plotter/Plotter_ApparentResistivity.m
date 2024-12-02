function Plotter_ApparentResistivity(Apparent_resistivity,Var_apr, data)
    %PLOT_APPARENTRESISTIVITY 绘制视电阻率图
    % sitename, X, Y, Z, period, Zxx, Zxy, Zyx, Zyy, Tzx, Tzy, Var_Zxx, Var_Zxy, Var_Zyx, Var_Zyy, Var_Tzx, Var_Tzy

    %% 确定x轴坐标距离
    distance = sqrt(cell2mat(data(:,2)).^2 + cell2mat(data(:,3)).^2);
    distance = distance - distance(1);

    figure;
    tiledlayout(2,2);

    for i = 1:4 % xx, xy, yx, yy
        ax = nexttile;
        hold on;
        for station_id = 1:size(data,1)
            distance_id = distance(station_id);
            period_id = data{station_id,5}; 
            distance_id = distance_id * ones(length(period_id),1);
            Apparent_Resistivity_id = Apparent_resistivity{station_id,i};
            scatter(distance_id, log10(period_id), 36, log10(Apparent_Resistivity_id), 'filled');
        end
        set(ax, 'YDir', 'reverse');
        colorbar();
        colormap(flipud(jet))
        xlabel('距离 (m)');
        ylabel('对数周期 (s)');
        title(['视电阻率 - ', char(120 + mod(i-1,2)), char(120 + floor((i-1)/2))]);
        set(gca, 'FontSize', 12);
    end
    sgtitle('视电阻率分布图');

n_plot = round(size(data,1)/16)+1;
for i_plot = 1:n_plot
    figure;
    tiledlayout(4,4);
    
    for station_id = 1+(i_plot-1)*16:min(size(data,1),16+(i_plot-1)*16)
        period_id = data{station_id,5};
        ax = nexttile;
        hold on;
        
        for i = 1:4
            Apparent_Resistivity_id = Apparent_resistivity{station_id,i};
            Apparent_Resistivity_id_error = Var_apr{station_id,i};
            select_period = period_id<3000;
            h(i)=errorbar(log10(period_id(select_period)), Apparent_Resistivity_id(select_period), Apparent_Resistivity_id_error(select_period), 'LineWidth', 1.5);
        end
        
        % 设置图形属性
        title(['Station ', num2str(station_id)], 'FontSize', 12, 'FontWeight', 'bold');
        xlabel('Log10(Period)', 'FontSize', 10);
        ylabel('Apparent Resistivity', 'FontSize', 10);
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
end


