function electrodes=get_loc_xih(tail_y,tail_z,side)
%function to find closest x points on map

%load brain  
clear elec*
template='halfhull.mat'
rel_dir=which('get_loc');
rel_dir((length(rel_dir)-9):length(rel_dir))=[];
load(strcat(rel_dir,'\template\',template))


%eliminate points other than medial surface of desired cortex
if side=='r'
    cortex=righthull;
    m=find(or((cortex.vert(:,1)>10),(cortex.vert(:,1)<0))); 
elseif side=='l'
    cortex=lefthull;
    m=find(or((cortex.vert(:,1)<-10),(cortex.vert(:,1)>0))); 
end

brain=cortex.vert;

%eliminate other half and lateral surface, so you can match to surface
brain(m,:)=[];

for i=1:length(tail_y)
    b_z=abs(brain(:,3)-tail_z(i));
    b_y=abs(brain(:,2)-tail_y(i));
    c=(b_z.^2+b_y.^2).^.5;
    elec_index(i)=find(c==min(c)); %note that this replaces the clicked coordinates with the closest vertex
end

electrodes=brain(elec_index,:)*1.001;

%demonstrate on the generated cortex
template='halfbrains.mat';
load(strcat(rel_dir,'\template\',template))
if side=='r'
    cortex=rightbrain;
elseif side=='l'
    cortex=leftbrain;
end
tripatch(cortex, '', [.7 .7 .7]);
shading interp;
l=light;
lighting gouraud;
material dull;
axis off
if side=='l'
    view(90, 0);
    set(l,'Position',[1 0 1])
elseif side=='r'
    view(270, 0);
    set(l,'Position',[-1 0 1])
end
hold on
plot3(electrodes(:,1),electrodes(:,2),electrodes(:,3),'ro')