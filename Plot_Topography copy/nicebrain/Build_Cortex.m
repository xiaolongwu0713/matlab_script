
function [cortex]=Build_Cortex(surfaces_directory)
pathToLhPial = strcat(surfaces_directory, '/lh.pial');
pathToRhPial = strcat(surfaces_directory, '/rh.pial');

% make sure that the matlab folder inside the freesurfer folder is on the
% matlab path or else read_surf will be missing
[LHtempvert, LHtemptri] = read_surf(pathToLhPial);
[RHtempvert, RHtemptri] = read_surf(pathToRhPial);

% references to vert matrix must be 1-based
LHtemptri = LHtemptri + 1;
RHtemptri = RHtemptri + 1;

% all RH verts come after all LH verts
adjustedRHtemptri = RHtemptri + size(LHtempvert, 1);

% put all verts in same matrix, RH after LH
cortex.vert = [LHtempvert; RHtempvert];

% put all tris in same matrix, with corrected RH tris
cortex.tri = [LHtemptri; adjustedRHtemptri];
%%%%%%%%coarser and smoothmodel %%%%%%%%%%%%%
%  cortexcoarser = coarserModel(cortex, 0.85);
%  origin = [0 20 40];
%  smoothrad = 25;
%  mult = 0.5;
% [cortex] = smoothModel(cortexcoarser, smoothrad, origin, mult);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%finer model%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cortex=finerModel(cortex,2);


load('loc_colormap')
%a=trisurf(cortex.tri, cortex.vert(:, 1), cortex.vert(:, 2), cortex.vert(:, 3), 'FaceVertexCData', ixbrainc, 'CDataMapping', 'direct', 'linestyle', 'none');
tripatch(cortex, '', [0.85 0.6 0.7]);

%%%%% set light for transparent SEEG use %%%%%%%%%%%%%%%
% set(a,'FaceLighting','phong','AmbientStrength',0.5);
% light('Position',[-1 0.5 0],'Style','infinite');
% set(a,'EdgeColor','none', 'Facecolor','interp','FaceAlpha',1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


shading interp;
a=get(gca);
%%NOTE: MAY WANT TO MAKE AXIS THE SAME MAGNITUDE ACROSS ALL COMPONENTS TO REFLECT
%%RELEVANCE OF CHANNEL FOR COMPARISON's ACROSS CORTICES

d=a.CLim;
set(gca,'CLim',[-max(abs(d)) max(abs(d))])


ll=light;
colormap(cm);
view(270,0);
set(ll,'Position',[-1,0,1])
lighting gouraud; %%%for general use
material dull;
axis off
save('cortex.mat','cortex');

end