clc
clear
%% convert EDI files contained Z component to OriZT and OriRP files
folder1='c:\Learn\westdatong\data\108\BBMT';
outputfolder1='c:\Learn\westdatong\data\108';
outputfilenamehead='OriB';
list1=dir(fullfile(folder1,'*.edi'));
% folder1='c:\Learn\jointinversiontest\selected_sinoprobe\BBMT';
% list1=dir(fullfile(folder1,'*.edi'));

for i=1:length(list1);
datam{i}=read_edi(folder1,list1(i).name);
datam{i}.T=1./datam{i}.freq;
end

%% convert the format of data cell:
% sitename,Lat,Lon,Z,period,Zxx,Zxy,Zyx,Zyy,Tzx,Tzy,Var_Zxx,Var_Zxy,Var_Zyx,Var_Zyy,Var_Tzx,Var_Tzy
nsite=length(datam);
ncomp=17;
data=cell(nsite,ncomp);
for i=1:nsite
    data{i,1}=datam{i}.sitename;
    data{i,2}=datam{i}.lat;
    data{i,3}=datam{i}.lon;
    data{i,4}=0.0;
    data{i,5}=datam{i}.T;
    data{i,6}=datam{i}.ZXXR+datam{i}.ZXXI*1i;
    data{i,7}=datam{i}.ZXYR+datam{i}.ZXYI*1i;
    data{i,8}=datam{i}.ZYXR+datam{i}.ZYXI*1i;
    data{i,9}=datam{i}.ZYYR+datam{i}.ZYYI*1i;
    data{i,10}=datam{i}.TXR+datam{i}.TXI*1i;
    data{i,11}=datam{i}.TYR+datam{i}.TYI*1i;
    data{i,12}=datam{i}.ZXXVAR;
    data{i,13}=datam{i}.ZXYVAR;
    data{i,14}=datam{i}.ZYXVAR;
    data{i,15}=datam{i}.ZYYVAR;
    data{i,16}=datam{i}.TXVAR;
    data{i,17}=datam{i}.TYVAR;
end
WriteZT(outputfolder1,outputfilenamehead,data);
WriteRP(outputfolder1,outputfilenamehead,data);

    
    
    
    
    
    