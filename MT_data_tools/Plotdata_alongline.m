function Plotdata_alongline(ifile)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
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

x_new = sqrt(x.^2+y.^2);
tan_theta = (max(y)-min(y)) / (max(x)-min(x));
for i = 1:length(x)
    y_suppose = tan_theta * (x(i)-x(1))+y(1);
    y_id=find(y>=y_suppose,1,'first')-1;
    for j =1:length(z)
        rho_line(i,j) = rho(i,y_id,j);
    end
end
h2=pcolor(x_new,z,rho_line);
axis(maxis)
set(h2, 'LineStyle','none');
xlabel('X_rotated(km)')
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
end
