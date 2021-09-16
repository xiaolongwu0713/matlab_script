function ctmr_vox_plot_kai(cortex,xyz,weights,ssize,v)

% ctmr_vox_plot(xyz,weights,ssize)
% xyz and weights output from voxplot_func_gm
% ssize=2; % size of voxel squares on surface
% v='l'; % 'l' or 'r' left or right
% ask for load cortex

% [cname]=spm_select(1,'mat','select cortex.mat');
% load(cname); % cortex

brain=cortex.vert;

if length(weights)~=length(xyz(:,1))
    error('you sent a different number of weights than xyz (perhaps a whole matrix instead of vector)')
end

c=zeros(length(cortex.vert),1);
for k=1:length(xyz(:,1))
    b_z=abs(brain(:,3)-xyz(k,3));
    b_y=abs(brain(:,2)-xyz(k,2));
    b_x=abs(brain(:,1)-xyz(k,1));
    
    d=b_z<ssize & b_y<ssize & b_x<ssize;
    d=d*weights(k); % no smoothing

    c=max(c,d); %overlap is going to maximum
end

a=tripatch(cortex, 'nofigure', c);
shading interp;
a=get(gca);
%%NOTE: MAY WANT TO MAKE AXIS THE SAME MAGNITUDE ACROSS ALL COMPONENTS TO REFLECT
%%RELEVANCE OF CHANNEL FOR COMPARISON's ACROSS CORTICES
d=a.CLim;
set(gca,'CLim',[0 max(weights)]);

l=light;
%load in colormap
% cm=colormap('hot');
% cm=[.7 .7 .7;cm];

% load ctmr_nonlin_cmap
% load dg_colormap

load ctmr_nonlin_cmap

colormap(cm);
lighting gouraud; %play with lighting...
% material dull;
material([.3 .8 .1 10 1]);
axis off
set(gcf,'Renderer', 'zbuffer')

set(gca,'clim',max(max(abs(c)))*[-1 1])

if v=='l'
view(270, 0);
%view(-92,32);
set(l,'Position',[-1 0 1])        
elseif v=='r'
view(90, 0);
set(l,'Position',[1 0 1])        
end
