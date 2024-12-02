[station_coords] = Getstationcoords(data_combine_selected);
periods = data_combine{1,5};
[x_cell_sizes, y_cell_sizes, z_cell_sizes, x_station_start_at, y_station_start_at] = DesignMesh(station_coords, periods);
data_x_list = station_coords(:,1) - station_coords(1,1) + x_station_start_at;
data_y_list = station_coords(:,2) - station_coords(1,2) + y_station_start_at;

% 假设 x_cell_sizes, y_cell_sizes, z_cell_sizes 是网格尺寸向量
meshx = [0, cumsum(x_cell_sizes)];
meshy = [0, cumsum(y_cell_sizes)];
meshz = [0, cumsum(z_cell_sizes)];
data_x_list = station_coords(:,1) - station_coords(1,1) + x_station_start_at;
data_y_list = station_coords(:,2) - station_coords(1,2) + y_station_start_at;



% 创建XY平面的网格
[X, Y] = meshgrid(meshx, meshy);

% 绘制XY平面
figure;
tiledlayout(2,2)
ax1 = nexttile;
pcolor(X, Y, zeros(size(X))); % 用0值的矩阵表示平面上的点
hold on;
scatter(data_x_list,data_y_list,'red','filled','^');
xlabel('X (m)');
ylabel('Y (m)');
title('XY Plane Grid');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'ydir', 'reverse'); % 反转Y轴方向，符合地质绘图习惯

% 创建XZ平面的网格
[X, Z] = meshgrid(meshx, meshz);

% 绘制XZ平面
ax2 = nexttile;
pcolor(X, Z, zeros(size(X))); % 用0值的矩阵表示平面上的点
hold on;
scatter(data_x_list,0,'red','filled','^');
xlabel('X (m)');
ylabel('Z (m)');
title('XZ Plane Grid');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'ydir', 'reverse');

% 创建YZ平面的网格
[Y, Z] = meshgrid(meshy, meshz);
% 绘制YZ平面
ax3 = nexttile;
pcolor(Y, Z, zeros(size(Y))); % 用0值的矩阵表示平面上的点
hold on;
scatter(data_y_list,0,'red','filled','^');
xlabel('Y (m)');
ylabel('Z (m)');
title('YZ Plane Grid');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'ydir', 'reverse');