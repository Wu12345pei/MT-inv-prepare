function [station_coords] = Getstationcoords(data)
%GETSTATIONCOORDS 此处显示有关此函数的摘要
%   此处显示详细说明
data_x_list = cell2mat(data(:,2));
data_y_list = cell2mat(data(:,3));
station_coords = [data_x_list,data_y_list];
end

