function gauss_plot(electrodes,weights)
% function [electrodes]=gauss_plot_l(electrodes,weights)
% projects electrode locations onto their cortical spots in the 
% left hemisphere and plots about them using a gaussian kernel

rel_dir=which('loc_plot');
rel_dir((length(rel_dir)-10):length(rel_dir))=[];
addpath(rel_dir)

%load in colormap
load('loc_colormap')

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
brain=cortex.vert;

%view from which side?
temp=1;
while temp==1
    disp('---------------------------------------')
    disp('to view from right press ''r''')
    disp('to view from left press ''l''');
    v=input('','s');
    if v=='l'      
        temp=0;
    elseif v=='r'      
        temp=0;
    else
        disp('you didn''t press r, or l try again (is caps on?)')
    end
end

whos
if length(weights)~=length(electrodes(:,1))
    error('you sent a different number of weights than electrodes (perhaps a whole matrix instead of vector)')
end
%gaussian "cortical" spreading parameter - in mm, so if set at 10, its 1 cm
%- distance between adjacent electrodes
gsp=50;

c=zeros(length(cortex(:,1)),1);
for i=1:length(electrodes)
    b_z=abs(brain(:,3)-electrodes(i,3));
    b_y=abs(brain(:,2)-electrodes(i,2));
    b_x=abs(brain(:,1)-electrodes(i,1));
%     d=weights(i)*exp((-(b_x.^2+b_z.^2+b_y.^2).^.5)/gsp^.5); %exponential fall off 
    d=weights(i)*exp((-(b_x.^2+b_z.^2+b_y.^2))/gsp); %gaussian 
    c=c+d';
end
c=(c/max(c));
a=tripatch(cortex, '', c');
shading interp;
a=get(gca);
%%NOTE: MAY WANT TO MAKE AXIS THE SAME MAGNITUDE ACROSS ALL COMPONENTS TO REFLECT
%%RELEVANCE OF CHANNEL FOR COMPARISON's ACROSS CORTICES
d=a.CLim;
set(gca,'CLim',[-max(abs(d)) max(abs(d))])
l=light;
colormap(cm)
lighting gouraud;
material dull;
axis off

if v=='l'
view(270, 0);
set(l,'Position',[-1 0 1])        
elseif v=='r'
view(90, 0);
set(l,'Position',[1 0 1])        
end
% %exportfig
% exportfig(gcf, strcat(cd,'\figout.png'), 'format', 'png', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 600, 'Width', 4, 'Height', 3);
% disp('figure saved as "figout"');