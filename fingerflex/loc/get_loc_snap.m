function electrodes=get_loc_snap(electrodes,side)
%snaps "best guess" of electrodes to template

%load brain  
template='halfhull.mat';
rel_dir=which('get_loc');
rel_dir((length(rel_dir)-9):length(rel_dir))=[];
load(strcat(rel_dir,'\template\',template))
e=electrodes;

%eliminate points other than medial surface of desired cortex
if side=='r'
    v=righthull.vert;
elseif side=='l'
    v=lefthull.vert;
end

% find middle of hemisphere
x0=mean(v(:,1));
y0=mean(v(:,2));
z0=mean(v(:,3));

%recenter hemisphere
v(:,1)=v(:,1)-x0;
v(:,2)=v(:,2)-y0;
v(:,3)=v(:,3)-z0;

%recenter electrodes
e(:,1)=e(:,1)-x0;
e(:,2)=e(:,2)-y0;
e(:,3)=e(:,3)-z0;

%change to spherical coordinates
[th_v,phi_v,r_v]=cart2sph(v(:,1),v(:,2),v(:,3)); %nonstandard notation: th={pi:-pi} phi={-pi/2:pi/2}
[th_e,phi_e,r_e]=cart2sph(e(:,1),e(:,2),e(:,3)); %nonstandard notation: th={pi:-pi} phi={-pi/2:pi/2}

%find closest point in spherical for each electrode on template
cl_index=zeros(1,length(r_e));
for i=1:length(r_e)
    t=th_v-th_e(i);
    p=phi_v-phi_e(i);
    d=t.^2+p.^2;
%     a=find(and((t==min(t)),(p==min(p))));
    a=find(d==min(d));
    cl_index(i)=a(1); %in case multiple values (unlikely), pick best one
end

if side=='r'
    electrodes=(righthull.vert(cl_index,:))*1.001;
elseif side=='l'
    electrodes=(lefthull.vert(cl_index,:))*1.001;
end


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