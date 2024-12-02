function myerrbar2(x,y,yerr,C,ytype,axxx)
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
% for i=1:n
%     plot(axxx,[xl(i) xr(i)], [ybot(i) ybot(i)],'color',C)
%     %hold(axxx,'on')
%     plot(axxx,[xl(i) xr(i)], [ytop(i) ytop(i)],'color',C)
%     plot(axxx,[x(i) x(i)], [ybot(i) ytop(i)],'color',C)
% end
yL=y-ybot;
yU=ytop-y;
    errorbar(axxx,x, y,yL ,yU,'color',C,'linestyle','none');
    %hold(axxx,'on')
%     plot(axxx,[xl xr], [ytop ytop],'color',C)
%     plot(axxx,[x x], [ybot ytop],'color',C)

end