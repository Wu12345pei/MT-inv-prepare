function [data_cut] = CutDataByPeriod(data,cut_period)
%CUTDATABYPERIOD 此函数将data按照周期进行截断
%   此处显示详细说明
data_cut = data;
for station_id = 1:size(data,1)
    period = data{station_id,5};
    period_id_selected = period<cut_period;
    for i = 5:17
        data_cut{station_id,i} = data{station_id,i} (period_id_selected);
    end
end

