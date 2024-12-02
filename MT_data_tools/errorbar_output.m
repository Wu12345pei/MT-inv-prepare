function [yL,yU]=errorbar_output(x,y,yerr,ytype)
%********************************************
% plot errorbar in rho and phase curve
% C means color character
% axxx means axes
%********************************************
n=length(x);
stol=100000;
tee=(max(x(:))-min(x(:)))/stol;
xl=x/2^tee;xr=x*2^tee;
ytop=y+yerr;
ybot=y-yerr;
switch ytype
    case 'rho'
        idx=find(ybot<=0);
        for i=1:length(idx)
            ybot(idx(i))=(y(idx(i)).^2)./ytop(idx(i));
        end
    case 'phase'
        idx=find(ytop>180);
        for i=1:length(idx)
            ytop(idx(i))=180;
        end
        idx=find(ybot<-180);
        for i=1:length(idx)
            ybot(idx)=-180;
        end
end

yL=y-ybot;
yU=ytop-y;



end