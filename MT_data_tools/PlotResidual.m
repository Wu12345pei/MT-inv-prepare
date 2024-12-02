data_filename = '../DKLLB-DGDR.dat'; 
res_filename = '../Modular_NLCG_070.res';
[Residual_by_period, station_loc] = CalculateRes(data_filename, res_filename);

% 设置 periods 数组和子图标题
periods = 1:length(Residual_by_period);  % 假设 periods 的数量等于 Residual_by_period 的长度
direction_titles = {'xx方向的阻抗相对残差', 'xy方向的阻抗相对残差', 'yx方向的阻抗相对残差', 'yy方向的阻抗相对残差'};

% 创建图形，并设置子图布局
figure('Position', [100, 100, 1200, 800]); % 设置图形尺寸
tiledlayout(2, 2, 'Padding', 'compact', 'TileSpacing', 'compact'); % 2x2 子图布局，紧凑排列

for k = 1:4
    ax = nexttile; % 创建下一个子图
    for i = 1:length(Residual_by_period)
        scatter(station_loc(:, 1), periods(i) * ones(1, length(station_loc(:, 1))), ...
            50, Residual_by_period{i}(:, k), 'filled'); % 设置散点大小为50
        hold on;
    end
    colormap(ax, 'jet'); % 使用 jet 配色方案
    clim([0 1]); % 设置颜色范围
    colorbar('Location', 'eastoutside'); % 设置颜色条位置为子图外部
    caxis([0, 1]); % 统一颜色条的数值范围
    set(ax, 'YDir', 'reverse'); % 反向 Y 轴
    set(ax, 'FontSize', 12, 'FontWeight', 'bold'); % 设置字体大小和加粗
    xlabel('测站位置（m）', 'FontSize', 14); % 添加X轴标签
    ylabel('频点', 'FontSize', 14); % 添加Y轴标签
    title(direction_titles{k}, 'FontSize', 16); % 设置子图标题和字体大小
    grid on; % 打开网格线
end

% 添加整体图形标题
sgtitle('不同方向阻抗的相对残差随周期的变化图', 'FontSize', 18, 'FontWeight', 'bold'); % 设置总标题

        