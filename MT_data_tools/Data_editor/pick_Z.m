function pick_Z
clear;close all;clc
%% globel parameter
para.RPlist='../BYKL_DGDRRP';
para.ZTlist='../BYKL_DGDRZT';
para.flagofile='../BYKL_DGDR_final.dat';
para.cwflag=1;
% output file name
para.ofile='../BYKL_DGDR_final.dat';
%% globel iteration var
para.isite=1;
para.icomp=1;
para.value1=0;
para.value2=0;
para.value3=0;
%% load data
[RPpath,data]=readOriRP(para.RPlist);
[ZTpath,ZTdata]=readOriZT(para.ZTlist);
Ns=size(data,1);
dataflag=cell(Ns,6);
chara='full';
colortype={'m';'r';'b';'k'};
labeltyep={'xx';'xy';'yx';'yy';'tx';'ty'};
sidx=1:1:Ns;
% set default values in dataflag
if para.cwflag==0
        for i=1:Ns
        nper=length(data{i,5});
        for j=1:6
        dataflag{i,j}=ones(nper,1);
        end
end
 elseif para.cwflag==1
     [dataflag]=ReadFlag(para.flagofile,6);
     % del freq
     dataflag(:,1)=[];
end
 
%% set default UI parameter
warning('off');
set(0,'defaultaxesfontsize',12);
set(0,'defaultaxesfontname','Helvetica');
set(0,'DefaultaxesFontweight','Bold');
set(0,'defaulttextfontsize',12);
set(0,'defaulttextfontname','Helvetica');
set(0,'DefaulttextFontweight','Bold');
set(0,'DefaultUicontrolFontsize',12);
set(0,'DefaultUicontrolFontname','Helvetica');
set(0,'DefaultUicontrolFontweight','Bold');
set(0,'DefaultUipanelFontsize',12);
set(0,'DefaultUipanelFontname','Helvetica');
set(0,'DefaultUipanelFontweight','Bold');
set(0,'DefaultUicontrolUnits','normalized');
set(0,'Defaultlinelinewidth',2);
%% 
% new figure
handle.f1               =	figure('Toolbar','figure','Units','normalized','Position',[.1 .1 .8 .8]);
                            set(handle.f1,'name','MT freq Pick','NumberTitle','off');
% % new two axes                           
handle.hax2             =	axes('pos', [.1 .1 .75 .35]);
                            box(handle.hax2,'on');
handle.hax1              =	axes('pos', [.1 .5 .75 .35]);
                            box(handle.hax1,'on');
handle.txt0=                uicontrol(handle.f1,'String','MT freq Pick v0.1','position', [.4 .95 .2 .04]);
handle.txt1=                uicontrol(handle.f1,'String','start','callback',@pick_callback_fisrtsite,'position', [.4 .905 .2 .04]);
handle.pb1=                 uicontrol(handle.f1,'Style','pushbutton','String','next_site','callback',@pick_callback_nextsite,'position', [.65 .95 .1 .04]);
handle.pb2=                 uicontrol(handle.f1,'Style','pushbutton','String','next_comp','callback',@pick_callback_nextcomp,'Position', [.65 .905 .1 .04]);
handle.pb10=                 uicontrol(handle.f1,'Style','pushbutton','String','prev_site','callback',@pick_callback_prevsite,'position', [.25 .95 .1 .04]);
handle.pb11=                 uicontrol(handle.f1,'Style','pushbutton','String','prev_comp','callback',@pick_callback_prevcomp,'Position', [.25 .905 .1 .04]);
% three panels
pick_panel              =   uipanel('parent', handle.f1,'title', 'Pick', 'pos', [0.86 .5 .14 .4]);
handle.pb3=                 uicontrol(pick_panel ,'Style','pushbutton','String','start_ax1','callback',@pick_callback_dropax1,'Position',[0.05 .92 .9 .08 ]);
% % % we use single-click manner to stop the pick process, so there is no end_pick callback function now
handle.pb4=                 uicontrol(pick_panel ,'Style','text','String','single-click to stop','Position',[0.05 .72 .9 .08 ]);

handle.pb5=                 uicontrol(pick_panel ,'Style','pushbutton','String','start_ax2','callback',@pick_callback_dropax2,'Position',[0.05 .52 .9 .08 ]);
handle.pb6=                 uicontrol(pick_panel ,'Style','text','String','single-click to stop','Position',[0.05 .32 .9 .08 ]);
recover_panel=              uipanel('parent', handle.f1,'title', 'Recover', 'pos', [0.86 .05 .14 .38]);
handle.pb7=                 uicontrol(recover_panel ,'Style','pushbutton','String','start_ax1','callback',@pick_callback_reuseax1,'Position',[0.05 .6 .9 .1]);
%handle.pb8=                 uicontrol(recover_panel ,'Style','pushbutton','String','start_ax1','Position',[0.05 .4 .9 .1]);
handle.pb9=                 uicontrol(handle.f1,'style','pushbutton','string','save right now','callback',@pick_callback_saveflag,'position', [.05 .95 .1 .04]);

%% call back functions
%% 
    function pick_callback_saveflag(dummy1,dummy2)
        % overwrite!!!
        WriteFlag(para.ofile,data,dataflag,6);
    end
    function pick_callback_reuseax1(dummy1,dummy2)
        if para.icomp<=4
            pick_callback_reuserho
        else
            pick_callback_reusetz
        end
    end
    function pick_callback_reuserho(dummy1,dummy2)
            ii=para.isite;
            jj=para.icomp;
            flgidx2=null(1,1);
            inper=length(data{ii,5});
            rho=zeros(inper,4);
            phase=zeros(inper,4);
            per=data{ii,5};
            rho(:,1)=data{ii,6};
            rho(:,2)=data{ii,8};
            rho(:,3)=data{ii,10};
            rho(:,4)=data{ii,12};
            phase(:,1)=data{ii,7};
            phase(:,2)=data{ii,9};
            phase(:,3)=data{ii,11};
            phase(:,4)=data{ii,13};
            hold(handle.hax1,'on');
            hold(handle.hax2,'on');
            while para.value3~=1
                if para.value3==1
                    break;
                end
                rect=getrect(handle.hax1); 
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
                else
                    break;
                end
                loglog(handle.hax1,per(flgidx2),rho(flgidx2,jj),'o','MarkerFaceColor',colortype{jj},'MarkerEdgeColor',colortype{jj});
                semilogx(handle.hax2,per(flgidx2),phase(flgidx2,jj),'s','MarkerFaceColor',colortype{jj},'MarkerEdgeColor',colortype{jj})
            end
            flgidx2=unique(flgidx2);
            hold(handle.hax1,'off');
            hold(handle.hax2,'off');
            delt=dataflag{ii,jj};
            if ~isempty(flgidx2)
                delt(flgidx2)=1;
            end
            dataflag{ii,jj}=delt;
  end

    function pick_callback_reusetz(dummy1,dummy2)
        ii=para.isite;
        jj=para.icomp;
        per=data{ii,5};
        flgidx2=null(1,1);
        hold(handle.hax1,'on');
        hold(handle.hax2,'on');
        while para.value3~=1
            if para.value3==1
                break;
            end
            rect=getrect(handle.hax1); 
            ox=rect(1);
            wx=rect(3);
            oy=rect(2);
            hy=rect(4);
            if wx~=0&&rect(4)~=0
                idx0=find(per>=ox & per<=ox+wx);
                temp=real(ZTdata{ii,jj+9-4}(idx0));
                idx1=find(temp>=oy & temp<=oy+hy);
                idx2=idx0(idx1);
                flgidx2=[flgidx2;idx2];
            else
                break;
            end
            semilogx(handle.hax1,per(flgidx2),real(ZTdata{ii,jj+9-4}(flgidx2)),'o','MarkerFaceColor',colortype{jj-4},'MarkerEdgeColor',colortype{jj-4});
            semilogx(handle.hax2,per(flgidx2),imag(ZTdata{ii,jj+9-4}(flgidx2)),'s','MarkerFaceColor',colortype{jj-4},'MarkerEdgeColor',colortype{jj-4});
        end 
        flgidx2=unique(flgidx2);
        hold(handle.hax1,'off');
        hold(handle.hax2,'off');
        delt= dataflag{ii,jj};
        if ~isempty(flgidx2)
            delt(flgidx2)=1;
        end
        dataflag{ii,jj}=delt;
    end
    function pick_callback_dropax1(dummy1,dummy2)
        if para.icomp<=4
            pick_callback_droprho
        else
            pick_callback_droprealtz
        end
    end
    function pick_callback_dropax2(dummy1,dummy2)
        if para.icomp<=4
            pick_callback_dropphase
        else
            pick_callback_dropimagtz
        end
    end
    function pick_callback_droprho(dummy1,dummy2)
          ii=para.isite;
          jj=para.icomp;
          flgidx=null(1,1);
          inper=length(data{ii,5});
            rho=zeros(inper,4);
            phase=zeros(inper,4);
            per=data{ii,5};
            rho(:,1)=data{ii,6};
            rho(:,2)=data{ii,8};
            rho(:,3)=data{ii,10};
            rho(:,4)=data{ii,12};
            phase(:,1)=data{ii,7};
            phase(:,2)=data{ii,9};
            phase(:,3)=data{ii,11};
            phase(:,4)=data{ii,13};
            hold(handle.hax1,'on');
            hold(handle.hax2,'on');
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
                    idx0=find(per>=ox & per<=ox+wx);
                    temp=rho(idx0,jj);
                    idx1=find(temp>=oy & temp<=oy+hy);
                    idx2=idx0(idx1);
                    flgidx=[flgidx;idx2];
                else
                    break
                end
                loglog(handle.hax1,per(flgidx),rho(flgidx,jj),'o','MarkerFaceColor','c','MarkerEdgeColor','c');
                semilogx(handle.hax2,per(flgidx),phase(flgidx,jj),'s','MarkerFaceColor','c','MarkerEdgeColor','c')
            end 
        hold(handle.hax1,'off');
        hold(handle.hax2,'off');
        flgidx=unique(flgidx);
        delt=dataflag{ii,jj};
        if ~isempty(flgidx)
            delt(flgidx)=0;
        end
        dataflag{ii,jj}=delt;
    end
    function pick_callback_dropphase(dummy1,dummy2)
            ii=para.isite;
            jj=para.icomp;
            flgidx=null(1,1);
            inper=length(data{ii,5});
            rho=zeros(inper,4);phase=zeros(inper,4);
            per=data{ii,5};
            rho(:,1)=data{ii,6};
            rho(:,2)=data{ii,8};
            rho(:,3)=data{ii,10};
            rho(:,4)=data{ii,12}; 
            phase(:,1)=data{ii,7};
            phase(:,2)=data{ii,9};
            phase(:,3)=data{ii,11};
            phase(:,4)=data{ii,13};
            hold(handle.hax2,'on');
            hold(handle.hax1,'on');
            while para.value2~=1
                if para.value2==1
                    break;
                end
                rect=getrect(handle.hax2);
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
                else
                    break;
                end
            loglog(handle.hax1,per(flgidx),rho(flgidx,jj),'o','MarkerFaceColor','c','MarkerEdgeColor','c');       
            semilogx(handle.hax2,per(flgidx),phase(flgidx,jj),'s','MarkerFaceColor','c','MarkerEdgeColor','c')
            end 
            hold(handle.hax1,'off');
            hold(handle.hax2,'off');
            flgidx=unique(flgidx);
            delt=dataflag{ii,jj};
            if ~isempty(flgidx)
                delt(flgidx)=0;
            end
             dataflag{ii,jj}=delt;
    end  
    function pick_callback_droprealtz(dummy1,dummy2)
        ii=para.isite;
        jj=para.icomp;
        per=data{ii,5};
        flgidx=null(1,1);
        hold(handle.hax1,'on');
        hold(handle.hax2,'on');
        while para.value1~=1
            rect=getrect(handle.hax1); 
            ox=rect(1);
            wx=rect(3);
            oy=rect(2);
            hy=rect(4);
            if wx~=0&&rect(4)~=0
                idx0=find(per>=ox & per<=ox+wx);
                temp=real(ZTdata{ii,jj+9-4}(idx0));
                idx1=find(temp>=oy & temp<=oy+hy);
                idx2=idx0(idx1);
                flgidx=[flgidx;idx2];
            else
                break
            end
        semilogx(handle.hax1,per(flgidx),real(ZTdata{ii,jj+9-4}(flgidx)),'o','MarkerFaceColor','c','MarkerEdgeColor','c');
        semilogx(handle.hax2,per(flgidx),imag(ZTdata{ii,jj+9-4}(flgidx)),'s','MarkerFaceColor','c','MarkerEdgeColor','c');    
        end 
        flgidx=unique(flgidx);
        hold(handle.hax1,'off');
        hold(handle.hax2,'off');
        delt= dataflag{ii,jj};
        if ~isempty(flgidx)
            delt(flgidx)=0;
        end
        dataflag{ii,jj}=delt;

    end
    function pick_callback_dropimagtz(dummy1,dummy2)
        ii=para.isite;
        jj=para.icomp;
        per=data{ii,5};
        flgidx=null(1,1);
        hold(handle.hax1,'on');
        hold(handle.hax2,'on');
        while para.value2~=1;
            rect=getrect(handle.hax2);
            ox=rect(1);
            wx=rect(3);
            oy=rect(2);
            hy=rect(4);
            if wx~=0&&rect(4)~=0
                idx0=find(per>=ox & per<=ox+wx);
                temp=imag(ZTdata{ii,jj+9-4}(idx0));
                idx1=find(temp>=oy & temp<=oy+hy);
                idx2=idx0(idx1);
                flgidx=[flgidx;idx2];
            else
                break;
            end
        semilogx(handle.hax1,per(flgidx),real(ZTdata{ii,jj+9-4}(flgidx)),'o','MarkerFaceColor','c','MarkerEdgeColor','c');
        semilogx(handle.hax2,per(flgidx),imag(ZTdata{ii,jj+9-4}(flgidx)),'s','MarkerFaceColor','c','MarkerEdgeColor','c');
        end
        hold(handle.hax1,'off');
        hold(handle.hax2,'off');
        flgidx=unique(flgidx);
        delt= dataflag{ii,jj};
        if ~isempty(flgidx)
            delt(flgidx)=0;
        end
        dataflag{ii,jj}=delt;
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
        h1=loglog(handle.hax1 ,per,rho(:,jj),'o','MarkerFaceColor',colortype{jj},'MarkerEdgeColor',colortype{jj});
        legend(h1,labeltyep{jj},'Location','northwest','autoupdate','off');
        title(handle.hax1 ,['site: ',data{ii,1}])
        ylabel(handle.hax1 ,'apparent resistivity/ {\Omega\cdot}m');
        hold(handle.hax1,'on');
        myerrbar2(per,rho(:,jj),rhoerr(:,jj),colortype{jj},'rho',handle.hax1);
        selectindex=find(dataflag{ii,jj}==0);
        loglog(handle.hax1 ,per(selectindex),rho(selectindex,jj),'o','MarkerFaceColor','c','MarkerEdgeColor','c');
        hold(handle.hax1,'off');
        xmin=10^(floor(log10(min(per))));xmax=10^(ceil(log10(max(per))));
        ymin=10^(floor(log10(min(rho(:,jj)))));ymax=10^(ceil(log10(max(rho(:,jj)))));
        axis(handle.hax1 ,[xmin xmax ymin ymax]);
        grid(handle.hax1,'on')

    
        h2=semilogx(handle.hax2,per,phase(:,jj),'s','MarkerFaceColor',colortype{jj},'MarkerEdgeColor',colortype{jj});
        legend(h2,labeltyep{jj},'Location','northwest','autoupdate','off')
        xlabel(handle.hax2,'period(s)')
        ylabel(handle.hax2,'{\phi}  / {\circ}');
        hold(handle.hax2,'on') ;
        myerrbar2(per,phase(:,jj),pherr(:,jj),colortype{jj},'phase',handle.hax2);
        semilogx(handle.hax2,per(selectindex),phase(selectindex,jj),'s','MarkerFaceColor','c','MarkerEdgeColor','c')
        hold(handle.hax2,'off') ;
        ymin=-180;ymax=180;
        axis(handle.hax2,[xmin xmax ymin ymax]);    
        grid(handle.hax2,'on')
    end
    function pick_callback_txycomp(dummy1,dummy2)
         % plot the zxy comp of one site
        ii=para.isite;
        per=data{ii,5};
        % plot
        jj=para.icomp;
        h1=semilogx(handle.hax1 ,per,real(ZTdata{ii,jj+9-4}),'o','MarkerFaceColor',colortype{jj-4},'MarkerEdgeColor',colortype{jj-4});
        title(handle.hax1 ,['site: ',data{ii,1}])
        ylabel(handle.hax1 ,'real(Tzx)');
        hold(handle.hax1,'on');
        selectindex=find(dataflag{ii,jj}==0);
        loglog(handle.hax1,per(selectindex),real(ZTdata{ii,jj+9-4}(selectindex)),'o','MarkerFaceColor','c','MarkerEdgeColor','c')
        hold(handle.hax1,'off');
        grid(handle.hax1,'on')
        legend(h1,labeltyep{jj},'Location','northwest','autoupdate','off')
    

        h2=semilogx(handle.hax2,per,imag(ZTdata{ii,jj+9-4}),'s','MarkerFaceColor',colortype{jj-4},'MarkerEdgeColor',colortype{jj-4});
        xlabel(handle.hax2,'period(s)')
        ylabel(handle.hax2,'imag(Tzx)');
        hold(handle.hax2,'on') ;
        semilogx(handle.hax2,per(selectindex),imag(ZTdata{ii,jj+9-4}(selectindex)),'s','MarkerFaceColor','c','MarkerEdgeColor','c')
        hold(handle.hax2,'off') ;
        grid(handle.hax2,'on')
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
    function pick_callback_prevsite(dummy1,dummy2)
        para.isite=para.isite-1;
        para.icomp=1;
        if para.isite>0
            pick_callback_zxycomp
        else
            para.isite=1;
            pick_callback_zxycomp
            disp('This is first site!')
        end
    end
    function pick_callback_fisrtsite(dummy1,dummy2)
        para.isite=1;
        para.icomp=1;
        pick_callback_zxycomp
    end
    function pick_callback_nextsite(dummy1,dummy2)
        para.isite=para.isite+1;
        para.icomp=1;
        if para.isite<Ns
            pick_callback_zxycomp
        else 
            pick_callback_lastsite
        end      
    end
    function pick_callback_lastsite(dummy1,dummy2)
        para.isite=Ns;
        para.icomp=1;
        pick_callback_zxycomp
        disp('This is last site!')
    end

end