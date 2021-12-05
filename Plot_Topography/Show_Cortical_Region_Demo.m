%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Demo%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is used for calculating and plotting different cortical     %
% regions, different color indicate different regions                     %                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Get_3D_Cortex_Center_v3('/Users/long/Documents/BCI/matlab_scripts/iEEGview_demo'); % generate:Cortex_Center_aparc.mat
Color_Mat=load('/Users/long/Documents/BCI/matlab_scripts/iEEGview_demo/MATLAB/Cortex_Center_aparc.mat');
%load('Norm_Brain.mat');
load('WholeCortex.mat');
Color_Cindex=repmat([0.7,0.7,0.7],length(cortex.vert),1);
Color_Cindex(Color_Mat.M(2).Cortex_Color(:,1),:)=Color_Mat.M(2).Cortex_Color(:,2:4);
Color_Cindex(Color_Mat.M(1).Cortex_Color(:,1)+size(Color_Mat.M(2).vert,1),:)=Color_Mat.M(1).Cortex_Color(:,2:4);
hh=trisurf(cortex.tri, cortex.vert(:, 1), cortex.vert(:, 2), cortex.vert(:, 3),  'FaceVertexCData',  Color_Cindex, 'FaceColor', 'interp', 'CDataMapping', 'direct', 'linestyle', 'none','FaceAlpha',0.1);%0.1
set(hh,'FaceLighting','phong','AmbientStrength',0.5);
material('dull');
viewstruct.viewvect     = [110, 10];
viewstruct.lightpos     = [150, 0, 0]; 
view(viewstruct.viewvect);
light('Position', viewstruct.lightpos, 'Style', 'infinite');
axis equal off;