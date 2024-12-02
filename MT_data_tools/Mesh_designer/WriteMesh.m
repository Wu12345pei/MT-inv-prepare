ws_name = '../pr.ws';
rho = 4.605*ones(size(x_cell_sizes,2),size(y_cell_sizes,2),size(z_cell_sizes,2));
origin = [0 0 0];
rotation = 0;
type = 'LOGE';
nzAir = 1;
status = write_WS3d_model(ws_name,x_cell_sizes,y_cell_sizes,z_cell_sizes,rho,nzAir,type,origin,rotation);