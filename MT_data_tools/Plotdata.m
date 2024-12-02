iflie = '../Modular_NLCG_070.rho';

x_start = data_x_list(1)/1000;
x_end = data_x_list(end)/1000;

y_start = data_y_list(1)/1000;
y_end = data_y_list(end)/1000;

xyztype = 'XOY';
figure;
tiledlayout(4,4);
z_list = logspace(-0.5,1.5,16);
for i = 1:16
    ax = nexttile;
    xyzdir = z_list(i);
    maxis = [y_start y_end x_start x_end];
    plotws3d(iflie,xyztype,xyzdir,maxis)
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
