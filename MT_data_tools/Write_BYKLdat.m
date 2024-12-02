fid = fopen('../BYKL_station.dat','w');
data2write = data_combine(:,[18 19 20]);
for i = 1:size(data2write,1)
    fprintf(fid,'%s ',data2write{i,3});
    fprintf(fid,'%f ',data2write{i,1});
    fprintf(fid,'%f \n',data2write{i,2});
end
fclose(fid);