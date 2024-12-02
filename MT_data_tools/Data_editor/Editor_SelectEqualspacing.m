function [data_selected] = Editor_SelectEqualspacing(data,station_num)
%EDITOR_SELECTEQUALSPACING 此函数将data格式的台站数据依照台站的分布进行近似等间隔筛选
%   此处显示详细说明
data_combine_x_list = data(:,2);
data_combine_y_list = data(:,3);
data_combine_x_list = cell2mat(data_combine_x_list);
data_combine_y_list = cell2mat(data_combine_y_list);
[x_selected,y_selected] = Select_equal_spacing(data_combine_x_list,data_combine_y_list,station_num);

m=0;
for i = 1:size(data)
    if ismember(data{i,2},x_selected)
        m=m+1;
        for j = 1:size(data,2)
            data_selected{m,j} = data{i,j};
        end
    end
end
end

