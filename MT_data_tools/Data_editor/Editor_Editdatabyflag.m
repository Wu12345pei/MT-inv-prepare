 function [data_edited] = Editor_Editdatabyflag(data,dataflag)
%EDITOR_EDITDATABYFLAG 此处显示有关此函数的摘要
%   此处显示详细说明
station_num = size(data,1);
per_num = size(data{1,5},1);
data_edited = data;
for i = 1:station_num
    for j = 1:per_num
        for comp = 1:6
            if_choose = dataflag{i,comp+1}(j);
            if if_choose == 0
                data_edited{i,11+comp}(j) = 2.0*10^15;
            end
        end
    end
end
end

