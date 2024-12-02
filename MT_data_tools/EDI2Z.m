%***********************************
% conver *.EDI files under some folder into impedance
%***********************************
% function [data]=EDI2Z

clear all;clc;
folder=uigetdir('E:\');
listing=dir(fullfile(folder,'*.EDI'));
locfile=fullfile(folder,'GeoLoc.txt');
fidloc=fopen(locfile,'w');
nsite=size(listing,1);
ncomp=17;
data=cell(nsite,ncomp);

%% the format of data cell:
% sitename,X,Y,Z,period,Zxx,Zxy,Zyx,Zyy,Tzx,Tzy,Var_Zxx,Var_Zxy,Var_Zyx,Var_Zyy,Var_Tzx,Var_Tzy
for i=1:nsite
    fname=fullfile(folder,listing(i).name);
    %% read edi
    ediinfo=EDIreader(fname);
    fprintf(fidloc,'%15s,  %f,  %f\n',ediinfo.sitename,ediinfo.lat,ediinfo.lon);
    %% compute edi
    [Z,T,var]=Zcompt(ediinfo.spectra,ediinfo.freeN);
    data{i,1}=ediinfo.sitename;
    data{i,2}=ediinfo.lat;
    data{i,3}=ediinfo.lon;
    data{i,4}=0;
    [~,ix]=sort(ediinfo.frq,'ascend');
    data{i,5}=1./ediinfo.frq(ix); 
    delt=Z(:,1);
    data{i,6}=delt(ix);
    delt=Z(:,2);
    data{i,7}=delt(ix);
    delt=Z(:,3);
    data{i,8}=delt(ix);
    delt=Z(:,4);
    data{i,9}=delt(ix);  
    delt=T(:,1);
    data{i,10}=delt(ix);
    delt=T(:,2);
    data{i,11}=delt(ix);
    delt=var(:,1);
    data{i,12}=delt(ix);
    delt=var(:,2);
    data{i,13}=delt(ix);
    delt=var(:,3);
    data{i,14}=delt(ix);
    delt=var(:,4);
    data{i,15}=delt(ix);
    delt=var(:,5);
    data{i,16}=delt(ix);
    delt=var(:,6);
    data{i,17}=delt(ix);
end
fclose(fidloc);
disp('please use tools to convert lon&lat into coordinate')
pause
[filename,filepath]=uigetfile('*.txt','select the coordinate file');
locfile=fullfile(filepath,filename);
fidloc=fopen(locfile,'r');
tmp=fscanf(fidloc,'%*s %f %f',[2,inf]);
fclose(fidloc);
% m1=(max(tmp(1,:))+min(tmp(1,:)))/2.0;
% m2=(max(tmp(2,:))+min(tmp(2,:)))/2.0;
% tmp(1,:)=round(tmp(1,:)-m1);
% tmp(2,:)=round(tmp(2,:)-m2);
for i=1:nsite
    data{i,2}=tmp(1,i);
    data{i,3}=tmp(2,i);
end
WriteZT(folder,'Ori',data)
WriteRP(folder,'Ori',data)


