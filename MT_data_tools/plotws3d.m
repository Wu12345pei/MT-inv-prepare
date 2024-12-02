
function plotws3d(ifile,xyztype,xyzdir,maxis)

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
x=(x/1000);
y=(y/1000);
z=(z/1000);

%À©³ä
rho1=ones(length(x),length(y),length(z))*2;
rho1(1:length(dx),1:length(dy),1:length(dz))=rho;
if strcmp(xyztype,'YOZ')
    if xdir<x(1)||xdir>x(end)
        disp('error : error range to plot')
        return;
    end
    xdir=find(x>=xdir,1,'first')-1
    figure
    slice1=squeeze(rho1(xdir,:,:));
    h1=pcolor(y,z,slice1');
    axis(maxis)
    %shading interp
    set(h1, 'LineStyle','none');
    xlabel('Y(km)')
    ylabel('Z(km)')
    %title(ifile)
    set(gca,'ydir','reverse');
    set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
    colormap(flipud(jet));
    cbar=colorbar;
        caxis([0,3.6]);
    %    caxis([0,4]);
    set(cbar,'YTickLabel',{'10','100','1000'});
    set(cbar,'YTick',(1:1:3));
    set(get(cbar,'Title'),'string','\Omegam')
elseif strcmp(xyztype,'XOZ')
    if ydir<y(1)||ydir>y(end)
        disp('error : error range to plot')
        return;
    end
    ydir=find(y>=ydir,1,'first')-1;
    slice2=squeeze(rho1(:,ydir,:));
    h2=pcolor(x,z,slice2');
    axis(maxis)
    set(h2, 'LineStyle','none');
    xlabel('X(km)')
    ylabel('Z(km)')
    %title(ifile)
    set(gca,'ydir','reverse');
    set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
    colormap(flipud(jet));
    cbar=colorbar;
        caxis([0,3.6]);
    %  caxis([0,4]);
    set(cbar,'YTickLabel',{'10','100','1000'});
    set(cbar,'YTick',(1:1:3));
    set(get(cbar,'Title'),'string','\Omegam')
elseif strcmp(xyztype,'XOY')
     if zdir<z(1)||zdir>z(end)
        disp('error : error range to plot')
        return;
    end
    zdir=find(z>=zdir,1,'first')-1;
    h = z(zdir)
    slice3=squeeze(rho1(:,:,zdir));
    h3=pcolor(y,x,slice3);
    axis(maxis)
    %shading interp
    set(h3, 'LineStyle','none');
    xlabel('Y(km)')
    ylabel('X(km)')
    title(sprintf('Depth: %.2f km', h))
    set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
    colormap(flipud(jet));
    cbar=colorbar;
    caxis([0,3.6]);
    %  caxis([0,4]);
    set(cbar,'YTickLabel',{'10','100','1000'});
    set(cbar,'YTick',(1:1:3));
    set(get(cbar,'Title'),'string','\Omegam')
end