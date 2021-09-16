
%try going to spherical coordinates, downsampling, etc to make convex
template='halfbrains.mat';
load(strcat(cd,'\template\',template))
v=rightbrain.vert;
t=rightbrain.tri;

% convert center to middle of hemisphere
x0=mean(v(:,1))
y0=mean(v(:,2))
z0=mean(v(:,3))

v(:,1)=v(:,1)-x0;
v(:,2)=v(:,2)-y0;
v(:,3)=v(:,3)-z0;


[th,phi,r]=cart2sph(v(:,1),v(:,2),v(:,3)); %nonstandard notation: th={pi:-pi} phi={-pi/2:pi/2}

%create a patch of infinitesimal solid angle, note that there will be the
%map stretching problem so higher density at the north and south poles
del_phi=pi/100; %100 polar divides
del_th=2*pi/300;%300 azimuthal divides
%now, push all of the way out to max value for each of the infinitesimal
%elements to get "base brain", then smear out to better convexity later
hull_th=[];
hull_phi=[];
hull_r=[];
i0=0;
j0=0;
i1=[];
j1=[];
for i=min(phi):del_phi:(max(phi)-del_phi)%for the pial template, phi starts at -1.37... troubling
    i0=i0+1%counter
    for j=min(th):del_th:max(th)
        j0=j0+1;
        th0=and(th>=j,th<=(j+del_th));
        phi0=and(phi>=i,phi<=(i+del_phi));
        a=find(and(phi0,th0));
        if length(a)>0 %want nontrivial pts
            hull_phi=[hull_phi i];
            hull_th=[hull_th j];
            hull_r=[hull_r max(r(a))];
            i1=[i1 i0];
            j1=[j1 j0];
        end
    end
    j0=0; %reset
end


%now put in matrix to visualize and see how to convert for missing values
%matrix is th x phi
for i=1:length(hull_r)
    r_mat(j1(i),i1(i))=hull_r(i);
end



n=length(r_mat(1,:));
for i=1:length(r_mat(:,1))
    rowtemp=[r_mat(i,2:n) 0;0 r_mat(i,1:(n-1)); r_mat(i,:)];
    r_mat(i,:)=max(rowtemp);
end

n=length(r_mat(1,:));
for i=1:length(r_mat(:,1))
    rowtemp=[r_mat(i,2:n) 0;0 r_mat(i,1:(n-1)); r_mat(i,:)];
    r_mat(i,:)=max(rowtemp);
end


m=min(phi):del_phi:(max(phi));
n=min(th):del_th:(max(th));
new_th=[];
new_phi=[];
new_r=[];

for i=1:(length(m)-1)
    for j=1:length(n)
        new_th=[new_th n(j)];
        new_phi=[new_phi m(i)];
        new_r=[new_r r_mat(j,i)];
    end
end

[x,y,z]=sph2cart(hull_th,hull_phi,hull_r);
righthull.vert(:,1)=x+x0;
righthull.vert(:,2)=y+y0;
righthull.vert(:,3)=z+z0;

figure,imagesc(min(phi):del_phi:(max(phi)),min(th):del_th:(max(th)),r_mat)
a=righthull.vert;
figure,plot3(a(:,1),a(:,2),a(:,3))
%actually looks just fine with existing points with every measure i can
%make
%plot on brain
tripatch(rightbrain, '', [.7 .7 .7]);
shading interp;
light;
lighting gouraud;
material dull;
view(90, 0);
axis off
plot3(a(:,1),a(:,2),a(:,3),'r.')
save('righthulltemp')

