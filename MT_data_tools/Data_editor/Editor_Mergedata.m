function [data_combine] = Editor_Mergedata(data1,data2)
%EDITOR_MERGEDATA 此处显示有关此函数的摘要
%   此处显示详细说明
data_combine = cell(size(data1,1)+size(data2,1),size(data1,2));
data_combine(1:size(data1,1),:) = data1;
data_combine(size(data1,1)+1:end,:) = data2;
end

