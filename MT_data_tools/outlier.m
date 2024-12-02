%*******************************************************************************
% Aims:
%     mark the outliers in the xx,xy,yx,yy in dataflag
% Usage:
%     use the function 'getrect',press 'complete' bottom and click figure  when the very site is completed
%********************************************************************************
% % the format of dataflag cell
% sitename,period,flagxx,flagxy,flagyx,flagyy;
clear; clc; %close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% cwflag==1,read the exsit dataflag file
cwflag=1;%default value=0
% datatype flag
RPfile='Merge104aRP';ZTfile='Merge104aZT';
% former flag file
flagofile='Mergeflag104a.dat';
% output file name
ofile='Mergeflag104a_2.dat'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[RPpath,data]=readOriRP(RPfile);
[ZTpath,ZTdata]=readOriZT(ZTfile);
Ns=size(data,1);
dataflag=cell(Ns,6);
chara='full';
colortype={'m';'r';'b';'k'};
labeltyep={'xx';'xy';'yx';'yy';'tx';'ty'};

 sidx=1:1:Ns;
 nsite=length(sidx);
 if cwflag==0
for i=1:Ns
    nper=length(data{i,5});
    for j=1:6
    dataflag{i,j}=ones(nper,1);
    end
end
 elseif cwflag==1
     [dataflag]=ReadFlag(flagofile,6);
     dataflag(:,1)=[];
 end
% data format: sitename,X,Y,Z,period  rhoxx  phsxx  rhoxy  phsxy rhoyx  phsx  rhoyy  phsyy varrxx  varpxx varrxy  varpxy varryx  varpyx varryy  varpyy
figure
for i=1:Ns
    nper=length(data{sidx(i),5});
            rho=zeros(nper,4);phase=zeros(nper,4);
            rhoerr=zeros(nper,4);pherr=zeros(nper,4);
            per=data{sidx(i),5};
            rho(:,1)=data{sidx(i),6};
            rho(:,2)=data{sidx(i),8};
            rho(:,3)=data{sidx(i),10};
            rho(:,4)=data{sidx(i),12};
            phase(:,1)=data{sidx(i),7};
            phase(:,2)=data{sidx(i),9};
            phase(:,3)=data{sidx(i),11};
            phase(:,4)=data{sidx(i),13};
            rhoerr(:,1)=sqrt(data{sidx(i),14});
            rhoerr(:,2)=sqrt(data{sidx(i),15});
            rhoerr(:,3)=sqrt(data{sidx(i),16});
            rhoerr(:,4)=sqrt(data{sidx(i),17});
            pherr(:,1)=sqrt(data{sidx(i),18});
            pherr(:,2)=sqrt(data{sidx(i),19});
            pherr(:,3)=sqrt(data{sidx(i),20});
            pherr(:,4)=sqrt(data{sidx(i),21});
%% rhoxx&phixx,rhoxy&phixy,rhoyx&phiyx,rhoyy&phiyy

for jj=1:6
%**********************************************
% color & label must be cell type
%*********************************************
if jj<=4
    ax1=subplot(2,1,1);
    h=loglog(per,rho(:,jj),'o','MarkerFaceColor',colortype{jj},'MarkerEdgeColor',colortype{jj});
    title(['site: ',data{sidx(i),1}])
    xlabel('period(s)')
    ylabel('apparent resistivity/ {\Omega\cdot}m');
    hold on;
    myerrbar1(per,rho(:,jj),rhoerr(:,jj),colortype{jj},'rho');
    selectindex=find(dataflag{sidx(i),jj}==0);
    loglog(ax1,per(selectindex),rho(selectindex,jj),'o','MarkerFaceColor','c','MarkerEdgeColor','c');
    hold off
    xmin=10^(floor(log10(min(per))));xmax=10^(ceil(log10(max(per))));
    ymin=10^(floor(log10(min(rho(:,jj)))));ymax=10^(ceil(log10(max(rho(:,jj)))));
    axis([xmin xmax ymin ymax]);
    grid on
    legend(h,labeltyep{jj},'Location','BestOutside','autoupdate','off')
    ax2=subplot(2,1,2);
    h=semilogx(per,phase(:,jj),'s','MarkerFaceColor',colortype{jj},'MarkerEdgeColor',colortype{jj});
    xlabel('period(s)')
    ylabel('{\phi}  / {\circ}');
    hold on;myerrbar1(per,phase(:,jj),pherr(:,jj),colortype{jj},'phase');
     semilogx(ax2,per(selectindex),phase(selectindex,jj),'s','MarkerFaceColor','c','MarkerEdgeColor','c')
     hold off
    ymin=-180;ymax=180;
    axis([xmin xmax ymin ymax]);    
    grid on
    legend(h,labeltyep{jj},'Location','BestOutside','autoupdate','off')
value1=0;
value2=0;
value3=0;
hui1=uicontrol(gcf,'Style','pushbutton','string','rm rho done','Callback','value1=1');
set(hui1,'Units','normalized','Position',[0 0 0.1 0.1]);
hui2=uicontrol(gcf,'Style','pushbutton','string','rm phase done','Callback','value2=1'); 
set(hui2,'Units','normalized','Position',[0.21 0 0.1 0.1]);
hui3=uicontrol(gcf,'Style','pushbutton','string','rc mode start','Callback','value3=1'); 
set(hui3,'Units','normalized','Position',[0.69 0 0.1 0.1]);
hui4=uicontrol(gcf,'Style','pushbutton','string','rc mode end','Callback','value3=2'); 
set(hui4,'Units','normalized','Position',[0.8 0 0.1 0.1]);
flgidx=null(1,1);
flgidx2=null(1,1);
   while value1~=1
       if value1==1
           break;
       end
        rect=getrect(ax1); 
        ox=rect(1);
        wx=rect(3);
        oy=rect(2);
        hy=rect(4);
        if wx~=0&&rect(4)~=0
            idx0=find(per>=ox & per<=ox+wx);
            temp=rho(idx0,jj);
            idx1=find(temp>=oy & temp<=oy+hy);
            idx2=idx0(idx1);
            flgidx=[flgidx;idx2];
        end 
        flgidx=unique(flgidx);
        hold(ax1,'on');
        loglog(ax1,per(flgidx),rho(flgidx,jj),'o','MarkerFaceColor','c','MarkerEdgeColor','c');
        hold(ax2,'on');
        semilogx(ax2,per(flgidx),phase(flgidx,jj),'s','MarkerFaceColor','c','MarkerEdgeColor','c')
   end
  while value2~=1
             if value2==1
           break;
       end
        rect=getrect(ax2);
        ox=rect(1);
        wx=rect(3);
        oy=rect(2);
        hy=rect(4);
        if wx~=0&&rect(4)~=0
            idx0=find(per>=ox & per<=ox+wx);
            temp=phase(idx0,jj);
            idx1=find(temp>=oy & temp<=oy+hy);
            idx2=idx0(idx1);
            flgidx=[flgidx;idx2];
        end 
        flgidx=unique(flgidx);
        hold(ax1,'on');
        loglog(ax1,per(flgidx),rho(flgidx,jj),'o','MarkerFaceColor','c','MarkerEdgeColor','c');
        hold(ax2,'on');
        semilogx(ax2,per(flgidx),phase(flgidx,jj),'s','MarkerFaceColor','c','MarkerEdgeColor','c')
  end  
  if value3~=0
  while value3~=2
       if value3==2
           break;
       end
        rect=getrect(ax1); 
        ox=rect(1);
        wx=rect(3);
        oy=rect(2);
        hy=rect(4);
        if wx~=0&&rect(4)~=0
            idx0=find(per>=ox & per<=ox+wx);
            temp=rho(idx0,jj);
            idx1=find(temp>=oy & temp<=oy+hy);
            idx2=idx0(idx1);
            flgidx2=[flgidx2;idx2];
        end 
        flgidx2=unique(flgidx2);
        hold(ax1,'on');
        loglog(ax1,per(flgidx2),rho(flgidx2,jj),'o','MarkerFaceColor',colortype{jj},'MarkerEdgeColor',colortype{jj});
        hold(ax2,'on');
        semilogx(ax2,per(flgidx2),phase(flgidx2,jj),'s','MarkerFaceColor',colortype{jj},'MarkerEdgeColor',colortype{jj})
  end
  end
  hold(ax1,'off');
    hold(ax2,'off');
  delt=dataflag{sidx(i),jj};
  if ~isempty(flgidx)
      delt(flgidx)=0;
  end
  if ~isempty(flgidx2)
      delt(flgidx2)=1;
  end
  dataflag{sidx(i),jj}=delt;
  clf 

else 
   ax1=subplot(2,1,1);
    h=semilogx(per,real(ZTdata{sidx(i),jj+9-4}),'o','MarkerFaceColor',colortype{jj-4},'MarkerEdgeColor',colortype{jj-4});
    hold on 
     selectindex=find(dataflag{sidx(i),jj}==0);
     loglog(ax1,per(selectindex),real(ZTdata{sidx(i),jj+9-4}(selectindex)),...
        'o','MarkerFaceColor','c','MarkerEdgeColor','c');
     hold off
    title(['site: ',data{sidx(i),1}])
    xlabel('period(s)')
    ylabel('real(Tzx)');
    xmin=10^(floor(log10(min(per))));xmax=10^(ceil(log10(max(per))));
    grid on
    legend(h,labeltyep{jj},'Location','BestOutside','autoupdate','off')
    ax2=subplot(2,1,2);
    h=semilogx(per,imag(ZTdata{sidx(i),jj+9-4}),'s','MarkerFaceColor',colortype{jj-4},'MarkerEdgeColor',colortype{jj-4});
    hold on 
            semilogx(ax2,per(selectindex),imag(ZTdata{sidx(i),jj+9-4}(selectindex)),...
        's','MarkerFaceColor','c','MarkerEdgeColor','c')
    hold off
    xlabel('period(s)')
    ylabel('imag(Tzx)');
    grid on
    legend(h,labeltyep{jj},'Location','BestOutside','autoupdate','off')
value1=0;
value2=0;
value3=0;
hui1=uicontrol(gcf,'Style','pushbutton','string','real complete','Callback','value1=1');
set(hui1,'Units','normalized','Position',[0 0 0.1 0.1]);
hui2=uicontrol(gcf,'Style','pushbutton','string','imag complete','Callback','value2=1'); 
set(hui2,'Units','normalized','Position',[0.21 0 0.1 0.1]);
hui3=uicontrol(gcf,'Style','pushbutton','string','rc mode start','Callback','value3=1'); 
set(hui3,'Units','normalized','Position',[0.69 0 0.1 0.1]);
hui4=uicontrol(gcf,'Style','pushbutton','string','rc mode end','Callback','value3=2'); 
set(hui4,'Units','normalized','Position',[0.8 0 0.1 0.1]);
flgidx=null(1,1);
   while value1~=1
        rect=getrect(ax1); 
        ox=rect(1);
        wx=rect(3);
        oy=rect(2);
        hy=rect(4);
        if wx~=0&&rect(4)~=0
            idx0=find(per>=ox & per<=ox+wx);
            temp=real(ZTdata{sidx(i),jj+9-4}(idx0));
            idx1=find(temp>=oy & temp<=oy+hy);
            idx2=idx0(idx1);
            flgidx=[flgidx;idx2];
        end 
        flgidx=unique(flgidx);
        hold(ax1,'on');
        semilogx(ax1,per(flgidx),real(ZTdata{sidx(i),jj+9-4}(flgidx)),...
        'o','MarkerFaceColor','c','MarkerEdgeColor','c');
        hold(ax2,'on');
        semilogx(ax2,per(flgidx),imag(ZTdata{sidx(i),jj+9-4}(flgidx)),...
        's','MarkerFaceColor','c','MarkerEdgeColor','c')
   end
  while value2~=1
        rect=getrect(ax2);
        ox=rect(1);
        wx=rect(3);
        oy=rect(2);
        hy=rect(4);
        if wx~=0&&rect(4)~=0
            idx0=find(per>=ox & per<=ox+wx);
            temp=imag(ZTdata{sidx(i),jj+9-4}(idx0));
            idx1=find(temp>=oy & temp<=oy+hy);
            idx2=idx0(idx1);
            flgidx=[flgidx;idx2];
        end 
                flgidx=unique(flgidx);
        hold(ax1,'on');
        semilogx(ax1,per(flgidx),real(ZTdata{sidx(i),jj+9-4}(flgidx)),...
        'o','MarkerFaceColor','c','MarkerEdgeColor','c');
        hold(ax2,'on');
        semilogx(ax2,per(flgidx),imag(ZTdata{sidx(i),jj+9-4}(flgidx)),...
        's','MarkerFaceColor','c','MarkerEdgeColor','c');
  end  
   if value3~=0
  while value3~=2
       if value3==2
           break;
       end
        rect=getrect(ax1); 
        ox=rect(1);
        wx=rect(3);
        oy=rect(2);
        hy=rect(4);
        if wx~=0&&rect(4)~=0
            idx0=find(per>=ox & per<=ox+wx);
             temp=imag(ZTdata{sidx(i),jj+9-4}(idx0));
             idx1=find(temp>=oy & temp<=oy+hy);
            idx2=idx0(idx1);
            flgidx2=[flgidx2;idx2];
        end 
                   flgidx2=unique(flgidx2);
        hold(ax1,'on');
        semilogx(ax1,per(flgidx2),real(ZTdata{sidx(i),jj+9-4}(flgidx2)),...
        'o','MarkerFaceColor',colortype{jj-4},'MarkerEdgeColor',colortype{jj-4});
        hold(ax2,'on');
        semilogx(ax2,per(flgidx2),imag(ZTdata{sidx(i),jj+9-4}(flgidx2)),...
        's','MarkerFaceColor',colortype{jj-4},'MarkerEdgeColor',colortype{jj-4});
  end
  end
   hold(ax1,'off');
    hold(ax2,'off');
  delt= dataflag{sidx(i),jj};
  if ~isempty(flgidx)
      delt(flgidx)=0;
  end
    if ~isempty(flgidx2)
      delt(flgidx2)=1;
  end
  dataflag{sidx(i),jj}=delt;
  clf
  
end
end

end
% write the data flag 
WriteFlag(ofile,data,dataflag,6);

