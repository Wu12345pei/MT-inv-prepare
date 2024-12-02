function [data_shift] = Editor_Addshift(data,station_start_at)
%EDITOR_ADDSHIFT 此处显示有关此函数的摘要
%计算偏移并添加
data_shift = data;
x_station_start_at = station_start_at(1);
y_station_start_at = station_start_at(2);
data_x_list = cell2mat(data(:,2));
data_y_list = cell2mat(data(:,3));
x_shift = min(data_x_list) - x_station_start_at;
y_shift = min(data_y_list) - y_station_start_at;
data_x_list = data_x_list - x_shift;
data_y_list = data_y_list - y_shift;
for i = 1:length(data_x_list)
    data_shift{i,2} = data_x_list(i);
    data_shift{i,3} = data_y_list(i);
end
end

