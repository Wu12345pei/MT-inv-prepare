 function [status]=WriteData3D(folder,fname,data)
%#########################################################
% Aim
%   Write the data to invert in files in ModEM format
% Input
%   data: read from MTPoineer result
%   type:   Full_Impedance
%           Off_Diagonal_Impedance
%           Full_Vertical_Components
%           Off_Diagonal_Rho_Phase
% the format of data cell
% sitename,X,Y,Z,period,Zxx,Zxy,Zyx,Zyy,Tzx,Tzy,Var_Zxx,Var_Zxy,Var_Zyx,Var_Zyy,Var_Tzx,Var_Tzy
%#########################################################
file=fullfile(folder,fname);
fid=fopen(file,'w+');
Nsite=size(data,1);
np=nan(Nsite,1);
for i=1:Nsite
    np(i)=size(data{i,5},2);
end
Nper=max(np); % the number of period
%  description <= 80 char in length
    header = '3D MT data from EDI2Z';
%  assume SI units by default as in ModEM; alternative is [mV/km]/[nT] 
    units = '[mV/km]/[nT]';
%  sign convention is -1 by default
    isign=1;
if isign == -1
    signstr = 'exp(-i\omega t)';
else
    signstr = 'exp(+i\omega t)';
end
%  get the origin from the first period
origin = [0 0 0];
%  get orientation from the first period
orientation = 0.0;
if size(data,2)>=13
    type='Full_Impedance';
   else
    type='Off_Diagonal_Impedance';
end


%  file header: the info line
fprintf(fid,'# %s\n',header);
%  data type header: comment, then six lines
comment = 'Period(s) Code GG_Lat GG_Lon X(m) Y(m) Z(m) Component Real Imag Error';
fprintf(fid,'# %s\n',comment);
fprintf(fid,'> %s\n',type);
fprintf(fid,'> %s\n',signstr);
fprintf(fid,'> %s\n',units);
fprintf(fid,'> %.2f\n',orientation);
fprintf(fid,'> %.3f %.3f\n',origin(1:2));
fprintf(fid,'> %d %d\n',Nper,Nsite);
switch type
    case  'Full_Impedance'
        ncomp=4;
        comp={'ZXX';'ZXY';'ZYX';'ZYY'};
       for i=1:Nsite
           for j=1:np(i)
               for k=1:ncomp
                    fprintf(fid,'%12.6E ',data{i,5}(j)); % period
                    fprintf(fid,'%s %8.3f %8.3f ',data{i,1},0.0, 0.0);
                    fprintf(fid,'%12.3f %12.3f %12.3f ',data{i,2},data{i,3},data{i,4}); % receiver x,y,z
                    if  size(data,2)==17
                        fprintf(fid,'%s %15.6E %15.6E %15.6E\n',comp{k},real(data{i,k+5}(j)),imag(data{i,k+5}(j)),(data{i,k+11}(j))); % data
                    elseif size(data,2)==13
                        fprintf(fid,'%s %15.6E %15.6E %15.6E\n',comp{k},real(data{i,k+5}(j)),imag(data{i,k+5}(j)),(data{i,k+9}(j))); % data
                    end
               end
           end
       end
    case 'Off_Diagonal_Impedance'
        ncomp=2;
        comp={'ZXY';'ZYX'};
       for i=1:Nsite
           for j=1:np(i)
               for k=1:ncomp
                    fprintf(fid,'%12.6E ',data{i,5}(j)); % period
                    fprintf(fid,'%s %8.3f %8.3f ',data{i,1},0.0, 0.0);
                    fprintf(fid,'%12.3f %12.3f %12.3f ',data{i,2},data{i,3},data{i,4}); % receiver x,y,z
                    fprintf(fid,'%s %15.6E %15.6E %15.6E\n',comp{k},real(data{i,k+6}(j)),imag(data{i,k+6}(j)),(data{i,k+12}(j))); % data
               end
           end
       end    
    otherwise
      errors('Unkonwn data type')  
end
if  size(data,2)==17
    type='Full_Vertical_Components';
    units = '[]';
    %  file header: the info line
    fprintf(fid,'# %s\n',header);
    %  data type header: comment, then six lines
    comment = 'Period(s) Code GG_Lat GG_Lon X(m) Y(m) Z(m) Component Real Imag Error';
    fprintf(fid,'# %s\n',comment);
    fprintf(fid,'> %s\n',type);
    fprintf(fid,'> %s\n',signstr);
    fprintf(fid,'> %s\n',units);
    fprintf(fid,'> %.2f\n',orientation);
    fprintf(fid,'> %.3f %.3f\n',origin(1:2));
    fprintf(fid,'> %d %d\n',Nper,Nsite);
    ncomp=2;
    comp={'TX';'TY'};
       for i=1:Nsite
           for j=1:np(i)
               for k=1:ncomp
                   
                    fprintf(fid,'%12.6E ',data{i,5}(j)); % period
                    fprintf(fid,'%s %8.3f %8.3f ',data{i,1},0.0, 0.0);
                    fprintf(fid,'%12.3f %12.3f %12.3f ',data{i,2},data{i,3},data{i,4}); % receiver x,y,z
                    fprintf(fid,'%s %15.6E %15.6E %15.6E\n',comp{k},real(data{i,k+9}(j)),imag(data{i,k+9}(j)),(data{i,k+15}(j))); % data
               end
           end
       end    
end
status=fclose(fid);
end