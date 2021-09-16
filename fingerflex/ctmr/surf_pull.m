function cortex=surf_pull(a,brain_info,isoparm)



%%
xst=(sum(brain_info.mat(:,2).^2)).^.5; %temporary x scaling for tesselation
yst=(sum(brain_info.mat(:,1).^2)).^.5; %temporary y scaling
zst=(sum(brain_info.mat(:,3).^2)).^.5; %temporary z scaling

%%
fv=isosurface([1:size(a,2)].*xst, [1:size(a,1)].*yst, [1:size(a,3)].*zst, a, isoparm); %generate surface that is properly expanded for tesselation later fix indices to be in proper coordinates
vert=fv.vertices; tri=fv.faces;% clear fv

%% reordering, etc
vert(:,1)=vert(:,1)/xst; vert(:,2)=vert(:,2)/yst; vert(:,3)=vert(:,3)/zst; 
cx=vert(:,1); cy=vert(:,2);
vert(:,1)=cy; vert(:,2)=cx; clear cx cy
vert=vert*brain_info.mat(1:3,1:3)'+repmat(brain_info.mat(1:3,4)',size(vert,1),1);
cortex.vert=vert; cortex.tri=tri; %familiar nomenclature

%%
figure, ctmr_gauss_plot(cortex,[0 0 0],0)