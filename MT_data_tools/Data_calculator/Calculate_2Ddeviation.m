function [deviation_2D] = Calculate_2Ddeviation(data)
%CALCULATE_2DDEVIATION 此处显示有关此函数的摘要
%   此处显示详细说明
x = cell2mat(data(:,2));
y = cell2mat(data(:,3));
p = polyfit(x, y, 1); % 拟合线性模型 y = p(1)*x + p(2)
theta = -atan(p(1));

R = [cos(theta), -sin(theta); 
     sin(theta), cos(theta)]; 

for i = 1:size(data,1)
    period = data{i,5};
        dev = []; 
    for period_index = 1:length(period)
        Z = [data{i,6}(period_index),data{i,7}(period_index); data{i,8}(period_index),data{i,9}(period_index)];
        Z = R*Z*R';
    end
    deviation_2D(i,:) = {dev};
end
end


