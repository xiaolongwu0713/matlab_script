
function rb_dot_surf_view(brain,locs,wts,th,phi,chan)

% this function plots the colored dots off of the brain in the direction
% that they will be viewed

if exist('chan'), wts(chan)=0; end

ctmr_gauss_plot(brain,[0 0 0],0)
lcm=max(abs(wts));

a_offset=.1*max(abs(locs(:,1)))*[cosd(th-90)*cosd(phi) sind(th-90)*cosd(phi) sind(phi)];

locs=locs+...
    repmat(a_offset,size(locs,1),1);


% % add whether stim - circles - black
% stim_locs=locs(stimsites,:);
% 
% for k=1:size(stim_locs,1)
%     hold on, plot3(stim_locs(k,1)-20,stim_locs(k,2),stim_locs(k,3),'.',...
%         'MarkerSize',30*wts(stimsites(k))/lcm+25,...
%         'Color','k')
% end
% 
% % add positive stim - circles - bars - green -- stimpairs in N x 2 arrangement
% for k=1:size(ecssites,1)
%     %lines between paired electrodes
%     plot3(locs(ecssites(k,:),1)-20,locs(ecssites(k,:),2),locs(ecssites(k,:),3),...
%         'LineWidth',3,...
%         'Color','g')
%     hold on, plot3(locs(ecssites(k,1),1)-20,locs(ecssites(k,1),2),locs(ecssites(k,1),3),'.',...
%         'MarkerSize',30*wts(ecssites(k,1))/lcm+26,...
%         'Color','g')
%     hold on, plot3(locs(ecssites(k,2),1)-20,locs(ecssites(k,2),2),locs(ecssites(k,2),3),'.',...
%         'MarkerSize',30*wts(ecssites(k,2))/lcm+26,...
%         'Color','g')    
% end

if lcm>0 % need to just have all gray if none significant


for k=1:size(locs,1)% add activity colorscale
    if abs(wts(k))<(.05*lcm)
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',20,...
        'Color',.35*[1 1 1])        
    elseif wts(k)>=(.05*lcm)
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',30*abs(wts(k))/lcm+20,...
        'Color',.99*[1 1-wts(k)/lcm 1-wts(k)/lcm])
    elseif wts(k)<=(-.05*lcm)
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',30*abs(wts(k))/lcm+20,...
        'Color',.99*[1+wts(k)/lcm 1+wts(k)/lcm 1])
    end
end

else % all gray dots if none significant
    for k=1:size(locs,1)
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',20,...
        'Color',.35*[1 1 1]) 
    end
end


if exist('chan')% add in electrode used for coherence with
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


