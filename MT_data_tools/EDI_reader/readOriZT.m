function [ZTpath,data]=readOriZT(ZTfile)

%******************************
% aim:
%   read Z&T data from EDI2Z format files
%******************************
% the format of ZT cell:
% sitename,Lat,Lon,Z,period,Zxx,Zxy,Zyx,Zyy,Tzx,Tzy,Var_Zxx,Var_Zxy,Var_Zyx,Var_Zyy,Var_Tzx,Var_Tzy

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [ZTname,ZTpath]=uigetfile('*','choose the ZT file from EDI2Z');
% clc;clear;
% ZTpath='C:\Users\zhanghq\Desktop\zbfile';
% ZTname='OriZT';
% chara='Ori';
% ZTfile=fullfile(ZTpath, ZTname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ZTpath,~,~]=fileparts(ZTfile);
fidin=fopen(ZTfile,'r');
Nsite=fscanf(fidin,'Nsite=%d\n');
for i=1:Nsite
    data{i,1}=fscanf(fidin,'SiteName=%s\n');
     snm=data{i,1};
    delt=fscanf(fidin,'%f %f %d\n',[1,3]);
   
    data{i,2}=delt(1);
    data{i,3}=delt(2);
    data{i,4}=0;
    nfrq=delt(3);
    tmp=fgetl(fidin);
    if ~isempty(strfind(tmp,'T'))
    if i==1; data=cell(Nsite,17); data{i,1}=snm;   data{i,2}=delt(1);data{i,3}=delt(2);data{i,4}=0;end      
    tmp=fscanf(fidin,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n',[19,nfrq]);
    tmp=tmp';
    data{i,5}=tmp(:,1);
    data{i,6}=tmp(:,2)+1i*tmp(:,3);
    data{i,7}=tmp(:,4)+1i*tmp(:,5);
    data{i,8}=tmp(:,6)+1i*tmp(:,7);
    data{i,9}=tmp(:,8)+1i*tmp(:,9);
    data{i,10}=tmp(:,10)+1i*tmp(:,11);
    data{i,11}=tmp(:,12)+1i*tmp(:,13);
    data{i,12}=tmp(:,14);
    data{i,13}=tmp(:,15);
    data{i,14}=tmp(:,16);
    data{i,15}=tmp(:,17);
    data{i,16}=tmp(:,18);
    data{i,17}=tmp(:,19);
    else
    if i==1; data=cell(Nsite,13); data{i,1}=snm;   data{i,2}=delt(1);data{i,3}=delt(2);data{i,4}=0;end    
    tmp=fscanf(fidin,'%f %f %f %f %f %f %f %f %f %f %f %f %f\n',[13,nfrq]);
    tmp=tmp';
    data{i,5}=tmp(:,1);
    data{i,6}=tmp(:,2)+1i*tmp(:,3);
    data{i,7}=tmp(:,4)+1i*tmp(:,5);
    data{i,8}=tmp(:,6)+1i*tmp(:,7);
    data{i,9}=tmp(:,8)+1i*tmp(:,9);
    data{i,10}=tmp(:,10);
    data{i,11}=tmp(:,11);
    data{i,12}=tmp(:,12);
    data{i,13}=tmp(:,13);

    end
    
end
fclose(fidin);
%%%%%%%%%%%%%%%%%%%%%%%%
% WriteRP(ZTpath,chara,data)
%%%%%%%%%%%%%%%%%%%%%%
 end