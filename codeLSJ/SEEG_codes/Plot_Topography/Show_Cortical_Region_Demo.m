%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Demo%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is used for calculating and plotting different cortical     %
% regions, different color indicate different regions                     %
% By Li Guangye @ Liguangye.hust@gmail.com                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Get_3D_Cortex_Center;
Color_Mat=load('Cortex_Center.mat');
load('Norm_Brain.mat');
%%
Color_Cindex=repmat([0.7,0.7,0.7],length(cortex.vert),1);
Color_Cindex(Color_Mat.MCTX(2).Cortex_Color(:,1),:)=Color_Mat.MCTX(2).Cortex_Color(:,2:4);
Color_Cindex(Color_Mat.MCTX(1).Cortex_Color(:,1)+size(Color_Mat.MCTX(2).vert,1),:)=Color_Mat.MCTX(1).Cortex_Color(:,2:4);
hh=trisurf(cortex.tri, cortex.vert(:, 1), cortex.vert(:, 2), cortex.vert(:, 3),  'FaceVertexCData',  Color_Cindex, 'FaceColor', 'interp', 'CDataMapping', 'direct', 'linestyle', 'none','FaceAlpha',1);%0.1
set(hh,'FaceLighting','phong','AmbientStrength',0.5);
material('dull');
viewstruct.viewvect     = [110, 10];
viewstruct.lightpos     = [150, 0, 0]; 
view(viewstruct.viewvect);
light('Position', viewstruct.lightpos, 'Style', 'infinite');
axis equal off;