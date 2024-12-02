% 写入数据文件
WriteRP('../','BYKL_DGDR',data_combine_selected);
WriteZT('../','BYKL_DGDR',data_combine_selected);
if Initial == 1
    % 创建初始化数据,写入文件
    Initial_flag = CreateInitialFlag(data_combine_selected,6);
    WriteFlag('../BYKL_DGDR_final.dat',data_combine_selected,Initial_flag,6);
end
% 编辑
pick_Z



