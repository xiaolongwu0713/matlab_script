function [ ] = viewBrain( M, subjstructs, what2view, transp, colix, viewvect )
%VIEWBRAIN  Display a brain model and/or electrode grid locations using activateBrain.
%
%   CALLING SEQUENCE:
%       viewBrain( M )
%       viewBrain( M, subjstructs )
%       viewBrain( M, subjstructs, what2view, transp )
%       viewBrain( M, subjstructs, what2view, transp, colix )
%
%   INPUT:
%       M:              struct('vert', Vx3matrix, 'tri', Tx3matrix) - brain model (eventually the one altered by projectElectrodes, see <help projectElectrodes>)
%       subjstructs:    field of structures, for each subject: struct('activations', NsubjxLsubjMatrix, 'trielectrodes', Nsubjx1Matrix) - structure of 'electrodes' only or enhanced subjstructs (output of projectElectrodes), where 'trielectrodes' is a matrix of coordinates of the projected electrodes
%       what2view:      a column cell of strings specifying what shall be visualized:
%           possible values: 'brain' - shows the grey brain
%                            'activations' - shows the activations
%                            'electrodes' - shows the original electrode locations
%                            'trielectrodes' - shows the projected electrode locations
%                                 (e.g. {'brain', 'electrodes'} )
%       transp:         brain surface transparency value (<0, 1> : 0 - invisible, 1 - opaque) - this is mainly used for plotting more than one brain on the same figure using <hold on> - see Example below
%       colix:          a colour index into a 64-value greyscale colormap used (0 - black, 64 - white) - this is mainly used for plotting more than one brain on the same figure using <hold on> - see Example below
%       viewvect:       vector used by the view command (e.g. [-90, 0])
%
%   Example:    
%       load pial_talairach;
%       load DEMOsubj;
%       M = cortex;
%       viewBrain( M, subj, {'brain', 'electrodes'}, 0.5, 24 );
%       hold on;
%       M = hullModel(M);
%       viewBrain( M, subj, {'brain', 'electrodes'}, 0.5, 42 );
%
%       Please see also demo and activateBrain for further information
%
%   See also DEMO, PROJECTELECTRODES, ELECTRODESCONTRIBUTIONS, ACTIVATEBRAIN, RECORDBRAIN, COARSERMODEL, SMOOTHMODEL, HULLMODEL.

%   Author: Jan Kubanek
%   Institution: Czech Technical University in Prague
%   Date: August 2005
%   This procedure is a part of the activeBrain Matlab package which was
%   designed for internal purposes of the BCI group at the Wadsworth Institute,
%   Albany, NY.

% load('G:\毕业设计备份\毕业设计\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\SEEG_Data\best_channel.mat');
best_channel=[8 9 10 18 19 20 21 22 23 24 62 63 69 70 105 107 108 109 110];
channel_transform=[92,93,94,95,96,80,81,82,83,84,64,65,71,72,105,107,108,109,110];

grey = 32;    
if exist('colix', 'var'),
    grey = colix;
end
if ~exist('what2view', 'var'),
    if exist('subjstructs', 'var'),
        what2view = {'brain', 'electrodes'};
    else
        what2view = {'brain'};
    end
end
if ~exist('viewvect', 'var'),
    viewvect = [90, 0];
end
if ~exist('transp', 'var'),
    transp = 1;
end

viewstruct.what2view = what2view;
viewstruct.material = 'dull';
viewstruct.enablelight = 1;
viewstruct.enablecolorbar = 0;
viewstruct.enableaxis = 1;
viewstruct.lightingtype = 'gouraud';
if strcmp(viewvect,'front')
%%%%%front view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   viewstruct.lightpos=[0,180,0];
    viewstruct.viewvect=[180,0];
elseif strcmp(viewvect,'top')
%%%%%top view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 viewstruct.lightpos=[0,0,80];
    viewstruct.viewvect=[0,90];
elseif strcmp(viewvect,'lateral')
%%%%%lateral view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  viewstruct.lightpos=[85,0,0];
   viewstruct.viewvect=[90,0];
elseif strcmp(viewvect,'isometric')
%%%%%isometric view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 viewstruct.lightpos=[-100,80,45];
   viewstruct.viewvect=[-108,30];
   
elseif strcmp(viewvect,'right')
     viewstruct.viewvect     = [110, 10];
     viewstruct.lightpos     = [150, 0, 0];
elseif strcmp(viewvect,'left')
     viewstruct.viewvect     = [270, 5];
%      viewstruct.viewvect     = [-82, 5];
     viewstruct.lightpos     = [-150,0, 10];   
else
%     error('wrong input, check your spelling');
      viewstruct.viewvect     = viewvect;
%      viewstruct.viewvect     = [-82, 5];
      viewstruct.lightpos     = [85,0, 0];    
end
%Prepare for plotting
set(gcf,'color','w');
hold on;

markers = '+o*.xsd^v><ph'; %electrode marker type for each subject
colours = {'r', 'g', 'b', 'y'};
if exist('subjstructs', 'var'), Ss = length(subjstructs); else Ss = 0; end
colormap(gca,'Bone');

%Please specify viewstruct.what2view (see above in comments) if you want to display the brain and/or the activations
%grey brain:
I = strmatch('brain', viewstruct.what2view,'exact');
I2 = strmatch('cortexcolor', viewstruct.what2view,'exact');
if ~isempty(I) && isempty(I2),
    trisurf(M.tri, M.vert(:, 1), M.vert(:, 2), M.vert(:, 3), 'FaceVertexCData', [0.9 0.9 0.9], 'CDataMapping', 'direct', 'linestyle', 'none', 'FaceAlpha', transp);
end
%activations on it:
I = strmatch('activations', viewstruct.what2view,'exact');
if ~isempty(I),
    trisurf(M.tri, M.vert(:, 1), M.vert(:, 2), M.vert(:, 3), 'FaceVertexCData', Cindexed, 'FaceColor', 'interp', 'CDataMapping', 'direct', 'linestyle', 'none');
end
I2 = strmatch('cortexcolor', viewstruct.what2view,'exact');
if ~isempty(I2)
    load('MATLAB\Cortex_Center.mat');
    Color_Cindex=repmat([0.9 0.9 0.9],length(M.vert),1);
     if subjstructs(1).electrodes(1)<0
        Color_Cindex(MCTX(2).Cortex_Color(:,1),:)=MCTX(2).Cortex_Color(:,2:4);
     else
        Color_Cindex(MCTX(1).Cortex_Color(:,1)+length(MCTX(2).vert),:)=MCTX(1).Cortex_Color(:,2:4);
     end
    hh=trisurf(M.tri, M.vert(:, 1), M.vert(:, 2), M.vert(:, 3),  'FaceVertexCData',  Color_Cindex, 'FaceColor', 'interp', 'CDataMapping', 'direct', 'linestyle', 'none','FaceAlpha',transp);%0.1
    set(hh,'FaceLighting','phong','AmbientStrength',0.5);
end
if viewstruct.enableaxis,
    axis equal;        
else
    axis equal off;
end
view(viewstruct.viewvect);
material(viewstruct.material);
if viewstruct.enablelight,
    light('Position', viewstruct.lightpos, 'Style', 'infinite');
end
lighting(viewstruct.lightingtype);

%Please specify viewstruct.what2view (see above in comments) if you want to display the electrodes
for k = 1 : Ss;
    %original electrode locations:       
    I = strmatch('electrodes', viewstruct.what2view,'exact');
    if ~isempty(I),
        plotBalls(subjstructs(k).electrodes, [0 0 0], 0.8);
%         plotBalls(subjstructs(k).electrodes, 'green', 1.2);
%         plotBalls(subjstructs(k).electrodes(best_channel,:),'red',1.5);
          plotBalls(subjstructs(k).electrodes(channel_transform,:),'red',1.2);
%         patch(subjstructs(k).electrodes(:, 1), subjstructs(k).electrodes(:, 2), subjstructs(k).electrodes(:, 3), colours{k}, 'FaceColor', 'none', 'LineStyle', 'none', 'Marker', markers(k + Ss), 'MarkerEdgeColor', colours{k}, 'MarkerFaceColor', 'none');
    end

    %transformed electrode locations
    I = strmatch('trielectrodes', viewstruct.what2view,'exact');
    if ~isempty(I),
         plotBalls(subjstructs(k).trielectrodes, 'red', 1.2);
%          plotBalls(subjstructs(k).trielectrodes(best_channel,:), 'red', 2);
%         patch(subjstructs(k).trielectrodes(:, 1), subjstructs(k).trielectrodes(:, 2), subjstructs(k).trielectrodes(:, 3), colours{k}, 'FaceColor', 'none', 'LineStyle', 'none', 'Marker', markers(k), 'MarkerEdgeColor', colours{k}, 'MarkerFaceColor', 'none');
    end

    fprintf('done\n');
end

xlabel('x');
ylabel('y');
zlabel('z');
axis off
hold off;