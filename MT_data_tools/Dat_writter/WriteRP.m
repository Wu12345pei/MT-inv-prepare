function WriteRP(folder,chara,data)
datafile=fullfile(folder,strcat(chara,'RP'));
fidout=fopen(datafile,'w');
nsite=size(data,1);
fprintf(fidout,'Nsite=%d\n',nsite);
dd=180/pi;
dd2=dd^2;
for i=1:nsite
    per=data{i,5};
    nper=length(per);
    rhoxx=0.2.*per.*abs(data{i,6}).^2;
    phsxx=angle(data{i,6});
    rhoxy=0.2.*per.*abs(data{i,7}).^2;
    phsxy=angle(data{i,7});   
    rhoyx=0.2.*per.*abs(data{i,8}).^2;
    phsyx=angle(data{i,8});
    rhoyy=0.2.*per.*abs(data{i,9}).^2;
    phsyy=angle(data{i,9});
   
    if size(data,2)==17
        varrxx=0.4.*data{i,5}.*rhoxx.*data{i,12};
        varpxx=cos(phsxx).^4.*abs(data{i,6}).^2.*data{i,12}./(real(data{i,6}).^4);
        varrxy=0.4.*data{i,5}.*rhoxy.*data{i,13};
        varpxy=cos(phsxy).^4.*abs(data{i,7}).^2.*data{i,13}./(real(data{i,7}).^4);  
        varryx=0.4.*data{i,5}.*rhoyx.*data{i,14};
        varpyx=cos(phsyx).^4.*abs(data{i,8}).^2.*data{i,14}./(real(data{i,8}).^4);
        varryy=0.4.*data{i,5}.*rhoyy.*data{i,15};
        varpyy=cos(phsyy).^4.*abs(data{i,9}).^2.*data{i,15}./(real(data{i,9}).^4);
    elseif size(data,2)==13
        varrxx=0.4.*data{i,5}.*rhoxx.*data{i,10};
        varpxx=cos(phsxx).^4.*abs(data{i,6}).^2.*data{i,10}./(real(data{i,6}).^4);
        varrxy=0.4.*data{i,5}.*rhoxy.*data{i,11};
        varpxy=cos(phsxy).^4.*abs(data{i,7}).^2.*data{i,11}./(real(data{i,7}).^4);  
        varryx=0.4.*data{i,5}.*rhoyx.*data{i,12};
        varpyx=cos(phsyx).^4.*abs(data{i,8}).^2.*data{i,12}./(real(data{i,8}).^4);
        varryy=0.4.*data{i,5}.*rhoyy.*data{i,13};
        varpyy=cos(phsyy).^4.*abs(data{i,9}).^2.*data{i,13}./(real(data{i,9}).^4);
        
    end
    fprintf(fidout,'SiteName=%s\n',data{i,1});
    fprintf(fidout,'%f  %f  %d\n',data{i,2},data{i,3},length(data{i,5}));
    fprintf(fidout,'period  rhoxx  phsxx  rhoxy  phsxy rhoyx  phsx  rhoyy  phsyy varrxx  varpxx varrxy  varpxy varryx  varpyx varryy  varpyy\n');
    for j=1:nper
        fprintf(fidout,'%14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E %14.6E \n',...
            data{i,5}(j),rhoxx(j),  dd*phsxx(j),  rhoxy(j),  dd*phsxy(j), rhoyx(j),  dd*phsyx(j),  rhoyy(j),  dd*phsyy(j), varrxx(j),  dd2*varpxx(j), varrxy(j),  dd2*varpxy(j), varryx(j),  dd2*varpyx(j), varryy(j),  dd2*varpyy(j));
    end
end

fclose(fidout);