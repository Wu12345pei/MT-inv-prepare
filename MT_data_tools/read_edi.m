%% read single edi file contained Z component directly
function [data]=read_edi(folder,fname)
[fid,whyerror]=fopen(fullfile(folder,fname),'r');
if fid<0,disp(whyerror);end
% while true
%     tmp=strtrim(fgetl(fid));
%     if ~isempty(strfind(tmp,'DATAID'))
%         if ~isempty(strfind(tmp,'"'));
%             delt=sscanf(tmp,'DATAID="%s"');
%             data.sitename=delt(1:length(delt)-1);
%         else
%             data.sitename=sscanf(tmp,'DATAID=%s');
%         end
%         break;
%     end
% end
data.sitename=fname(1:end-4);
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'LAT'))
        delt(1:3)=sscanf(tmp,'LAT=%f:%f:%f');
        data.lat=delt(1)+delt(2)/60+delt(3)/3600;
        break;    
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'LONG'))
        delt(1:3)=sscanf(tmp,'LONG=%f:%f:%f');
        data.lon=delt(1)+delt(2)/60+delt(3)/3600;
        break;    
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'NFREQ'))
        nfreq=sscanf(tmp,'NFREQ=%d');
        break;
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>FREQ'))
        data.freq=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>ZXXR'))
        data.ZXXR=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>ZXXI'))
        data.ZXXI=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>ZXX.VAR'))
        data.ZXXVAR=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>ZXYR'))
        data.ZXYR=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>ZXYI'))
        data.ZXYI=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>ZXY.VAR'))
        data.ZXYVAR=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>ZYXR'))
        data.ZYXR=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>ZYXI'))
        data.ZYXI=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>ZYX.VAR'))
        data.ZYXVAR=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>ZYYR'))
        data.ZYYR=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>ZYYI'))
        data.ZYYI=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>ZYY.VAR'))
        data.ZYYVAR=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>TXR.EXP'))
        data.TXR=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>TXI.EXP'))
        data.TXI=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>TXVAR.EXP'))
        data.TXVAR=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>TYR.EXP'))
        data.TYR=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>TYI.EXP'))
        data.TYI=fscanf(fid,'%f',nfreq);
        break
    end
end
while true
    tmp=strtrim(fgetl(fid));
    if ~isempty(strfind(tmp,'>TYVAR.EXP'))
        data.TYVAR=fscanf(fid,'%f',nfreq);
        break
    end
end
fclose(fid);