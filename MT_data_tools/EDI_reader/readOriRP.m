function [RPpath,data]=readOriRP(RPfile)
%******************************
% aim:
%   read apparant&phase data from EDI2Z format files
%******************************
%% the format of data cell:
% sitename,Lat,Lon,Z,period  rhoxx  phsxx  rhoxy  phsxy rhoyx  phsx  rhoyy  phsyy varrxx  varpxx varrxy  varpxy varryx  varpyx varryy  varpyy
% [RPname,RPpath]=uigetfile('*','choose the RP file from EDI2Z');
% RPfile=fullfile(RPpath, RPname);
% RPpath='C:\Users\zhanghq\Desktop\zbfile';
% RPfile='C:\Users\zhanghq\Desktop\zbfile\OriRP';
[RPpath,~,~]=fileparts(RPfile);
fidin=fopen(RPfile,'r');
Nsite=fscanf(fidin,'Nsite=%d\n');
data=cell(Nsite,21);
for i=1:Nsite
    data{i,1}=fscanf(fidin,'SiteName=%s\n');
    delt=fscanf(fidin,'%f %f %d\n',[1,3]);
    data{i,2}=delt(1);
    data{i,3}=delt(2);
    data{i,4}=0;
    nfrq=delt(3);
    tmp=fgetl(fidin);
    tmp=fscanf(fidin,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n',[17,nfrq]);
    tmp=tmp';
    data{i,5}=tmp(:,1);
    data{i,6}=tmp(:,2);
    data{i,7}=tmp(:,3);
    data{i,8}=tmp(:,4);
    data{i,9}=tmp(:,5);
    data{i,10}=tmp(:,6);
    data{i,11}=tmp(:,7);
    data{i,12}=tmp(:,8);
    data{i,13}=tmp(:,9);
    data{i,14}=tmp(:,10);
    data{i,15}=tmp(:,11);
    data{i,16}=tmp(:,12);
    data{i,17}=tmp(:,13);
    data{i,18}=tmp(:,14);
    data{i,19}=tmp(:,15);
    data{i,20}=tmp(:,16);
    data{i,21}=tmp(:,17);
end
fclose(fidin);
 end