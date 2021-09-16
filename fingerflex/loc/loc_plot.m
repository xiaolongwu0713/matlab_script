function loc_plot(electrodes)
% this function plots electrode locations in the presence of the brain
% it will ask for what template brain to plot this on
% if plot_opt=='yes', it will plot to the brain
% if exist(plot_opt)~=1
%     plot_opt='no';
% end

rel_dir=which('loc_plot');
rel_dir((length(rel_dir)-10):length(rel_dir))=[];


%which template?
temp=1;
while temp==1
    disp('---------------------------------------')
    disp('to plot on right half brain press ''r''')
    disp('to plot on left half brain press ''l''')
    disp('to plot on whole brain press ''w''');
    t=input('','s');
    if t=='w'
        template='wholebrain.mat';load(strcat(rel_dir,'\template\',template));
        temp=0;
    elseif t=='r'
        template='halfbrains.mat';load(strcat(rel_dir,'\template\',template));
        cortex=rightbrain;
        temp=0;
    elseif t=='l'
        template='halfbrains.mat';load(strcat(rel_dir,'\template\',template));
        cortex=leftbrain;
        temp=0;
    else
        disp('you didn''t press r,l or w, try again (is caps on?)')
    end
end


%view from which side?
temp=1;
while temp==1
    disp('---------------------------------------')
    disp('to view from right press ''r''')
    disp('to view from right press ''l''');
    v=input('','s');
    if v=='l'      
        temp=0;
    elseif v=='r'      
        temp=0;
    else
        disp('you didn''t press r, or l try again (is caps on?)')
    end
end


tripatch(cortex, '', [.7 .7 .7]);
shading interp;
lighting gouraud;
material dull;
l=light;
axis off
hold on
plot3(electrodes(:,1),electrodes(:,2),electrodes(:,3),'rh')
set(gcf,'Color',[1 1 1])

if v=='l'
view(270, 0);
set(l,'Position',[-1 0 1])        
elseif v=='r'
view(90, 0);
set(l,'Position',[1 0 1])        
end
disp('---------------------------------------------------')
disp('plotted electrode locations in talairach')
[[1:length(electrodes(:,1))]' electrodes]
disp('---------------------------------------------------')
%exportfig
% if plot_opt=='yes'
%     exportfig(gcf, strcat(cd,'\figout.png'), 'format', 'png', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 600, 'Width', 4, 'Height', 3);
%     disp('figure saved as "figout"');
% end