function electrodes=get_ctmr_snap(electrodes,hull)
%snaps "best guess" of electrodes to hull


e=electrodes;
v=hull.vert;


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

electrodes=(hull.vert(cl_index,:))*1.001;

%demonstrate on the generated cortex

tripatch(hull, '', [.7 .7 .7]);
shading interp;
l=light;
lighting gouraud;
material dull;
axis off

loc_view(180,-90)

hold on
plot3(electrodes(:,1),electrodes(:,2),electrodes(:,3),'ro')