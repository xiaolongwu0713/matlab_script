
function ph_dot_surf_view(brain,locs,wts,th,phi,chan)

% this function plots phase-colored dots off of the brain in the direction
% that they will be viewed

if exist('chan'), wts(chan)=0; end % zero out channel used to compare against

wts(isnan(wts))=0;

% load('cm_alt'), cm=cm_alt;
load('cm3'),

ctmr_gauss_plot(brain,[0 0 0],0)
lcm=max(abs(wts));

a_offset=.1*max(abs(locs(:,1)))*[cosd(th-90)*cosd(phi) sind(th-90)*cosd(phi) sind(phi)];

locs=locs+...
    repmat(a_offset,size(locs,1),1);

if lcm>0 % need to just have all gray if none significant

% add phase - activity colorscale
for k=1:size(locs,1)
    % gray dot if insignificant
       if abs(wts(k))<(.05*lcm)
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',20,...
        'Color',.35*[1 1 1])     
%         % black outline
%         hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
%         'MarkerSize',30*abs(wts(k))/lcm+26,...
%         'Color','k')
        % colored inset
       else
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',30*abs(wts(k))/lcm+20,...
        'Color',1-(abs(wts(k))/lcm)*(1-cm(ceil(256*(angle(wts(k))+pi)/(2*pi)),:)))
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
    

%     hold on, plot3(locs(chan,1),locs(chan,2),locs(chan,3),'h',...
%         'MarkerSize',15,...
%         'Color',[0 0 0],...
%         'MarkerEdgeColor','k',...
%         'MarkerFaceColor','w')
end  

loc_view(th,phi)


