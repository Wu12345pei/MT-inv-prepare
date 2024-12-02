function WriteZT(folder,chara,data)
datafile=fullfile(folder,strcat(chara,'ZT'));
fidout=fopen(datafile,'w');
nsite=size(data,1);
fprintf(fidout,'Nsite=%d\n',nsite);
if size(data,2)==17
for i=1:nsite
    fprintf(fidout,'SiteName=%s\n',data{i,1});
    fprintf(fidout,'%f  %f  %d\n',data{i,2},data{i,3},length(data{i,5}));
    fprintf(fidout,'period  Zxxr  Zxxi  Zxyr  Zxyi  Zyxr  Zyxi  Zyyr  Zyyi  Tzxr  Tzxi  Tzyr  Tzyi  varZxx  varZxy  varZyx  varZyy  varTzx  varTzy\n');
    for j=1:length(data{i,5})
        fprintf(fidout,'%14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E\n',...
            data{i,5}(j),real(data{i,6}(j)),imag(data{i,6}(j)),real(data{i,7}(j)),imag(data{i,7}(j)),real(data{i,8}(j)),imag(data{i,8}(j)), ...
            real(data{i,9}(j)),imag(data{i,9}(j)),real(data{i,10}(j)),imag(data{i,10}(j)),real(data{i,11}(j)),imag(data{i,11}(j)), ...
            data{i,12}(j),data{i,13}(j),data{i,14}(j),data{i,15}(j),data{i,16}(j),data{i,17}(j));
    end
end
elseif size(data,2)==13
    for i=1:nsite
    fprintf(fidout,'SiteName=%s\n',data{i,1});
    fprintf(fidout,'%f  %f  %d\n',data{i,2},data{i,3},length(data{i,5}));
    fprintf(fidout,'period  Zxxr  Zxxi  Zxyr  Zxyi  Zyxr  Zyxi  Zyyr  Zyyi  varZxx  varZxy  varZyx  varZyy \n');
    for j=1:length(data{i,5})
        fprintf(fidout,'%14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E \n',...
            data{i,5}(j),real(data{i,6}(j)),imag(data{i,6}(j)),real(data{i,7}(j)),imag(data{i,7}(j)),real(data{i,8}(j)),imag(data{i,8}(j)), ...
            real(data{i,9}(j)),imag(data{i,9}(j)),data{i,10}(j),data{i,11}(j),data{i,12}(j),data{i,13}(j));
    end
    end
end
fclose(fidout);


