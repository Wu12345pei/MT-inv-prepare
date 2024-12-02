function Plotter_InductionVector(InductionVector, data, period_select)
% PLOTINDUCTIONVECTOR 绘制感应矢量
%   输入参数：
%   InductionVector - 含有感应矢量数据的 cell 数组
%   data - 含有站点坐标及其他信息的表格或 cell 数组
%   period_select - 要选择的周期数组

% 提取站点的 x 和 y 坐标
x = cell2mat(data(:,2));
y = cell2mat(data(:,2));

% 遍历所有选择的周期
for i = 1:length(period_select)
    % 获取当前选择的周期
    period = period_select(i);

    % 找到与当前周期最接近的索引
    [~, period_index] = min(abs(data{1,5} - period));
    
    % 创建一个新的图形窗口
    figure;
    hold on; % 允许多个向量叠加在同一图中

    % 初始化向量矩阵
    Iv_real = zeros(size(InductionVector, 1), 2);
    Iv_imag = zeros(size(InductionVector, 1), 2);

    % 遍历所有站点，提取每个站点在当前周期下的感应矢量
    for j = 1:size(InductionVector, 1)
        if isempty(InductionVector{j, period_index})
            InductionVector{j, period_index} = [0 0;0 0];
        end
        % 获取实部和虚部的矢量分量
        Iv_real(j, 1) = InductionVector{j, period_index}(1, 1); % x 分量
        Iv_real(j, 2) = InductionVector{j, period_index}(1, 2); % y 分量
        Iv_imag(j, 1) = InductionVector{j, period_index}(2, 1); % x 分量
        Iv_imag(j, 2) = InductionVector{j, period_index}(2, 2); % y 分量
    end
    Iv_real_norm = sqrt(Iv_real(:,1).^2+Iv_real(:,2).^2);
    Iv_real_norm_rescale = sqrt(Iv_real_norm)*10;
    Iv_real_norm_rescalefactor = Iv_real_norm_rescale./Iv_real_norm;
    % 绘制所有站点的感应矢量（实部）
    quiver(x, y, Iv_real(:, 1).*Iv_real_norm_rescalefactor, Iv_real(:, 2).*Iv_real_norm_rescalefactor, 'Color', 'r', 'LineWidth', 1.5);
    % 如果需要绘制虚部矢量，可以取消注释以下行
    % quiver(x, y, Iv_imag(:, 1), Iv_imag(:, 2), 'Color', 'b', 'LineWidth', 1.5);

    % 设置图形属性
    axis equal;
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    title(['Induction Vector at Period = ', num2str(round(data{1,5}(period_index),2)), 's']);
    grid on;
    hold off;
end

