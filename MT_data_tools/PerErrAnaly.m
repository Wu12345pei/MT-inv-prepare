function [data2]=PerErrAnaly(data,dataflag,period,errfld,errfloffd,errflcmb,errVTF,errOutlier)
%##########################################
% Aim
%   1. make all sites have same period contents remove outlier
%   2. Change the error of impedance according to error floor
% Ref
%    Tietze.K & Ritter.O, GJI,2013
% 
%###############################################
% the format of ZT cell:
% sitename,X,Y,Z,period,Zxx,Zxy,Zyx,Zyy,Tzx,Tzy,Var_Zxx,Var_Zxy,Var_Zyx,Var_Zyy,Var_Tzx,Var_Tzy
% the format of dataflag cell
% sitename,period,flagxx,flagxy,flagyx,flagyy;
Nsite=size(data,1);
data2=cell(Nsite,17);
for sidx=1:Nsite
 % interpolate data 
 % index in fixedT
    idx=find((max(data{sidx,5})-period>0 & min(data{sidx,5})-period<0));
    per=log10(period(idx));
    nper=length(per);
    ind=zeros(nper,1);
    for ii=1:nper
        [~,ind(ii)]=min(abs(data{sidx,5}-10.^per(ii)));
    end
% Tx
    txidx=find(dataflag{sidx,6});
    if(isempty(txidx))
    txidx=(1:10)';
    end
    datasign=sign(real(data{sidx,10}(ind)));
    intridx=find(max(log10(data{sidx,5}(txidx)))-per>0 & min(log10(data{sidx,5}(txidx)))-per<0);
    % there is no extreme value in extration so no extreme value exam
    tzxr=datasign.*10.^(interp1(log10(data{sidx,5}), log10(abs(real(data{sidx,10}))),per,'pchip'));
    tzxr(intridx)=datasign(intridx).*10.^(interp1(log10(data{sidx,5}(txidx)), log10(abs(real(data{sidx,10}(txidx)))),per(intridx),'pchip'));
    datasign=sign(imag(data{sidx,10}(ind)));
    tzxi=datasign.*10.^(interp1(log10(data{sidx,5}), log10(abs(imag(data{sidx,10}))),per,'pchip'));
    tzxi(intridx)=datasign(intridx).*10.^(interp1(log10(data{sidx,5}(txidx)), log10(abs(imag(data{sidx,10}(txidx)))),per(intridx),'pchip'));
 %  Ty 
    tyidx=find(dataflag{sidx,7});
    if(isempty(tyidx))
    tyidx=(1:10)';
    end
    datasign=sign(real(data{sidx,11}(ind)));
    intridx=find(max(log10(data{sidx,5}(tyidx)))-per>0 & min(log10(data{sidx,5}(tyidx)))-per<0);
    tzyr=datasign.*10.^(interp1(log10(data{sidx,5}), log10(abs(real(data{sidx,11}))),per,'pchip'));
    tzyr(intridx)=datasign(intridx).*10.^(interp1(log10(data{sidx,5}(tyidx)), log10(abs(real(data{sidx,11}(tyidx)))),per(intridx),'pchip'));
    datasign=sign(imag(data{sidx,11}(ind)));
    tzyi=datasign.*10.^(interp1(log10(data{sidx,5}), log10(abs(imag(data{sidx,11}))),per,'pchip'));
    tzyi(intridx)=datasign(intridx).*10.^(interp1(log10(data{sidx,5}(tyidx)), log10(abs(imag(data{sidx,11}(tyidx)))),per(intridx),'pchip'));
% Zxx
    xxidx=find(dataflag{sidx,2});
    if(isempty(xxidx))
    xxidx=(1:10)';
    end
    datasign=sign(real(data{sidx,6}(ind)));
    intridx=find(max(log10(data{sidx,5}(xxidx)))-per>0 & min(log10(data{sidx,5}(xxidx)))-per<0);
    %因为可以外插，所以对flag中去掉的位置的目标频点也进行外插，之后会通过靠近flag的操作判断是否去掉,外插值设置为1.0
    zxxr=datasign.*10.^(interp1(log10(data{sidx,5}), log10(abs(real(data{sidx,6}))),per,'pchip'));
    zxxr(intridx)=datasign(intridx).*10.^(interp1(log10(data{sidx,5}(xxidx)), log10(abs(real(data{sidx,8}(xxidx)))),per(intridx),'pchip'));
    datasign=sign(imag(data{sidx,6}(ind)));
     zxxi=datasign.*10.^(interp1(log10(data{sidx,5}), log10(abs(imag(data{sidx,6}))),per,'pchip'));
    zxxi(intridx)=datasign(intridx).*10.^(interp1(log10(data{sidx,5}(xxidx)), log10(abs(imag(data{sidx,6}(xxidx)))),per(intridx),'pchip'));    
% Zxy
    xyidx=find(dataflag{sidx,3});
    if(isempty(xyidx))
    xyidx=(1:10)';
    end
    datasign=sign(real(data{sidx,7}(ind)));
% !!!!!!!!!!!! stop extrapolation, or there would be severe mistakes
    intridx=find(max(log10(data{sidx,5}(xyidx)))-per>0& min(log10(data{sidx,5}(xyidx)))-per<0);
    zxyr=datasign.*10.^(interp1(log10(data{sidx,5}), log10(abs(real(data{sidx,7}))),per,'pchip'));
    zxyr(intridx)=datasign(intridx).*10.^(interp1(log10(data{sidx,5}(xyidx)), log10(abs(real(data{sidx,7}(xyidx)))),per(intridx),'pchip'));
    datasign=sign(imag(data{sidx,7}(ind)));
    zxyi=datasign.*10.^(interp1(log10(data{sidx,5}), log10(abs(imag(data{sidx,7}))),per,'pchip'));
    zxyi(intridx)=datasign(intridx).*10.^(interp1(log10(data{sidx,5}(xyidx)), log10(abs(imag(data{sidx,7}(xyidx)))),per(intridx),'pchip'));
% Zyx
    yxidx=find(dataflag{sidx,4});
    if(isempty(yxidx))
    yxidx=(1:10)';
    end
    datasign=sign(real(data{sidx,8}(ind)));
    intridx=find(max(log10(data{sidx,5}(yxidx)))-per>0& min(log10(data{sidx,5}(yxidx)))-per<0);
    zyxr=datasign.*10.^(interp1(log10(data{sidx,5}), log10(abs(real(data{sidx,8}))),per,'pchip'));
    zyxr(intridx)=datasign(intridx).*10.^(interp1(log10(data{sidx,5}(yxidx)), log10(abs(real(data{sidx,8}(yxidx)))),per(intridx),'pchip'));
    datasign=sign(imag(data{sidx,8}(ind)));
    zyxi=datasign.*10.^(interp1(log10(data{sidx,5}), log10(abs(imag(data{sidx,8}))),per,'pchip'));
    zyxi(intridx)=datasign(intridx).*10.^(interp1(log10(data{sidx,5}(yxidx)), log10(abs(imag(data{sidx,8}(yxidx)))),per(intridx),'pchip')); 
% Zyy
    yyidx=find(dataflag{sidx,5});
    if(isempty(yyidx))
    yyidx=(1:10)';
    end
    datasign=sign(real(data{sidx,9}(ind)));
    intridx=find(max(log10(data{sidx,5}(yyidx)))-per>0& min(log10(data{sidx,5}(yyidx)))-per<0);
    zyyr=datasign.*10.^(interp1(log10(data{sidx,5}), log10(abs(real(data{sidx,9}))),per,'pchip'));
    zyyr(intridx)=datasign(intridx).*10.^(interp1(log10(data{sidx,5}(yyidx)), log10(abs(real(data{sidx,9}(yyidx)))),per(intridx),'pchip'));
    datasign=sign(imag(data{sidx,9}(ind)));
    zyyi=datasign.*10.^(interp1(log10(data{sidx,5}), log10(abs(imag(data{sidx,9}))),per,'pchip'));
    zyyi(intridx)=datasign(intridx).*10.^(interp1(log10(data{sidx,5}(yyidx)), log10(abs(imag(data{sidx,9}(yyidx)))),per(intridx),'pchip')); 
% error analysis
    temp=errflcmb*sqrt(abs((zxyr+1i*zxyi).*(zyxr+1i*zyxi)));
    tempxx=errfld*abs(zxxr+1i*zxxi);
    tempxy=errfloffd*abs(zxyr+1i*zxyi);
    tempyx=errfloffd*abs(zyxr+1i*zyxi);
    tempyy=errfld*abs(zyyr+1i*zyyi);
    % Zxx_err>=errfld*abs(Zxx)&errflcmb*sqrt(abs(Zxy*Zyx))
    errout=zeros(length(dataflag{sidx,1}(ind)),1);
    errout=double((1-dataflag{sidx,2}(ind))*errOutlier);
    errzxx=max(max(max(sqrt(data{sidx,12}(ind)),temp),tempxx),errout);
    % Zyy_err>errfld*abs(Zyy)&errflcmb*sqrt(abs(Zxy*Zyx))
    errout=double((1-dataflag{sidx,5}(ind))*errOutlier);
    errzyy=max(max(max(sqrt(data{sidx,15}(ind)),temp),tempyy),errout);
    % tzx & tzy
    errout=double((1-dataflag{sidx,6}(ind))*errOutlier);
    errtzx=max(max(sqrt(data{sidx,16}(ind)),errVTF),errout);%?
    errout=double((1-dataflag{sidx,7}(ind))*errOutlier);
    errtzy=max(max(sqrt(data{sidx,17}(ind)),errVTF),errout);% no flag?
    % Zxy_err>=errfloffd*abs(Zxy)
    errout=double((1-dataflag{sidx,3}(ind))*errOutlier);
    errzxy=max(max(sqrt(data{sidx,13}(ind)),tempxy),errout);
    % Zyx_err>errfloffd*abs(Zyx)
    errout=double((1-dataflag{sidx,4}(ind))*errOutlier);    
    errzyx=max(max(sqrt(data{sidx,14}(ind)),tempyx),errout);
% read in all components
data2(sidx,1:4)=data(sidx,1:4);
data2{sidx,5}=10.^per;
data2{sidx,6}=zxxr+1i*zxxi;
data2{sidx,7}=zxyr+1i*zxyi;
data2{sidx,8}=zyxr+1i*zyxi;
data2{sidx,9}=zyyr+1i*zyyi;
data2{sidx,10}=tzxr+1i*tzxi;
data2{sidx,11}=tzyr+1i*tzyi;
data2{sidx,12}=errzxx;
data2{sidx,13}=errzxy;
data2{sidx,14}=errzyx;
data2{sidx,15}=errzyy;
data2{sidx,16}=errtzx;
data2{sidx,17}=errtzy;
end

end