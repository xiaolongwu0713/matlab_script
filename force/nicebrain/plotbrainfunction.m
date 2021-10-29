function plotbrainfunction(a, b, c, d, e, f)

cortex.vert = a;
cortex.tri = b;
tala.electrodes = c.electrodes;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tala.number=c.number;
tala.name=c.name; 
%%%%%new add by GY Li
tala.activations = d;
subjectID = e;
pathToSubjectDir = f;

%% Brain model calculation

%%%%updated by Guangyeli @liguangye.hust@Gmail.com @USA @2018.02.01
% opengl neverselect
% load(strcat(f,'/MATLAB/WholeCortex.mat'));
%Make the model coarser:
handles.eleIndex=1;
handles.normdist=25;
tala=projectElectrodesDepthGrid(pathToSubjectDir,tala,handles);
% load(strcat(pathToSubjectDir,'/MATLAB/WholeCortex.mat'));

% cortexcoarser = coarserModel(cortex, 10000);
% cortexcoarser_left = coarserModel(leftcortex, 10000);
% cortexcoarser_right = coarserModel(rightcortex, 10000);
%Use the coarse model and make it smoother:
% origin = [0 20 40];
% smoothrad = 25;
% mult = 0.5;
% 
% %(See also |smoothModel| for further information on the arguments used)
% [cortexsmoothed_left] = smoothModel(cortexcoarser_left, smoothrad, origin, mult);

%Compute the convex hull:
% cortex_convex_left = hullModel(cortexcoarser_left);
% cortex_convex_right = hullModel(cortexcoarser_right);
% cortex_convex.tri=[cortex_convex_left.tri;cortex_convex_right.tri+size(cortex_convex_left.vert,1)];
% cortex_convex.vert=[cortex_convex_left.vert;cortex_convex_right.vert];
% cortex_convex=hullModel(cortexsmoothed);

%This deprives the brain model of the sulci
% figure()
% trisurf(cortex_convex.tri,cortex_convex.vert(:,1),cortex_convex.vert(:,2),cortex_convex.vert(:,3),'EdgeColor',[0 0 0],'FaceColor',[0.8 0.8 0.8],'FaceAlpha',0.5);

%makes concave hull (as opposed to convex)
% this makes for better projection near end of temporal lobe
% second parameter controls concavity, inf = no concavity = cortex_convex
% 10 is reasonable to preserve concavity without taking too long
% figure
% [v, s] = alphavol(cortex.vert, inf, 1);

% s.bnd contains the boundary facets
% alphacortex.vert = cortex.vert;
% alphacortex.tri = s.bnd;
% alphacortexcoarser = coarserModel(alphacortex, 0.6);
% trisurf(alphacortexcoarser.tri,alphacortexcoarser.vert(:,1),alphacortexcoarser.vert(:,2),alphacortexcoarser.vert(:,3),'EdgeColor',[0 0 0],'FaceColor',[0.7 0.7 0.7],'FaceAlpha',0.8);
%Projecting the electrodes
% normdist = 45;
% [ tala ] = projectElectrodes(cortexcoarser, tala, normdist);
% [ tala2 ] = projectElectrodes(alphacortexcoarser, tala, normdist); %
%commented out by adriana
% tala.trielectrodes = tala.electrodes;
% trisurf(cortexcoarser_left.tri,cortexcoarser_left.vert(:,1),cortexcoarser_left.vert(:,2),cortexcoarser_left.vert(:,3),'EdgeColor',[0 0 0],'FaceColor',[0.7 0.7 0.7],'FaceAlpha',0.8);
% plotBalls(tala.trielectrodes,'g',2);
% hold on
% plotBalls(tala.electrodes,'r',2);
% tala.trielectrodes(120,:)=[nan,nan,nan];
%Computing the electrode contributions
%Compute the contributions of the given electrodes:
kernel = 'gaussian';
parameter = 10;
cutoff = 10;
Dis_surf=15;
%See also |electrodesContributions| for a more thorough information on its arguments)
[ vcontribs ] = electrodesContributions( cortex, tala, kernel, parameter, cutoff, Dis_surf);
% normalizing vcontribs by number of electrodes 
vcontribs_norm = vcontribs;
 
for idx=1:length(vcontribs),
    
    v_norm = sum(vcontribs(idx).contribs(:,3));
    
    if size(vcontribs(idx).contribs,1) > 1,
        
        vcontribs_norm(idx).contribs(:,3) = vcontribs(idx).contribs(:,3) ./ v_norm;
        
    end
end
vcontribs=vcontribs_norm;
%% Display options
fprintf('what2view - a column cell of strings specifying what\nshall be visualized:\npossible values: ''brain'' - shows the grey brain\n''activations'' - shows the activations\n''electrodes'' - shows the original electrode locations\n''trielectrodes'' - shows the projected electrode locations\n(e.g. {''brain'', ''activations''} )\n');
viewstruct.what2view = input('Enter what2view: ');
param.electrodes_pos = input('What side of the brain do you want to view? (''left'' | ''right''): ');


if strcmp(param.electrodes_pos,'right')
    viewstruct.viewvect     = [90, 0];
    viewstruct.lightpos     = [150, 0, 0];
elseif strcmp(param.electrodes_pos,'left')
%     viewstruct.viewvect     = [270, 0];
    viewstruct.viewvect     = [-104, 15];
    viewstruct.lightpos     = [-150, -30, 0];
    
end

viewstruct.material     = 'dull';
viewstruct.enablelight  = 1;
viewstruct.enableaxis   = 0;
viewstruct.lightingtype = 'gouraud';
viewstruct.enablecortexcolor=0;
viewstruct.enablewhitematter=0;

II = strmatch('activations', viewstruct.what2view,'exact');
if ~isempty(II)
    cmapstruct.basecol          = [0.97, 0.92, 0.92];
else
    cmapstruct.basecol          = [0.7, 0.7, 0.7];
end
cmapstruct.fading           = true;
cmapstruct.enablecolormap   = true;
cmapstruct.enablecolorbar   = true;
cmapstruct.color_bar_ticks  = 4;

ix = 1;


%% Brain activation plot
cmapstruct.cmap = colormap('Jet'); close(gcf); %because colormap creates a figure
cmapstruct.ixg2 = floor(length(cmapstruct.cmap) * 0.15);
cmapstruct.ixg1 = -cmapstruct.ixg2;

cmapstruct.cmin = 0;
cmapstruct.cmax = max(tala.activations(:,ix));

%figure('visible', 'on');
%set(gcf,'Color','w');

% save the activateBrain structure in subjectDir/MATLAB
placeToSaveFile = strcat(pathToSubjectDir, '/MATLAB/', subjectID, '.mat');
save(placeToSaveFile, 'cmapstruct', 'cortex', 'ix', 'tala', 'vcontribs', 'viewstruct');

% run activateBrain to generate the visualization
activateBrain(cortex, vcontribs, tala, ix, cmapstruct, viewstruct);

% uncomment to view the convex hull
%activateBrain(cortex_convex, vcontribs, tala, ix, cmapstruct, viewstruct );

end % end of function

