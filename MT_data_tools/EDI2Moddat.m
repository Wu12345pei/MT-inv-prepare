% % % clc
% % % clear
% % % %% convert EDI files contained Z component directly to ModEM format
% % % % read edi files
% % % folder1='c:\Learn\jointinversiontest\selected_sinoprobe\LMT';
% % % list1=dir(fullfile(folder1,'*.edi'));
% % % for i=1:length(list1);
% % %     
% % % dataL{i}=read_edi(folder1,list1(i).name);
% % % dataL{i}.T=1./dataL{i}.freq;
% % % end
% % % folder2='c:\Learn\jointinversiontest\selected_sinoprobe\BBMT';
% % % list2=dir(fullfile(folder2,'*.edi'));
% % % for i=1:length(list2);
% % %     
% % % dataBB{i}=read_edi(folder2,list2(i).name);
% % % dataBB{i}.T=1./dataBB{i}.freq;
% % % end
% % % % intraplate at fixed frequencies
% % % % 插值时以长周期为准 误差不插值 ，选择最近的，阻抗张量对数插值，保留正负号
% % % startT=0.04;
% % % [~,ind1]=min(abs(dataBB{1}.T-startT));
% % % endT=2500;
% % % [~,ind2]=min(abs(dataBB{1}.T-endT));
% % % [~,ind3]=min(abs(dataL{1}.T-endT));
% % % ind3=ind3+1;
% % % if mod((ind2-ind1),2)~=0
% % %     ind1=ind1-1;
% % % end
% % % BBnum=1;
% % % for i=ind1:2:ind2
% % %     fixedT(BBnum)=dataBB{1}.T(i);
% % %     BBnum=BBnum+1;
% % % end
% % % Lnum=BBnum;
% % % for i=ind3:2:length(dataL{1}.T)
% % %     fixedT(Lnum)=dataL{1}.T(i);
% % %     Lnum=Lnum+1;
% % % end
% % % fixedBBT=fixedT(1:BBnum-1);
% % % fixedLT=fixedT(BBnum:end);
% % % for i=1:length(dataBB)
% % %     fixeddataBB{i}.T=fixedBBT;
% % %     fixeddataBB{i}.sitename=dataBB{i}.sitename;
% % %      fixeddataBB{i}.lat=dataBB{i}.lat;
% % %      fixeddataBB{i}.lon=dataBB{i}.lon;
% % %      fixeddataBB{i}.ZXXR=spline(log10(dataBB{i}.T),(dataBB{i}.ZXXR),log10(fixedBBT));
% % %      fixeddataBB{i}.ZXXI=spline(log10(dataBB{i}.T),(dataBB{i}.ZXXI),log10(fixedBBT));
% % %      fixeddataBB{i}.ZXXVAR=spline(log10(dataBB{i}.T),(dataBB{i}.ZXXVAR),log10(fixedBBT));
% % %      fixeddataBB{i}.ZXYR=spline(log10(dataBB{i}.T),(dataBB{i}.ZXYR),log10(fixedBBT));
% % %      fixeddataBB{i}.ZXYI=spline(log10(dataBB{i}.T),(dataBB{i}.ZXYI),log10(fixedBBT));
% % %      fixeddataBB{i}.ZXYVAR=spline(log10(dataBB{i}.T),(dataBB{i}.ZXYVAR),log10(fixedBBT));
% % %      fixeddataBB{i}.ZYXR=spline(log10(dataBB{i}.T),(dataBB{i}.ZYXR),log10(fixedBBT));
% % %      fixeddataBB{i}.ZYXI=spline(log10(dataBB{i}.T),(dataBB{i}.ZYXI),log10(fixedBBT));
% % %      fixeddataBB{i}.ZYXVAR=spline(log10(dataBB{i}.T),(dataBB{i}.ZYXVAR),log10(fixedBBT));
% % %      fixeddataBB{i}.ZYYR=spline(log10(dataBB{i}.T),(dataBB{i}.ZYYR),log10(fixedBBT));
% % %      fixeddataBB{i}.ZYYI=spline(log10(dataBB{i}.T),(dataBB{i}.ZYYI),log10(fixedBBT));
% % %      fixeddataBB{i}.ZYYVAR=spline(log10(dataBB{i}.T),(dataBB{i}.ZYYVAR),log10(fixedBBT));
% % %      fixeddataBB{i}.TXR=spline(log10(dataBB{i}.T),(dataBB{i}.TXR),log10(fixedBBT));
% % %      fixeddataBB{i}.TXI=spline(log10(dataBB{i}.T),(dataBB{i}.TXI),log10(fixedBBT));
% % %      fixeddataBB{i}.TXVAR=spline(log10(dataBB{i}.T),(dataBB{i}.TXVAR),log10(fixedBBT));
% % %      fixeddataBB{i}.TYR=spline(log10(dataBB{i}.T),(dataBB{i}.TYR),log10(fixedBBT));
% % %      fixeddataBB{i}.TYI=spline(log10(dataBB{i}.T),(dataBB{i}.TYI),log10(fixedBBT));
% % %      fixeddataBB{i}.TYVAR=spline(log10(dataBB{i}.T),(dataBB{i}.TYVAR),log10(fixedBBT));
% % % end
% % % for i=1:length(dataL)
% % %     fixeddataL{i}.T=fixedLT;
% % %     fixeddataL{i}.sitename=dataL{i}.sitename;
% % %      fixeddataL{i}.lat=dataL{i}.lat;
% % %      fixeddataL{i}.lon=dataL{i}.lon;
% % %      fixeddataL{i}.ZXXR=spline(log10(dataL{i}.T),(dataL{i}.ZXXR),log10(fixedLT));
% % %      fixeddataL{i}.ZXXI=spline(log10(dataL{i}.T),(dataL{i}.ZXXI),log10(fixedLT));
% % %      fixeddataL{i}.ZXXVAR=spline(log10(dataL{i}.T),(dataL{i}.ZXXVAR),log10(fixedLT));
% % %      fixeddataL{i}.ZXYR=spline(log10(dataL{i}.T),(dataL{i}.ZXYR),log10(fixedLT));
% % %      fixeddataL{i}.ZXYI=spline(log10(dataL{i}.T),(dataL{i}.ZXYI),log10(fixedLT));
% % %      fixeddataL{i}.ZXYVAR=spline(log10(dataL{i}.T),(dataL{i}.ZXYVAR),log10(fixedLT));
% % %      fixeddataL{i}.ZYXR=spline(log10(dataL{i}.T),(dataL{i}.ZYXR),log10(fixedLT));
% % %      fixeddataL{i}.ZYXI=spline(log10(dataL{i}.T),(dataL{i}.ZYXI),log10(fixedLT));
% % %      fixeddataL{i}.ZYXVAR=spline(log10(dataL{i}.T),(dataL{i}.ZYXVAR),log10(fixedLT));
% % %      fixeddataL{i}.ZYYR=spline(log10(dataL{i}.T),(dataL{i}.ZYYR),log10(fixedLT));
% % %      fixeddataL{i}.ZYYI=spline(log10(dataL{i}.T),(dataL{i}.ZYYI),log10(fixedLT));
% % %      fixeddataL{i}.ZYYVAR=spline(log10(dataL{i}.T),(dataL{i}.ZYYVAR),log10(fixedLT));
% % %      fixeddataL{i}.TXR=spline(log10(dataL{i}.T),(dataL{i}.TXR),log10(fixedLT));
% % %      fixeddataL{i}.TXI=spline(log10(dataL{i}.T),(dataL{i}.TXI),log10(fixedLT));
% % %      fixeddataL{i}.TXVAR=spline(log10(dataL{i}.T),(dataL{i}.TXVAR),log10(fixedLT));
% % %      fixeddataL{i}.TYR=spline(log10(dataL{i}.T),(dataL{i}.TYR),log10(fixedLT));
% % %      fixeddataL{i}.TYI=spline(log10(dataL{i}.T),(dataL{i}.TYI),log10(fixedLT));
% % %      fixeddataL{i}.TYVAR=spline(log10(dataL{i}.T),(dataL{i}.TYVAR),log10(fixedLT));
% % % end
% % % figure
% % % semilogx(dataL{1}.T,1*ones(1,53),'r-*')
% % % hold on
% % % semilogx(fixedLT,1.04*ones(1,length(fixedLT)),'k-*')
% % % semilogx(fixedBBT,1.06*ones(1,length(fixedBBT)),'k-*')
% % % semilogx(dataBB{1}.T,1.02*ones(1,80),'b-*')
% % % hold off
% % % axis([-inf inf -1 3])
% % % 
% % % % add error floor
% % % erfactor=0.1;
% % % for i=1:length(fixeddataBB)
% % %     
% % % for j=1:length(fixeddataBB{i}.T)
% % %     errxy=abs(fixeddataBB{i}.ZXYR(j)+fixeddataBB{i}.ZXYI(j)*1i);
% % %     erryx=abs(fixeddataBB{i}.ZYXR(j)+fixeddataBB{i}.ZYXI(j)*1i);
% % %     errxyyx=sqrt(abs((fixeddataBB{i}.ZXYR(j)+fixeddataBB{i}.ZXYI(j)*1i)*(fixeddataBB{i}.ZYXR(j)-fixeddataBB{i}.ZYXI(j)*1i)));
% % %      fixeddataBB{i}.ZXXVAR(j)=max( fixeddataBB{i}.ZXXVAR(j) , erfactor*errxyyx);
% % %      fixeddataBB{i}.ZXYVAR(j)=max( fixeddataBB{i}.ZXYVAR(j) , erfactor*errxy);
% % %     fixeddataBB{i}.ZYXVAR(j)=max( fixeddataBB{i}.ZYXVAR(j) , erfactor*erryx);
% % %     fixeddataBB{i}.ZYYVAR(j)=max( fixeddataBB{i}.ZYYVAR(j) , erfactor*errxyyx);
% % %      fixeddataBB{i}.TXVAR(j)=max(fixeddataBB{i}.TXVAR(j),0.03);
% % %      fixeddataBB{i}.TYVAR(j)=max(fixeddataBB{i}.TYVAR(j),0.03);
% % % end
% % % end
% % % for i=1:length(fixeddataL)
% % % for j=1:length(fixeddataL{i}.T)
% % %     errxy=abs(fixeddataL{i}.ZXYR(j)+fixeddataL{i}.ZXYI(j)*1i);
% % %     erryx=abs(fixeddataL{i}.ZYXR(j)+fixeddataL{i}.ZYXI(j)*1i);
% % %     errxyyx=sqrt(abs((fixeddataL{i}.ZXYR(j)+fixeddataL{i}.ZXYI(j)*1i)*(fixeddataL{i}.ZYXR(j)-fixeddataL{i}.ZYXI(j)*1i)));
% % %      fixeddataL{i}.ZXXVAR(j)=max( fixeddataL{i}.ZXXVAR(j) , 0.05*errxyyx);
% % %      fixeddataL{i}.ZXYVAR(j)=max( fixeddataL{i}.ZXYVAR(j) , 0.05*errxy);
% % %     fixeddataL{i}.ZYXVAR(j)=max( fixeddataL{i}.ZYXVAR(j) , 0.05*erryx);
% % %     fixeddataL{i}.ZYYVAR(j)=max( fixeddataL{i}.ZYYVAR(j) , 0.05*errxyyx);
% % %      fixeddataL{i}.TXVAR(j)=max(fixeddataL{i}.TXVAR(j),0.02);
% % %      fixeddataL{i}.TYVAR(j)=max(fixeddataL{i}.TYVAR(j),0.02);
% % % end
% % % end
% % % % calculate coordinate
% % % centerlat=40.25;
% % % centerlon=113.5;
% % % [x0, y0]=GaussProWGS84(centerlat,centerlon);
% % % for i=1:length(fixeddataL)
% % %     [xx yy]=GaussProWGS84(fixeddataL{i}.lat,fixeddataL{i}.lon);
% % %     fixeddataL{i}.xloc=xx-x0;
% % %     fixeddataL{i}.yloc=yy-y0;
% % %     xloc1(i)=xx-x0;
% % %     yloc1(i)=yy-y0;
% % % end
% % % for i=1:length(fixeddataBB)
% % %     [xx yy]=GaussProWGS84(fixeddataBB{i}.lat,fixeddataBB{i}.lon);
% % %     fixeddataBB{i}.xloc=xx-x0;
% % %     fixeddataBB{i}.yloc=yy-y0;
% % %     xloc2(i)=xx-x0;
% % %     yloc2(i)=yy-y0;
% % % end
% % % % merge long period site and boardband site
% % % 
% % % for i=1:length(fixeddataL)
% % %     for j=1:length(fixeddataBB)
% % %         if abs(fixeddataL{i}.xloc-fixeddataBB{j}.xloc)<1000 && abs(fixeddataL{i}.yloc-fixeddataBB{j}.yloc)<1000
% % %             fixeddataL{i}.T=fixeddataBB{j}.T;
% % %             fixeddataL{i}.ZXXR=[fixeddataBB{j}.ZXXR(1:21) fixeddataL{i}.ZXXR];
% % %             fixeddataL{i}.ZXXI=[fixeddataBB{j}.ZXXI(1:21) fixeddataL{i}.ZXXI];
% % %             fixeddataL{i}.ZXXVAR=[fixeddataBB{j}.ZXXVAR(1:21) fixeddataL{i}.ZXXVAR];
% % %             fixeddataL{i}.ZXYR=[fixeddataBB{j}.ZXYR(1:21) fixeddataL{i}.ZXYR];
% % %             fixeddataL{i}.ZXYI=[fixeddataBB{j}.ZXYI(1:21) fixeddataL{i}.ZXYI];
% % %             fixeddataL{i}.ZXYVAR=[fixeddataBB{j}.ZXYVAR(1:21) fixeddataL{i}.ZXYVAR];
% % %             fixeddataL{i}.ZYXR=[fixeddataBB{j}.ZYXR(1:21) fixeddataL{i}.ZYXR];
% % %             fixeddataL{i}.ZYXI=[fixeddataBB{j}.ZYXI(1:21) fixeddataL{i}.ZYXI];
% % %             fixeddataL{i}.ZYXVAR=[fixeddataBB{j}.ZYXVAR(1:21) fixeddataL{i}.ZYXVAR];
% % %             fixeddataL{i}.ZYYR=[fixeddataBB{j}.ZYYR(1:21) fixeddataL{i}.ZYYR];
% % %             fixeddataL{i}.ZYYI=[fixeddataBB{j}.ZYYI(1:21) fixeddataL{i}.ZYYI];
% % %             fixeddataL{i}.ZYYVAR=[fixeddataBB{j}.ZYYVAR(1:21) fixeddataL{i}.ZYYVAR];
% % %             fixeddataL{i}.TXR=[fixeddataBB{j}.TXR(1:21) fixeddataL{i}.TXR];
% % %             fixeddataL{i}.TXI=[fixeddataBB{j}.TXI(1:21) fixeddataL{i}.TXI];
% % %             fixeddataL{i}.TXVAR=[fixeddataBB{j}.TXVAR(1:21) fixeddataL{i}.TXVAR];
% % %             fixeddataL{i}.TYR=[fixeddataBB{j}.TYR(1:21) fixeddataL{i}.TYR];
% % %             fixeddataL{i}.TYI=[fixeddataBB{j}.TYI(1:21) fixeddataL{i}.TYI];
% % %             fixeddataL{i}.TYVAR=[fixeddataBB{j}.TYVAR(1:21) fixeddataL{i}.TYVAR];
% % %             fixeddataBB(j)=[];
% % %             break;
% % %         end
% % %     end
% % % end
% % %             
% % % figure
% % % plot(yloc1/1000,xloc1/1000,'r*')
% % % hold on
% % % plot(yloc2/1000,xloc2/1000,'b*')
% % % hold off
% % % % output
% % % fid=fopen('../westdatong_per10.dat','w');
% % % header = '3D MT data from EDI2Z';
% % % signstr = 'exp(-i\omega t)';
% % % units = '[mV/km]/[nT]';
% % % type='Full_Impedance';
% % % origin = [0 0 0];
% % % orientation = 0.0;
% % % comment = 'Period(s) Code GG_Lat GG_Lon X(m) Y(m) Z(m) Component Real Imag Error';
% % % fprintf(fid,'# %s\n',header);
% % % fprintf(fid,'# %s\n',comment);
% % % fprintf(fid,'> %s\n',type);
% % % fprintf(fid,'> %s\n',signstr);
% % % fprintf(fid,'> %s\n',units);
% % % fprintf(fid,'> %.2f\n',orientation);
% % % fprintf(fid,'> %.3f %.3f\n',origin(1:2));
% % % fprintf(fid,'> %d %d\n',length(fixedT),length(fixeddataBB)+length(fixeddataL));
% % % fixeddata=[fixeddataL fixeddataBB];
% % % ncomp=4;
% % %         comp={'ZXX';'ZXY';'ZYX';'ZYY'};
% % %        for i=1:length(fixeddata)
% % %            for j=1:length(fixeddata{i}.T)
% % %             
% % %                     fprintf(fid,'%12.6E ',fixeddata{i}.T(j)); % period
% % %                     fprintf(fid,'%s %8.3f %8.3f ',fixeddata{i}.sitename,0.0, 0.0);
% % %                     fprintf(fid,'%12.3f %12.3f %12.3f ',fixeddata{i}.xloc,fixeddata{i}.yloc,0.0); % receiver x,y,z
% % %                     fprintf(fid,'%s %15.6E %15.6E %15.6E\n','ZXX',fixeddata{i}.ZXXR(j),fixeddata{i}.ZXXI(j),fixeddata{i}.ZXXVAR(j)); % data
% % %                     fprintf(fid,'%12.6E ',fixeddata{i}.T(j)); % period
% % %                     fprintf(fid,'%s %8.3f %8.3f ',fixeddata{i}.sitename,0.0, 0.0);
% % %                     fprintf(fid,'%12.3f %12.3f %12.3f ',fixeddata{i}.xloc,fixeddata{i}.yloc,0.0); % receiver x,y,z
% % %                     fprintf(fid,'%s %15.6E %15.6E %15.6E\n','ZXY',fixeddata{i}.ZXYR(j),fixeddata{i}.ZXYI(j),fixeddata{i}.ZXYVAR(j)); % data
% % %                     fprintf(fid,'%12.6E ',fixeddata{i}.T(j)); % period
% % %                     fprintf(fid,'%s %8.3f %8.3f ',fixeddata{i}.sitename,0.0, 0.0);
% % %                     fprintf(fid,'%12.3f %12.3f %12.3f ',fixeddata{i}.xloc,fixeddata{i}.yloc,0.0); % receiver x,y,z
% % %                     fprintf(fid,'%s %15.6E %15.6E %15.6E\n','ZYX',fixeddata{i}.ZYXR(j),fixeddata{i}.ZYXI(j),fixeddata{i}.ZYXVAR(j)); % data
% % %                     fprintf(fid,'%12.6E ',fixeddata{i}.T(j)); % period
% % %                     fprintf(fid,'%s %8.3f %8.3f ',fixeddata{i}.sitename,0.0, 0.0);
% % %                     fprintf(fid,'%12.3f %12.3f %12.3f ',fixeddata{i}.xloc,fixeddata{i}.yloc,0.0); % receiver x,y,z
% % %                     fprintf(fid,'%s %15.6E %15.6E %15.6E\n','ZYY',fixeddata{i}.ZYYR(j),fixeddata{i}.ZYYI(j),fixeddata{i}.ZYYVAR(j)); % data
% % %                
% % %            end
% % %        end
% % %  type='Full_Vertical_Components';
% % %     units = '[]';
% % %     %  file header: the info line
% % %     fprintf(fid,'# %s\n',header);
% % %     %  data type header: comment, then six lines
% % %     comment = 'Period(s) Code GG_Lat GG_Lon X(m) Y(m) Z(m) Component Real Imag Error';
% % %     fprintf(fid,'# %s\n',comment);
% % %     fprintf(fid,'> %s\n',type);
% % %     fprintf(fid,'> %s\n',signstr);
% % %     fprintf(fid,'> %s\n',units);
% % %     fprintf(fid,'> %.2f\n',orientation);
% % %     fprintf(fid,'> %.3f %.3f\n',origin(1:2));
% % %     fprintf(fid,'> %d %d\n',length(fixedT),length(fixeddata));
% % %   for i=1:length(fixeddata)
% % %            for j=1:length(fixeddata{i}.T)
% % %             
% % %                     fprintf(fid,'%12.6E ',fixeddata{i}.T(j)); % period
% % %                     fprintf(fid,'%s %8.3f %8.3f ',fixeddata{i}.sitename,0.0, 0.0);
% % %                     fprintf(fid,'%12.3f %12.3f %12.3f ',fixeddata{i}.xloc,fixeddata{i}.yloc,0.0); % receiver x,y,z
% % %                     fprintf(fid,'%s %15.6E %15.6E %15.6E\n','TX',fixeddata{i}.TXR(j),fixeddata{i}.TXI(j),fixeddata{i}.TXVAR(j)); % data
% % %                     fprintf(fid,'%12.6E ',fixeddata{i}.T(j)); % period
% % %                     fprintf(fid,'%s %8.3f %8.3f ',fixeddata{i}.sitename,0.0, 0.0);
% % %                     fprintf(fid,'%12.3f %12.3f %12.3f ',fixeddata{i}.xloc,fixeddata{i}.yloc,0.0); % receiver x,y,z
% % %                     fprintf(fid,'%s %15.6E %15.6E %15.6E\n','TY',fixeddata{i}.TYR(j),fixeddata{i}.TYI(j),fixeddata{i}.TYVAR(j)); % data             
% % %            end
% % %   end   
% % % fclose(fid);       