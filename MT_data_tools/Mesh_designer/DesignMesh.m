function [x_cell_sizes, y_cell_sizes, z_cell_sizes, x_station_start_at, y_station_start_at] = DesignMesh(station_coords, periods)
    % 生成MT反演所需的网格坐标数组x, y, z
    % 输入：
    %   station_coords - 台站坐标，N x 2矩阵，每行为[x, y]
    %   periods - EDI数据的周期数组
    % 输出：
    %   x_cell_sizes, y_cell_sizes, z_cell_sizes - X, Y, Z方向的网格单元尺寸
    %   x_station_start_at, y_station_start_at - X, Y方向上台站起始点的位置

    %% 参数设置
    min_cell_size = 500;           % 核心区最小网格单元尺寸，单位：米
    max_cell_size = 100000;        % 最大网格单元尺寸，单位：米
    buffer_cell_count = 10;        % 边缘区网格单元数量
    cells_between_stations = 2;    % 每两个台站之间的网格单元数
    growth_factor = 1.3;           % 边缘区网格增长因子
    z_growth_factor = 1.1;         % Z 方向网格增长因子
    initial_resistivity = 100;     % 初始电阻率，欧姆·米

    %% X 方向网格生成
    [x_cell_sizes, x_station_start_at] = GenerateMesh1D(station_coords(:, 1), cells_between_stations, min_cell_size, max_cell_size, buffer_cell_count, growth_factor);

    %% Y 方向网格生成
    [y_cell_sizes, y_station_start_at] = GenerateMesh1D(station_coords(:, 2), cells_between_stations, min_cell_size, max_cell_size, buffer_cell_count, growth_factor);

    %% Z 方向网格生成
    max_period = max(periods);  % 最大周期
    min_period = min(periods);   % 最小周期
    skin_depth = 100 * sqrt(10 * initial_resistivity * max_period);  % 估算最大感应深度
    skin_depth_min = 100 * sqrt(10 * initial_resistivity * min_period)  % 估算最小感应深度
    z_cell_sizes = GenerateZGrid(skin_depth, skin_depth_min,length(periods), z_growth_factor);

    %% 可视化网格与台站
    x = station_coords(:,1) - station_coords(1,1)+x_station_start_at;
    y = station_coords(:,2) - station_coords(1,2)+y_station_start_at;
    VisualizeMesh(x_cell_sizes, y_cell_sizes, z_cell_sizes, [x y]);
end

%% 辅助函数 - X 和 Y 方向网格生成
function [cell_sizes, station_start_at] = GenerateMesh1D(station_coords, cells_between_stations, min_cell_size, max_cell_size, buffer_cell_count, growth_factor)
    % 生成单一方向的网格（X或Y）
    station_coords = sort(station_coords);
    num_stations = length(station_coords);
    station_distances = diff(station_coords);  % 计算相邻台站之间的距离
    core_cell_size = mean(station_distances) / cells_between_stations;  % 核心区网格单元尺寸

    % 核心区网格等间距分布
    cell_sizes_center = repmat(core_cell_size, 1, cells_between_stations * (num_stations - 1));
    
    % 将台站坐标全部偏移一个固定值（小于网格间距），以确保台站不落在网格线上
    offset = 0.3 * core_cell_size;

    % 左右缓冲区生成
    buffer_size = core_cell_size;  % 缓冲区初始单元大小为核心区单元大小
    buffer_cells_left = GenerateBufferGrid(buffer_size, buffer_cell_count, growth_factor, max_cell_size);
    buffer_cells_right = GenerateBufferGrid(buffer_size, buffer_cell_count, growth_factor, max_cell_size);
    buffer_cells_left = fliplr(buffer_cells_left);
    % 合并中心网格和缓冲区网格
    cell_sizes = [buffer_cells_left, cell_sizes_center, buffer_cells_right];
    station_start_at = sum(buffer_cells_left)+offset;  % 台站起始点位置为左侧缓冲区总长度加上偏移

    % 在 GenerateMesh1D 函数内部或外部，生成网格后检查台站位置
    % 假设 station_coords_shifted 为台站坐标，cell_edges 为网格线坐标
    station_coords_shifted = station_coords + offset;
    
    % 计算网格节点（单元边界）坐标
    cell_edges = [0, cumsum(cell_sizes)]; % 网格线坐标
    tolerance = 0.1*core_cell_size;
    % 调用检查函数
    [stations_on_grid, stations_on_grid_indices] = CheckStationsOnGridLines(station_coords_shifted, cell_edges,tolerance);
    
    % 如果存在台站落在网格线上，输出警告信息
    if any(stations_on_grid)
        fprintf('以下台站落在网格线上：');
        for idx = stations_on_grid_indices
            fprintf('台站索引：%d，坐标：%f\n', idx, station_coords_shifted(idx));
        end
        % 可以在此处采取措施，例如调整台站坐标或重新生成网格
    else
        disp('所有台站均未落在网格线上。');
    end      

end

%% 辅助函数 - 缓冲区网格生成
function buffer_cells = GenerateBufferGrid(initial_size, cell_count, growth_factor, max_cell_size)
    % 生成缓冲区网格单元，逐步递增
    buffer_cells = initial_size * (growth_factor .^ (0:cell_count-1));
    buffer_cells = min(buffer_cells, max_cell_size);  % 限制最大单元尺寸
end

%% 辅助函数 - Z 方向网格生成
function z_cell_sizes = GenerateZGrid(skin_depth, skin_depth_min,num_periods, growth_factor)
    % 生成 Z 方向网格单元厚度
    z_cell_sizes = [skin_depth_min];  % 初始单元厚度，单位：米
    for i = 2:num_periods
        z_cell_sizes(i) = z_cell_sizes(i-1) * growth_factor;
    end
    % 确保总厚度达到感应深度的 1.5 倍
    while sum(z_cell_sizes) < skin_depth * 1.5
        z_cell_sizes(end + 1) = z_cell_sizes(end) * growth_factor;
    end
end

%% 辅助函数 - 可视化三维网格及台站位置
function VisualizeMesh(x_cell_sizes, y_cell_sizes, z_cell_sizes, station_coords)
    % 生成网格节点坐标
    x_nodes = [0, cumsum(x_cell_sizes)];
    y_nodes = [0, cumsum(y_cell_sizes)];
    z_nodes = [0, cumsum(z_cell_sizes)];

    % 计算网格中心坐标
    x_centers = (x_nodes(1:end-1) + x_nodes(2:end)) / 2;
    y_centers = (y_nodes(1:end-1) + y_nodes(2:end)) / 2;
    z_centers = (z_nodes(1:end-1) + z_nodes(2:end)) / 2;

    % 三维网格绘制
    figure;
    hold on;
    n = 5;  % 网格线绘制间隔

    % 绘制 X 方向网格线
    for y_idx = 1:n:length(y_centers)
        for z_idx = 1:n:length(z_centers)
            plot3(x_centers, y_centers(y_idx) * ones(size(x_centers)), z_centers(z_idx) * ones(size(x_centers)), 'k-');
        end
    end

    % 绘制 Y 方向网格线
    for x_idx = 1:n:length(x_centers)
        for z_idx = 1:n:length(z_centers)
            plot3(x_centers(x_idx) * ones(size(y_centers)), y_centers, z_centers(z_idx) * ones(size(y_centers)), 'k-');
        end
    end

    % 绘制 Z 方向网格线
    for x_idx = 1:n:length(x_centers)
        for y_idx = 1:n:length(y_centers)
            plot3(x_centers(x_idx) * ones(size(z_centers)), y_centers(y_idx) * ones(size(z_centers)), z_centers, 'k-');
        end
    end
    ax = gca;
    x_range = diff(ax.XLim);
    y_range = diff(ax.YLim);
    z_range = diff(ax.ZLim);
    avg_range = mean([x_range, y_range, z_range]);
    marker_size = avg_range * 0.01; % 例如，设置为轴范围的 1%
    % 绘制台站位置
    scatter3(station_coords(:, 1), station_coords(:, 2), ones(size(station_coords, 1), 1),100, 'r', 'filled', '^');

    % 设置视角和坐标轴标签
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    title('三维网格划分及台站位置');
    set(gca, 'ZDir', 'reverse');
    set(gca, 'Zscale', 'log');
    view(3);
    grid on;
    axis equal;
    hold off;
end

%% 辅助函数 - 检查台站是否落在网格线上
function [stations_on_grid, stations_on_grid_indices] = CheckStationsOnGridLines(station_coords, cell_edges,tolerance)
    % 检查是否有台站落在网格线上
    % 输入：
    %   station_coords - 台站坐标数组
    %   cell_edges - 网格线（单元边界）坐标数组
    % 输出：
    %   stations_on_grid - 逻辑数组，表示哪些台站落在网格线上
    %   stations_on_grid_indices - 落在网格线上的台站索引

    % 设定一个小的容差，考虑浮点数计算误差
    stations_on_grid = false(size(station_coords));
    stations_on_grid_indices = [];

    for i = 1:length(station_coords)
        station = station_coords(i);
        % 计算台站与所有网格线的距离
        differences = abs(cell_edges - station);
        % 判断是否存在小于容差的距离
        if any(differences < tolerance)
            stations_on_grid(i) = true;
            stations_on_grid_indices(end+1) = i; %#ok<AGROW>
        end
    end
end

