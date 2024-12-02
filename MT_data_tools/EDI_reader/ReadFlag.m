function [dataflag]=ReadFlag(flagfile,idctor)
% [flagname,flagpath]=uigetfile('*','choose the Zflag file to open');
% flagfile=fullfile(flagpath,flagname);
% flagfile='C:\Users\zhanghq\Desktop\zbfile\outZoutflag.dat';
fidin=fopen(flagfile,'r');
% % the format of dataflag cell
% sitename,period,flagxy,flagyx,flagxx,flagyy;
ns=fscanf(fidin,'Nsite=%d\n');
if idctor==6
dataflag=cell(ns,7);
for i=1:ns
    tmp=fgetl(fidin);
    nper=sscanf(tmp,'%*s nperiod=%d\n');
    tmp=fgetl(fidin);
    tmp1= fscanf(fidin,'%f %d %d %d %d %d %d\n',[7,nper]);
    for j=1:7
        dataflag{i,j}=tmp1(j,:)';
    end
end
elseif idctor==4
    dataflag=cell(ns,5);
for i=1:ns
    tmp=fgetl(fidin);
    nper=sscanf(tmp,'%*s nperiod=%d\n');
    tmp=fgetl(fidin);
    tmp1= fscanf(fidin,'%f  %d %d %d %d\n',[5,nper]);
    for j=1:5
        dataflag{i,j}=tmp1(j,:)';
    end
    
end
elseif idctor==2
    dataflag=cell(ns,3);
for i=1:ns
    tmp=fgetl(fidin);
    nper=sscanf(tmp,'%*s nperiod=%d\n');
    tmp=fgetl(fidin);
    tmp1= fscanf(fidin,'%f  %d %d\n',[3,nper]);
    for j=1:3
        dataflag{i,j}=tmp1(j,:)';
    end
end
else error('flag format do not match');
end

fclose(fidin);