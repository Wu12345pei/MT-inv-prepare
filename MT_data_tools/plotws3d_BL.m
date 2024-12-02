%»æÖÆ3Î¬ÇÐÆ¬
function plotws3d_BL(ifile,xyztype,xyzdir,maxis,ori2)
%x,yÎªÇÐÆ¬Î»ÖÃ
if strcmp(xyztype,'XOZ')
    ydir=xyzdir;
elseif strcmp(xyztype,'YOZ')
    xdir=xyzdir;
elseif strcmp(xyztype,'XOY')
    zdir=xyzdir;
end
[dx,dy,dz,rho,nzAir,type,origin,rotation] = read_WS3d_model(ifile);
if strcmp(type,'LINEAR')
    rho=log10(rho);
elseif strcmp(type,'LOGE')
rho=log10(exp(rho));
end
sumx=origin(1);
sumy=origin(2);
sumz=origin(3);
x(1)=origin(1);
y(1)=origin(2);
z(1)=origin(3);
for i=1:length(dx)
    sumx=sumx+dx(i);
    x(i+1)=sumx;
    
end
for i=1:length(dy)
    sumy=sumy+dy(i);
    y(i+1)=sumy;
    
end
for i=1:length(dz)
    sumz=sumz+dz(i);
    z(i+1)=sumz;
end
[x0 y0]=GaussProWGS84(ori2(1),ori2(2));
x=x+x0;
y=y+y0;
for i=1:length(x)
    [B(i), ~]=GaussProWGS84inv(x(i),y0);
end
for i=1:length(y)
    [~,L(i)]=GaussProWGS84inv(x0,y(i));
end
x=(x/1000);
y=(y/1000);
z=(z/1000);

%À©³ä
rho1=ones(length(x),length(y),length(z))*2;
rho1(1:length(dx),1:length(dy),1:length(dz))=rho;
if strcmp(xyztype,'YOZ')
    if xdir<B(1)||xdir>B(end)
        disp('error : error range to plot')
        return;
    end
    xdir=find(B>=xdir,1,'first')-1
    figure
       set(gcf,'color','w');
    slice1=squeeze(rho1(xdir,:,:));
    h1=pcolor(L,z,slice1');
    axis(maxis)
    set(h1, 'LineStyle','none');
    xlabel('E(\circ)')
    ylabel('Z(km)')
    set(gca,'ydir','reverse');
set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
    colormap(flipud(jet));
    cbar=colorbar;
      caxis([0,3.6]);
    set(cbar,'YTickLabel',{'1','10','100','1000'});
    set(cbar,'YTick',(0:1:3));
    set(get(cbar,'Title'),'string','\Omegam')
elseif strcmp(xyztype,'XOZ')
    if ydir<L(1)||ydir>L(end)
        disp('error : error range to plot')
        return;
    end
    ydir=find(L>=ydir,1,'first')-1
    figure
       set(gcf,'color','w');
    slice2=squeeze(rho1(:,ydir,:));
    h2=pcolor(B,z,slice2');
    axis(maxis)
    set(h2, 'LineStyle','none');
    xlabel('N(\circ)')
    ylabel('Z(km)')
    set(gca,'ydir','reverse');
set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
    colormap(flipud(jet));
    cbar=colorbar;
      caxis([0,3.6]);
    set(cbar,'YTickLabel',{'1','10','100','1000'});
    set(cbar,'YTick',(0:1:3));
    set(get(cbar,'Title'),'string','\Omegam')
elseif strcmp(xyztype,'XOY')
     if zdir<z(1)||zdir>z(end)
        disp('error : error range to plot')
        return;
    end
    zdir=find(z>=zdir,1,'first')-1
    figure
    set(gcf,'color','w');
    slice3=squeeze(rho1(:,:,zdir));
    h3=pcolor(L,B,slice3);
    axis(maxis)
    set(h3, 'LineStyle','none');
    xlabel('E(\circ)')
    ylabel('N(\circ)')
set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
    colormap(flipud(jet(64)));
    cbar=colorbar;
      caxis([0,3.6]);
    set(cbar,'YTickLabel',{'1','10','100','1000'});
    set(cbar,'YTick',(0:1:3));
    set(get(cbar,'Title'),'string','\Omegam')
end