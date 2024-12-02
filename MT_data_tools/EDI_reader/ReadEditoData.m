function [data] = ReadEditoData(path,station_str)
%READEDI_DATA 此处显示有关此函数的摘要
%   此处显示详细说明
% 在指定路径中搜索符合条件的文件
files = dir(fullfile(path, strcat('*',station_str,'*.edi')));

for i = 1:length(files)
    file = files(i).name;
    one_file_data=EDI2Data(file);
    data(i,:) = one_file_data;
end
end

