%指定文件路径，获得data格式的数据文件
run('Addpath');

% 在指定路径中搜索符合条件的文件
files = dir(fullfile(path, '*DGDR*.edi'));

for i = 1:length(files)
    file = files(i).name;
    one_file_data=EDI2Data(file);
    data1(i,:) = one_file_data;
end