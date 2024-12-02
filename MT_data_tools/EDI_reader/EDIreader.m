%******************************************************
% aim:
%       read EDI in SPECTRA format
% input:
%       filename
% output:
%       structure of data, including:
%       data.sitename,data.lat（1：3）(度分秒)，data.lon(1:3)(度分秒)
%       data.frq,data.imp 
%******************************************************
function [data]=EDIreader(file)
[fidin,whyerror]=fopen(file,'r');
if fidin<0,disp(whyerror);end
while true
    tmp=strtrim(fgetl(fidin));
    if ~isempty(strfind(tmp,'DATAID'))
        if ~isempty(strfind(tmp,'"'));
            delt=sscanf(tmp,'DATAID="%s"');
            data.sitename=delt(1:length(delt)-1);
        else
            data.sitename=sscanf(tmp,'DATAID=%s');
        end
        break;
    end
end
while true
    tmp=strtrim(fgetl(fidin));
    if ~isempty(strfind(tmp,'LAT'))
        delt(1:3)=sscanf(tmp,'LAT=%f:%f:%f');
        data.lat=delt(1)+delt(2)*0.01+delt(3)*1e-4;
        break;    
    end
end
while true
    tmp=strtrim(fgetl(fidin));
    if ~isempty(strfind(tmp,'LONG'))
        delt(1:3)=sscanf(tmp,'LONG=%f:%f:%f');
        data.lon=delt(1)+delt(2)*0.01+delt(3)*1e-4;
        break;    
    end
end
while true
    tmp=strtrim(fgetl(fidin));
    if ~isempty(strfind(tmp,'NCHAN'))
        nchan=sscanf(tmp,'NCHAN=%f');
        if nchan~=7
            error('there is not enough channel');
        end
    end    
    if ~isempty(strfind(tmp,'NFREQ'))
        nfrq=sscanf(tmp,'NFREQ=%f');
        break;
    end
end
frq=zeros(nfrq,1);
freeN=zeros(nfrq,1);
spectra=cell(nfrq,1);
    i=1;
while i<=nfrq
    tmp=strtrim(fgetl(fidin));
    if ~isempty(strfind(tmp,'>SPECTRA'))
        frq(i)=sscanf(tmp,'%*s FREQ=%f %*s %*s %*s %*s %*f');
        freeN(i)=sscanf(tmp,'%*s %*s %*s %*s AVGT=%f %*s %*f');
        delt=fscanf(fidin,'%f',[7,7]);
        spectra{i}=delt';
        i=i+1;
    end
end
data.frq=frq;
data.freeN=freeN;
data.spectra=spectra;
fclose(fidin);
end