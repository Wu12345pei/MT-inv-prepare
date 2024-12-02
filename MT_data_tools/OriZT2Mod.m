clc;clear all
%#########################################################
% Aim:
%   Convert the EDI2Z format into ModEM format,delete outlier and
%   intraplate at fixed frequencies
% Input:
%   OriZT: ZT file in EDI2Z format
%   Zflag: indicate outlier

% Output:
%   ModEM format data file
%#########################################################
% %% change these parameters
% chara='Zb1224'; %prefix of new ZT and RP file.
% dname='ModEMdata';
% errfld=0.05; % error floor of diagonal impedance components
% errfloffd=0.03; % error floor of off-diagonal impedance components
% errflcmb=0.03; % error floor of combined impedance
% errVTF=100; % error floor of tipper
% errOutlier=1000; %error of outlier

%% read data from OriZT file in EDI2Z format
ZTfile='..\data\Mergeall_2ZT';
 flagfile='..\data\Mergeflagall_2.dat';
dname='westdatong_snppart_T6w5.dat';
[ZTpath,data]=readOriZT(ZTfile);
% x=cell2mat(data(:,2));x=round(x-(max(x)+min(x))/2.0);
% y=cell2mat(data(:,3));y=round(y-(max(y)+min(y))/2.0);
% data(:,2)=num2cell(x);
% data(:,3)=num2cell(y);
dataflag=ReadFlag(flagfile,6);
nsite=size(data,1);
% dataflag=cell(nsite,5);
% for i=1:nsite
%     nper=length(data{i,5});
%     for j=1:nper
%        [~, idx]=min(abs(dataflag2{i,1}-data{i,5}(j)));
%         for jj=1:5
%         dataflag{i,jj}(j,1)=dataflag2{i,jj}(idx);
%         end
%     end
%     
% end
%% fixed period
folder1='c:\Learn\westdatong\data\111_116\LMT';
list1=dir(fullfile(folder1,'*.edi'));
dataL{1}=read_edi(folder1,list1(1).name);
dataL{1}.T=1./dataL{1}.freq;
folder2='c:\Learn\westdatong\data\111_116\BBMT';
list2=dir(fullfile(folder2,'*.edi'));    
dataBB{1}=read_edi(folder2,list2(1).name);
dataBB{1}.T=1./dataBB{1}.freq;
startT=0.01;
[~,ind1]=min(abs(dataBB{1}.T-startT));
endT=2000;
LendT=65000;
[~,ind2]=min(abs(dataBB{1}.T-endT));
[~,ind3]=min(abs(dataL{1}.T-endT));
[~,ind4]=min(abs(dataL{1}.T-LendT));
ind3=ind3+1;
if mod((ind2-ind1),2)~=0
    ind1=ind1-1;
end
% if mod((ind4-ind3),2)~=0
%     ind4=ind4+1;
% end
BBnum=1;
for i=ind1:2:ind2
    fixedT(BBnum)=dataBB{1}.T(i);
    BBnum=BBnum+1;
end
Lnum=BBnum;
for i=ind3:1:ind4
    fixedT(Lnum)=dataL{1}.T(i);
    Lnum=Lnum+1;
end
%% 
% calculate coordinate
centerlat=40;
centerlon=110;

[x0, y0]=GaussProWGS84(centerlat,centerlon);
for i=1:nsite
    [xx yy]=GaussProWGS84(data{i,2},data{i,3});
    data{i,2}=xx-x0;
    data{i,3}=yy-y0;
end

%%
errfld=0.10; % error floor of diagonal impedance components
errfloffd=0.05; % error floor of off-diagonal impedance components
errflcmb=0.05; % error floor of combined impedance
errVTF=0.03; % error floor of tipper
errOutlier=2e15; %error of outlier

[data2]=PerErrAnaly(data,dataflag,fixedT',errfld,errfloffd,errflcmb,errVTF,errOutlier);
% WriteFlag(ZTpath,data,dataflag(:,2:7),'inv')
[data3]=rmsite(data2,'..\data\rmsite_byrms.txt');
 % %% write data file in ModEM format
   WriteData3D(ZTpath,dname,data3);
%WriteData3DFlag(ZTpath,dname,data,dataflag);
%% stations in latandlon 
% ofile1='../usedstations.txt';
% fid=fopen(ofile1,'w');
% for i=1:size(data3,1)
%     xx=data3{i,2}+x0;
%     yy=data3{i,3}+y0;
%     [lat1 lon1]=GaussProWGS84inv(xx,yy);
%     fprintf(fid,'%0.6f %0.6f\n',lon1,lat1);
% end
% fclose(fid);


