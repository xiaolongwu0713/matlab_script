function rb_dot_surf_view_black_outline(brain,locs,wts,th,phi,chan)

% this function plots the colored dots off of the brain in the direction
% that they will be viewed

if exist('chan'), wts(chan)=0; end

ctmr_gauss_plot(brain,[0 0 0],0), % set(gca,'clim',[0 150])
lcm=max(abs(wts));

a_offset=.1*max(abs(locs(:,1)))*[cosd(th-90)*cosd(phi) sind(th-90)*cosd(phi) sind(phi)];

locs=locs+...
    repmat(a_offset,size(locs,1),1);


if lcm>0 % need to just have all gray if none significant


for k=1:size(locs,1)% add activity colorscale
    if abs(wts(k))<(.05*lcm)
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',23,...
        'Color',.01*[1 1 1])  
        %
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',20,...
        'Color',.35*[1 1 1])  
        %
    elseif wts(k)>=(.05*lcm)
        %
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',30*abs(wts(k))/lcm+23,...
        'Color',.01*[1 1 1])
        %
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',30*abs(wts(k))/lcm+20,...
        'Color',.99*[1 1-wts(k)/lcm 1-wts(k)/lcm])
        %
    elseif wts(k)<=(-.05*lcm)
        %
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',30*abs(wts(k))/lcm+23,...
        'Color',.01*[1 1 1])
        %
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',30*abs(wts(k))/lcm+20,...
        'Color',.99*[1+wts(k)/lcm 1+wts(k)/lcm 1])
    end
end

else % all gray dots if none significant
    for k=1:size(locs,1)
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',23,...
        'Color',.01*[1 1 1])  
        %
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',20,...
        'Color',.35*[1 1 1]) 
    end
end

if exist('chan')% add in electrode used for coherence with
% hold on, plot3(locs(chan,1),locs(chan,2),locs(chan,3),'.',...
%         'MarkerSize',30,...
%         'Color',[0 0 0])  
% hold on, plot3(locs(chan,1),locs(chan,2),locs(chan,3),'.',...
%         'MarkerSize',25,...
%         'Color',[0 .5 0])
% end  


hold on, plot3(locs(chan,1),locs(chan,2),locs(chan,3),'.',...
        'MarkerSize',30,...
        'Color',[0 0 0])  
    
hold on, plot3(locs(chan,1),locs(chan,2),locs(chan,3),'.',...
        'MarkerSize',25,...
        'Color',.99*[1 1 1]) 
    
    hold on, plot3(locs(chan,1),locs(chan,2),locs(chan,3),'k*',...
        'MarkerSize',15,...
        'Color',[0 0 0])  
end
    




loc_view(th,phi)

