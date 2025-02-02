function [rotated_x, rotated_y] = RotateXY(x, y)
    % 输入：
    %   x - 一维数组，表示点的 x 坐标
    %   y - 一维数组，表示点的 y 坐标
    % 输出：
    %   rotated_x - 旋转后的 x 坐标
    %   rotated_y - 旋转后的 y 坐标
    
    % 1. 使用线性回归拟合，得到点集的主方向（斜率）
    p = polyfit(x, y, 1); % 拟合线性模型 y = p(1)*x + p(2)
    
    % 2. 计算旋转角度（弧度）
    theta = -atan(p(1)); % 旋转角度为斜率的反正切
    
    % 3. 构建旋转矩阵
    R = [cos(theta), -sin(theta); 
         sin(theta), cos(theta)];
    
    % 4. 将点集 (x, y) 旋转
    rotated_coords = R * [x; y];
    
    % 5. 提取旋转后的 x 和 y 坐标
    rotated_x = rotated_coords(1, :);
    rotated_y = rotated_coords(2, :);
    
    % 输出旋转角度（可选）
    disp(['旋转角度（度数）：', num2str(rad2deg(theta))]);
end

