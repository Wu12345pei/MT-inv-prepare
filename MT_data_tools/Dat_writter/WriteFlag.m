function WriteFlag(filename,data,dataflag,idnum)

fidout=fopen(filename,'w');
% % the format of dataflag cell
% sitename,nperiod 
% period,flagxx,flagxy,flagyx,flagyy;
ns=size(dataflag,1);
fprintf(fidout,'Nsite=%d\n',ns);
if idnum==4;
for i=1:ns
    fprintf(fidout,'SiteName=%s  nperiod=%d\n',data{i,1},length(data{i,5}));
    fprintf(fidout,'period  flagxx  flagxy  flagyx  flagyy\n');
    for j=1:length(data{i,5})
        fprintf(fidout,'%10.5f %d %d %d %d\n',...
            data{i,5}(j),dataflag{i,1}(j),dataflag{i,2}(j),dataflag{i,3}(j),dataflag{i,4}(j));
    end
end
elseif idnum==2;
    for i=1:ns
    fprintf(fidout,'SiteName=%s  nperiod=%d\n',data{i,1},length(data{i,5}));
    fprintf(fidout,'period  flagxx  flagxy  flagyx  flagyy\n');
    for j=1:length(data{i,5})
        fprintf(fidout,'%10.5f %d %d\n',...
            data{i,5}(j),dataflag{i,1}(j),dataflag{i,2}(j));
    end
    end
elseif idnum==6;
    for i=1:ns
    fprintf(fidout,'SiteName=%s  nperiod=%d\n',data{i,1},length(data{i,5}));
    fprintf(fidout,'period  flagxx  flagxy  flagyx  flagyy flagtx flagty\n');
    for j=1:length(data{i,5})
        fprintf(fidout,'%10.5f %d %d %d %d %d %d\n',data{i,5}(j),dataflag{i,1}(j),dataflag{i,2}(j),dataflag{i,3}(j),dataflag{i,4}(j),dataflag{i,5}(j),dataflag{i,6}(j));
    end
    end
end
fclose(fidout);