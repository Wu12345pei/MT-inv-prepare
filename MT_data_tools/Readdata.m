clear;
clc;
run('Addpath');
folder = '../';

% 指定要搜索的路径
path_DGDR = 'D:\Desktop\Research\ModEM\examples\3D_MT\BYKL\DGDR-EDI';
path = path_DGDR;
% 在指定路径中搜索符合条件的文件
data1 = ReadEditoData(path,'DGDR');

data1_blacknamelist = [3,6,7,11];
data1 = Editor_DataBlacknamelist(data1,data1_blacknamelist);


fname = 'DGDR.dat';
status = WriteData3D(folder,fname,data1); 

% 指定要搜索的路径
path_DKLLB = 'D:\Desktop\Research\ModEM\examples\3D_MT\BYKL\DKLB-EDI';
path = path_DKLLB;
% 在指定路径中搜索符合条件的文件
data2 = ReadEditoData(path,'DKLLB');

data2_blacknamelist = [10,11,14,18,26,50,65];
data2 = Editor_DataBlacknamelist(data2,data2_blacknamelist);

fname = 'DKLLB.dat';
status = WriteData3D(folder,fname,data2); 

%合并两条测线数据
data_combine = Editor_Mergedata(data1,data2);

%筛选等间距台站
station_num=20;
[data_combine_selected] = Editor_SelectEqualspacing(data_combine,station_num);

%选取周期上限
T_max = 1000;
data_combine = Editor_CutDataByPeriod(data_combine,T_max);
data_combine_selected = Editor_CutDataByPeriod(data_combine_selected,T_max);
data_combine_selected = data_combine_selected(:,1:17);
%建立网格
run('DesignMeshandPlot.m')

%计算偏移并添加
data_combine_selected = Editor_Addshift(data_combine_selected,[x_station_start_at y_station_start_at]);

run('WriteMesh')

%编辑数据
Initial = 0;
run("Editdata.m")

% 读取FLAG文件
dataflag = ReadFlag('../BYKL_DGDR_final.dat',6);

% 根据FlAG文件重新编辑数据
data_combine_selected_edited = Editor_Editdatabyflag(data_combine_selected,dataflag);
%写入文件
fname = 'DKLLB-DGDR.dat';
WriteData3D(folder,fname,data_combine_selected_edited)

