function pick_site
clear
para.value1=0;
para.RPlist='..\data\Mergeall_2RP';
para.ZTlist='..\data\Mergeall_2ZT';
para.flagfile='..\data\Mergeflagall_2.dat';
para.cwflag=1;
[RPpath,data]=readOriRP(para.RPlist);
[ZTpath,ZTdata]=readOriZT(para.ZTlist);
ssdata=zeros(size(data,1),1);
xxx=cell2mat(data(:,3));
yyy=cell2mat(data(:,2));
rmlistx=null(1,1);
rmlisty=null(1,1);
colortype={'m';'r';'b';'k'};
labeltyep={'xx';'xy';'yx';'yy';'tx';'ty'};
Ns=size(data,1);
if para.cwflag==0
 for iii=1:Ns
        nper=length(data{iii,5});
        for jjj=1:6
        dataflag{iii,jjj}=ones(nper,1);
        end
 end
 elseif para.cwflag==1
     [dataflag]=ReadFlag(para.flagfile,6);
     % del freq
     dataflag(:,1)=[];
end
para.isite=1;
para.icomp=1;
rmlistname=null(1,1);
para.orirmsitename='..\data\rmsite_bycombine.txt';
para.outputfilename='rmsitelist_2.txt';
%% 
warning('off');
set(0,'DefaultUicontrolUnits','normalized');
%% 
handle.f1               =	figure('Toolbar','figure','Units','normalized','Position',[.1 .1 .8 .8]);
                            set(handle.f1,'name','MT site Pick','NumberTitle','off');

handle.hax1              =	axes('pos', [.1 .1 .75 .75]);
                            box(handle.hax1,'on');        
h1=plot(handle.hax1,xxx,yyy,'r*');
pick_read_rmsitenamefile
flgidx1=null(1,1);
for idx3=1:size(data,1)
    for idx4=1:length(rmlistname)
    if strcmp(rmlistname{idx4},data(idx3,1))
        flgidx1=[idx3;flgidx1];
        break
    end
    end
end
hold(handle.hax1,'on');
plot(handle.hax1,xxx(flgidx1),yyy(flgidx1),'*','color',[0.7451 0.7451 0.7451]);
hold(handle.hax1,'off');
grid(handle.hax1,'on')
handle.pb1=                uicontrol(handle.f1,'style','pushbutton','string','zoom in','callback',@pick_callback_zoom,'position', [.05 .95 .1 .04]);
handle.pb2=                uicontrol(handle.f1,'style','pushbutton','string','zoom 1in','callback',@pick_callback_zoomou,'position', [.05 .905 .1 .04]);
handle.pb3=                uicontrol(handle.f1,'style','pushbutton','string','drop','callback',@pick_callback_dropsite,'position', [.65 .95 .1 .04]);
handle.pb3=                uicontrol(handle.f1,'style','pushbutton','string','reuse','callback',@pick_callback_reusesite,'position', [.65 .905 .1 .04]);
handle.pb4=                uicontrol(handle.f1,'style','pushbutton','string','output','callback',@pick_callback_output,'position', [.8 .95 .1 .04]);
handle.pb5=                uicontrol(handle.f1,'style','pushbutton','string','plot','callback',@pick_callback_rhoplot,'position', [.8 .905 .1 .04]);
handle.pb6=                uicontrol(handle.f1,'style','pushbutton','string','singlefit','callback',@pick_callback_ss,'position', [.3 .905 .1 .04]);
    function pick_callback_ss(dummy1,dummy2)
        pick_singlefit
        hold(handle.hax1,'on');
         text(handle.hax1,xxx,yyy,num2str(ssdata,'%3.1f\n'));
        hold(handle.hax1,'off'); 
    end
    function pick_callback_zoom(dummy1,dummy2)
        zoom(handle.hax1,'on')
    end
    function pick_callback_zoomou(dummy1,dummy2)
        zoom(handle.hax1,'off')
    end
    function pick_callback_dropsite(dummy1,dummy2)
          flgidx=null(1,1);
          hold(handle.hax1,'on');
          while para.value1~=1
                if para.value1==1
                    break;
                end
                rect=getrect(handle.hax1); 
                ox=rect(1);
                wx=rect(3);
                oy=rect(2);
                hy=rect(4);
                if wx~=0&&rect(4)~=0
                    idx0=find(xxx>=ox & xxx<=ox+wx);
                    temp=yyy(idx0);
                    idx1=find(temp>=oy & temp<=oy+hy);
                    idx2=idx0(idx1);
                    flgidx=[flgidx;idx2];
                else
                    break
                end
                plot(handle.hax1,xxx(flgidx),yyy(flgidx),'*','color',[0.7451 0.7451 0.7451]);
          end
          hold(handle.hax1,'off');
          flgidx=unique(flgidx);
          rmlistname=[data(flgidx,1);rmlistname];
    end
    function pick_callback_reusesite(dummy1,dummy2)
          flgidx=null(1,1);
          hold(handle.hax1,'on');
          while para.value1~=1
                if para.value1==1
                    break;
                end
                rect=getrect(handle.hax1); 
                ox=rect(1);
                wx=rect(3);
                oy=rect(2);
                hy=rect(4);
                if wx~=0&&rect(4)~=0
                    idx0=find(xxx>=ox & xxx<=ox+wx);
                    temp=yyy(idx0);
                    idx1=find(temp>=oy & temp<=oy+hy);
                    idx2=idx0(idx1);
                    flgidx=[flgidx;idx2];
                else
                    break
                end
                plot(handle.hax1,xxx(flgidx),yyy(flgidx),'r*');
          end
          hold(handle.hax1,'off');
          flgidx=unique(flgidx);
          reuselist=data(flgidx,1);
          for i=1:length(reuselist)
              for j=1:length(rmlistname)
                  if(strcmp(rmlistname{j},reuselist{i}))
                      rmlistname(j)=[];
                      break;
                  end
              end
          end
    end
    function pick_callback_output(dummy1,dummy2)
        nsite=length(rmlistname);
        fid11=fopen(para.outputfilename,'w');
        fprintf(fid11,'%s\n','rmsite name');
        for i=1:nsite
            fprintf(fid11,'%s\n',rmlistname{i});
        end
        fclose(fid11);
    end
    function pick_callback_rhoplot(dummy1,dummy2)
        flgidx=null(1,1);
        handle.f2               =	figure('Toolbar','figure','Units','normalized','Position',[.1 .1 .8 .8]);
                                    set(handle.f2,'name','MT freq Pick','NumberTitle','off');
        handle.pb1=                 uicontrol(handle.f2,'Style','pushbutton','String','next_site','callback',@pick_callback_nextsite,'position', [.65 .95 .1 .04]);
        handle.pb2=                 uicontrol(handle.f2,'Style','pushbutton','String','next_comp','callback',@pick_callback_nextcomp,'Position', [.65 .905 .1 .04]);
        handle.pb10=                 uicontrol(handle.f2,'Style','pushbutton','String','prev_site','callback',@pick_callback_prevsite,'position', [.25 .95 .1 .04]);
        handle.pb11=                 uicontrol(handle.f2,'Style','pushbutton','String','prev_comp','callback',@pick_callback_prevcomp,'Position', [.25 .905 .1 .04]);
        handle.hax12             =	axes('pos', [.1 .1 .75 .35]);
                            box(handle.hax12,'on');
        handle.hax11              =	axes('pos', [.1 .5 .75 .35]);
         box(handle.hax11,'on');
         while para.value1~=1
                if para.value1==1
                    break;
                end
                rect=getrect(handle.hax1); 
                ox=rect(1);
                wx=rect(3);
                oy=rect(2);
                hy=rect(4);
                if wx~=0&&rect(4)~=0
                    idx0=find(xxx>=ox & xxx<=ox+wx);
                    temp=yyy(idx0);
                    idx1=find(temp>=oy & temp<=oy+hy);
                    idx2=idx0(idx1);
                    flgidx=[flgidx;idx2];
                else
                    break
                end
         end
          para.isite=flgidx(1);
          para.icomp=1;
    end
function pick_callback_zxycomp(dummy1,dummy2)
        % plot the zxy comp of one site
        ii=para.isite;
        inper=length(data{ii,5});
        rho=zeros(inper,4);phase=zeros(inper,4);
        rhoerr=zeros(inper,4);pherr=zeros(inper,4);
        per=data{ii,5};
        rho(:,1)=data{ii,6};
        rho(:,2)=data{ii,8};
        rho(:,3)=data{ii,10};
        rho(:,4)=data{ii,12};
        phase(:,1)=data{ii,7};
        phase(:,2)=data{ii,9};
        phase(:,3)=data{ii,11};
        phase(:,4)=data{ii,13};
        rhoerr(:,1)=sqrt(data{ii,14});
        rhoerr(:,2)=sqrt(data{ii,15});
        rhoerr(:,3)=sqrt(data{ii,16});
        rhoerr(:,4)=sqrt(data{ii,17});
        pherr(:,1)=sqrt(data{ii,18});
        pherr(:,2)=sqrt(data{ii,19});
        pherr(:,3)=sqrt(data{ii,20});
        pherr(:,4)=sqrt(data{ii,21});
    % plot
        jj=para.icomp;
        h1=loglog(handle.hax11 ,per,rho(:,jj),'o','MarkerFaceColor',colortype{jj},'MarkerEdgeColor',colortype{jj});
        legend(h1,labeltyep{jj},'Location','northwest','autoupdate','off');
        title(handle.hax11 ,['site: ',data{ii,1}])
        ylabel(handle.hax11 ,'apparent resistivity/ {\Omega\cdot}m');
        hold(handle.hax11,'on');
        myerrbar2(per,rho(:,jj),rhoerr(:,jj),colortype{jj},'rho',handle.hax11);
        selectindex=find(dataflag{ii,jj}==0);
        loglog(handle.hax11 ,per(selectindex),rho(selectindex,jj),'o','MarkerFaceColor','c','MarkerEdgeColor','c');
        hold(handle.hax11,'off');
        xmin=10^(floor(log10(min(per))));xmax=10^(ceil(log10(max(per))));
        ymin=10^(floor(log10(min(rho(:,jj)))));ymax=10^(ceil(log10(max(rho(:,jj)))));
        axis(handle.hax11 ,[xmin xmax ymin ymax]);
        grid(handle.hax11,'on')

    
        h2=semilogx(handle.hax12,per,phase(:,jj),'s','MarkerFaceColor',colortype{jj},'MarkerEdgeColor',colortype{jj});
        legend(h2,labeltyep{jj},'Location','northwest','autoupdate','off')
        xlabel(handle.hax12,'period(s)')
        ylabel(handle.hax12,'{\phi}  / {\circ}');
        hold(handle.hax12,'on') ;
        myerrbar2(per,phase(:,jj),pherr(:,jj),colortype{jj},'phase',handle.hax12);
        semilogx(handle.hax12,per(selectindex),phase(selectindex,jj),'s','MarkerFaceColor','c','MarkerEdgeColor','c')
        hold(handle.hax12,'off') ;
        ymin=-180;ymax=180;
        axis(handle.hax12,[xmin xmax ymin ymax]);    
        grid(handle.hax12,'on')
    end
    function pick_callback_txycomp(dummy1,dummy2)
         % plot the zxy comp of one site
        ii=para.isite;
        per=data{ii,5};
        % plot
        jj=para.icomp;
        h1=semilogx(handle.hax11 ,per,real(ZTdata{ii,jj+9-4}),'o','MarkerFaceColor',colortype{jj-4},'MarkerEdgeColor',colortype{jj-4});
        title(handle.hax11 ,['site: ',data{ii,1}])
        ylabel(handle.hax11 ,'real(Tzx)');
        hold(handle.hax11,'on');
        selectindex=find(dataflag{ii,jj}==0);
        loglog(handle.hax11,per(selectindex),real(ZTdata{ii,jj+9-4}(selectindex)),'o','MarkerFaceColor','c','MarkerEdgeColor','c')
        hold(handle.hax11,'off');
        grid(handle.hax11,'on')
        legend(h1,labeltyep{jj},'Location','northwest','autoupdate','off')
    

        h2=semilogx(handle.hax12,per,imag(ZTdata{ii,jj+9-4}),'s','MarkerFaceColor',colortype{jj-4},'MarkerEdgeColor',colortype{jj-4});
        xlabel(handle.hax12,'period(s)')
        ylabel(handle.hax12,'imag(Tzx)');
        hold(handle.hax12,'on') ;
        semilogx(handle.hax12,per(selectindex),imag(ZTdata{ii,jj+9-4}(selectindex)),'s','MarkerFaceColor','c','MarkerEdgeColor','c')
        hold(handle.hax12,'off') ;
        grid(handle.hax12,'on')
        legend(h2,labeltyep{jj},'Location','northwest','autoupdate','off')
    end
    function pick_callback_nextcomp(dummy1,dummy2)
        para.icomp=para.icomp+1;
        if para.icomp<=4;
            pick_callback_zxycomp
        elseif para.icomp<=6;
            pick_callback_txycomp
        else
            para.icomp=6;
            disp('This is last comp!')
            pick_callback_txycomp
        end
    end
    function pick_callback_prevcomp(dummy1,dummy2)
        para.icomp=para.icomp-1;
        if para.icomp>4;
            pick_callback_txycomp
        elseif para.icomp>0
            pick_callback_zxycomp
        else
            para.icomp=1;
            disp('This is first comp')
            pick_callback_zxycomp
        end
    end
    function pick_read_rmsitenamefile(dummy1,dummy2)
        fid=fopen(para.orirmsitename,'r');
        temp=fgetl(fid);
        i=1;
        tempcell=cell(1);
        while ~feof(fid)
            temp=fgetl(fid);
            tempcell{1}=temp;
            rmlistname=[tempcell;rmlistname];
            i=i+1;
        end
        fclose(fid);
      
    end
    function pick_singlefit(dummy1,dummy2)
        ifile1='../data/westdatong_snppart_T6w5_as.dat';
% inversion data
        ifile2='../westsnppart_T6w5_n1as_NLCG_107.dat';

[allData1,header1,units1,isign1,origin1,info1] = readZ_3D(ifile1);
[allData2,header2,units2,isign2,origin2,info2] = readZ_3D(ifile2);
% 
if (length(allData1{1}.siteLoc)~=length(allData2{1}.siteLoc))
    disp('wrong numbers in siteLoc');
    return
elseif (sum(sum(allData1{1}.siteLoc-allData2{1}.siteLoc))>1)
        disp('wrong location in siteLoc')
        return
end


   for i=1:length(allData1{1}.siteLoc)
       m=0;
       for j=1:length(allData1)
            if ~(isnan(allData1{j}.Z(i,1)))
                   m=m+1;
           for k=1:allData1{1}.nComp
              
               if (mod(k,2)==0)
                   res{i}.z(m,k)=imag(allData1{j}.Z(i,k/2)-allData2{j}.Z(i,k/2));
               else
                   res{i}.z(m,k)=real(allData1{j}.Z(i,(k+1)/2)-allData2{j}.Z(i,(k+1)/2));
               end
               end
           end
       end
   end
    for i=1:length(allData1{1}.siteLoc)
        m=0;
       for j=1:length(allData1)
           if ~(isnan(allData1{j}.Z(i,1)))
                   m=m+1;
           for k=1:allData1{1}.nComp
                
               if (mod(k,2)==0)
                   Nres{i}.z(m,k)=res{i}.z(m,k)/allData1{j}.Zerr(i,k/2)^2;
               else
                   Nres{i}.z(m,k)=res{i}.z(m,k)/allData1{j}.Zerr(i,(k+1)/2)^2;
               end
                end
       end
       end
    end
    sswhole=0;
    ss=zeros(length(allData1{1}.siteLoc),1);
      for i=1:length(allData1{1}.siteLoc)
       for j=1:size(res{i}.z,1)
           for k=1:allData1{1}.nComp
          sswhole=sswhole+res{i}.z(j,k)*Nres{i}.z(j,k);
          ss(i)=ss(i)+res{i}.z(j,k)*Nres{i}.z(j,k);
       end
       end
    end
    
    tpoint=0;
    for i=1:length(ss)
    ss(i)=sqrt(ss(i)/size(res{i}.z,1)/allData1{1}.nComp);
    tpoint=tpoint+size(res{i}.z,1)*allData1{1}.nComp;
    end
    sswhole=sqrt(sswhole/tpoint);
    for i=1:size(data,1)
        for j=1:size(allData1{1}.siteChar,1)
            if strcmp(strtrim(allData1{1}.siteChar(j,:)),data{i,1})
                ssdata(i)=ss(j);
                break
            end
        end
    end
    end
end