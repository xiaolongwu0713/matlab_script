function electrodes=get_loc_xlat(tail_y,tail_z,side)
%function to find closest points on map for whole brain template

%load brain  
clear elec*
%for FCM see the file fcm_gen.mat for how generated
template='wholehull.mat'
rel_dir=which('get_loc');
rel_dir((length(rel_dir)-9):length(rel_dir))=[];
load(strcat(rel_dir,'\template\',template))
cortex=hull;
brain=cortex.vert;

%eliminate points on other half of the cortex, so you can match to surface
if side=='r'
    m=find(cortex.vert(:,1)<10);
elseif side=='l'
    m=find(cortex.vert(:,1)>-10); 
end


brain(m,:)=[];

for i=1:length(tail_y)
    b_z=abs(brain(:,3)-tail_z(i));
    b_y=abs(brain(:,2)-tail_y(i));
    c=(b_z.^2+b_y.^2).^.5;
    elec_index(i)=find(c==min(c)); %note that this replaces the clicked coordinates with the closest vertex
end

electrodes=brain(elec_index,:)*1.001;

%demonstrate on the generated cortex
template='wholebrain.mat';
load(strcat(rel_dir,'\template\',template))
tripatch(cortex, '', [.7 .7 .7]);
shading interp;
lighting gouraud;
material dull;
l=light;
axis off
hold on

if side=='r'
    view(90, 0);
    set(l,'Position',[1 0 1])
elseif side=='l'
    view(270, 0);
    set(l,'Position',[-1 0 1])
end

plot3(electrodes(:,1),electrodes(:,2),electrodes(:,3),'ro')

