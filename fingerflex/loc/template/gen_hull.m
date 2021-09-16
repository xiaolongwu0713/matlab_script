
%try going to spherical coordinates, downsampling, etc to make convex
template='wholebrain.mat';
load(strcat(cd,'\template\',template))
v=cortex.vert;
t=cortex.tri;

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
[x,y,z]=sph2cart(hull_th,hull_phi,hull_r);
hull.vert(:,1)=x;
hull.vert(:,2)=y;
hull.vert(:,3)=z;
%saved as hulltemp1

%now put in matrix to visualize and see how to convert for missing values
%matrix is th x phi
for i=1:length(hull_r)
    r_mat(j1(i),i1(i))=hull_r(i);
end

figure,imagesc(min(phi):del_phi:(max(phi)),min(th):del_th:(max(th)),r_mat)
a=hull.vert;
figure,plot3(a(:,1),a(:,2),a(:,3))
%actually looks just fine with existing points with every measure i can
%make
%plot on brain
tripatch(cortex, '', [.7 .7 .7]);
shading interp;
light;
lighting gouraud;
material dull;
view(90, 0);
axis off
plot3(a(:,1),a(:,2),a(:,3),'ro')

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

[x,y,z]=sph2cart(new_th,new_phi,new_r);
hull.vert(:,1)=x;
hull.vert(:,2)=y;
hull.vert(:,3)=z;

%create hull using average of neighbors and hope it relaxes to something
%reasonable
% %first step find all attached vertices, take mean
% 
% for i=1:length(v(:,1))
%     t_adj=[]; %temporary adjacent points
%     for j=1:length(t(:,1))
%         if any(t(j,:)==i)
%             t_adj=[t_adj t(j,:)];
%         end
%     end
%     t_adj=unique(t_adj);
%     j=1;
%     l=((v(i,1)^2)+(v(i,2)^2)+(v(i,3)^2))^.5;
%     m=[];
%     for j=1:length(t_adj) %pick only points further out
%         lj=(((v(t_adj(j),1)^2)+(v(t_adj(j),2)^2)+(v(t_adj(j),3)^2))^.5);
%         if lj>=(l-.0000001)
%             m=[m j];
%         end
%     end
%     t_adj=t_adj(m);
%         
%     v1(i,1)=mean(v(t_adj,1));
%     v1(i,2)=mean(v(t_adj,2));
%     v1(i,3)=mean(v(t_adj,3));
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %plot to check out
% tripatch(cortex, '', [.7 .7 .7]);
% shading interp;
% light;
% lighting gouraud;
% material dull;
% view(90, 0);
% axis off
% hold on
% plot3(v1(:,1),v1(:,2),v1(:,3),'ro')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% %next step: go through, find 5 closest points(one will be self), take mean
% v=v1;
% clear v1
% for i=1:length(v(:,1))
% 
%     l=((v(i,1)^2)+(v(i,2)^2)+(v(i,3)^2))^.5;
%     k=[];
%     for j=1:length(v(:,1))
%         k(j)=(((v(i,1)-v(j,1))^2)+((v(i,2)-v(j,2))^2)+((v(i,3)-v(j,3))^2))^.5;
%     end
%     [a,b]=sort(k);
%     t_adj=b(1:5);
%     m=[];
%     for j=1:length(t_adj) %pick only points further out
%         lj=(((v(t_adj(j),1)^2)+(v(t_adj(j),2)^2)+(v(t_adj(j),3)^2))^.5);
%         if lj>=(l-.0000001)
%             m=[m j];
%         end
%     end
%     t_adj=t_adj(m);
%         
%     v1(i,1)=mean(v(t_adj,1));
%     v1(i,2)=mean(v(t_adj,2));
%     v1(i,3)=mean(v(t_adj,3));
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %plot to check out
% figure
% tripatch(cortex, '', [.7 .7 .7]);
% shading interp;
% light;
% lighting gouraud;
% material dull;
% view(90, 0);
% axis off
% hold on
% plot3(v1(:,1),v1(:,2),v1(:,3),'ro')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
    

