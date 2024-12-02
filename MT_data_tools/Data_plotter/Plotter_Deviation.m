function Plotter_Deviation(deviation_2D,data)
%PLOT_DEVIATION 此处显示有关此函数的摘要
%   此处显示详细说明
    %PLOT_APPARENTRESISTIVITY 绘制二位偏离度图
    % sitename, X, Y, Z, period, Zxx, Zxy, Zyx, Zyy, Tzx, Tzy, Var_Zxx, Var_Zxy, Var_Zyx, Var_Zyy, Var_Tzx, Var_Tzy

    %% 确定x轴坐标距离
    distance = sqrt(cell2mat(data(:,2)).^2 + cell2mat(data(:,3)).^2);
    distance = distance - distance(1);

    figure;
    ax = nexttile;
    hold on;
    for station_id = 1:size(data,1)
        distance_id = distance(station_id);
        period_id = data{station_id,5}; 
        distance_id = distance_id * ones(length(period_id),1);
        deviation_id = deviation_2D{station_id};
        scatter(distance_id, log10(period_id),36, deviation_id, 'filled');
    end
    set(ax, 'YDir', 'reverse');
    colorbar();
    colormap(flipud(jet))
    clim([0 0.5])
    xlabel('距离 (m)');
    ylabel('对数周期 (s)');
    title('Swift-偏离度');
    set(gca, 'FontSize', 12);

    sgtitle('二维偏离度分布图');
end

