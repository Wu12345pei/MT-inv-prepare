function [data_white] = Editor_DataBlacknamelist(data,black_namelist)
%DATABLACKNAMELIST 此处显示有关此函数的摘要
%   此处显示详细说明
data_white = data;
data_white(black_namelist,:) = [];
% for station_id = 1:size(data,1)
%     if ~ismember(station_id,black_namelist)
%         data_white = {data_white;data{station_id,:}};
% end
end

