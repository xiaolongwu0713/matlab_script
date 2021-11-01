function plotbrainfunction(a, b, c, d, e, f)

cortex.vert = a;
cortex.tri = b;
tala.electrodes = c;
tala.activations = d;
subjectID = e;
pathToSubjectDir = f;

%% Brain model calculation
opengl neverselect

%Make the model coarser:
%cortexcoarser = coarserModel(cortex, 10000);

%Use the coarse model and make it smoother:
%origin = [0 20 40];
%smoothrad = 25;
%mult = 0.5;
% 
% %(See also |smoothModel| for further information on the arguments used)
%[cortexsmoothed] = smoothModel(cortexcoarser, smoothrad, origin, mult);

%Compute the convex hull:
% cortex_convex = hullModel(cortexcoarser);
%This deprives the brain model of the sulci

% makes concave hull (as opposed to convex)
% this makes for better projection near end of temporal lobe
% second parameter controls concavity, inf = no concavity = cortex_convex
% 10 is reasonable to preserve concavity without taking too long
[v, s] = alphavol(cortex.vert, inf, 1);

% s.bnd contains the boundary facets
alphacortex.vert = cortex.vert;
alphacortex.tri = s.bnd;

alphacortexcoarser = coarserModel(alphacortex, 10000);

%Projecting the electrodes
normdist = 40;
%[ tala ] = projectElectrodes(cortex_convex, tala, normdist);
%[ tala ] = projectElectrodes(alphacortexcoarser, tala, normdist); %
%commented out by adriana
tala.trielectrodes = tala.electrodes;


%Computing the electrode contributions
%Compute the contributions of the given electrodes:
kernel = 'linear';
parameter = 10;
cutoff = 10;

%See also |electrodesContributions| for a more thorough information on its arguments)
[ vcontribs ] = electrodesContributions( cortex, tala, kernel, parameter, cutoff);


%% Display options
fprintf('what2view - a column cell of strings specifying what\nshall be visualized:\npossible values: ''brain'' - shows the grey brain\n''activations'' - shows the activations\n''electrodes'' - shows the original electrode locations\n''trielectrodes'' - shows the projected electrode locations\n(e.g. {''brain'', ''activations''} )\n');
viewstruct.what2view = input('Enter what2view: ');
param.electrodes_pos = input('What side of the brain do you want to view? (''left'' | ''right''): ');


if strcmp(param.electrodes_pos,'right')
    viewstruct.viewvect     = [90, 0];
    viewstruct.lightpos     = [150, 0, 0];
elseif strcmp(param.electrodes_pos,'left')
    viewstruct.viewvect     = [270, 0];
    viewstruct.lightpos     = [-150, 0, 0];
end

viewstruct.material     = 'dull';
viewstruct.enablelight  = 1;
viewstruct.enableaxis   = 0;
viewstruct.lightingtype = 'gouraud';

cmapstruct.basecol          = [0.7, 0.7, 0.7];
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
cmapstruct.cmax = max(tala.activations);

%figure('visible', 'on');
%set(gcf,'Color','w');

% save the activateBrain structure in subjectDir/MATLAB
placeToSaveFile = strcat(pathToSubjectDir, '/MATLAB/', subjectID, '.mat');
mkdir(strcat(pathToSubjectDir, '/MATLAB/'));
save(placeToSaveFile, 'cmapstruct', 'cortex', 'ix', 'tala', 'vcontribs', 'viewstruct');

% run activateBrain to generate the visualization
activateBrain(cortex, vcontribs, tala, ix, cmapstruct, viewstruct);

% uncomment to view the convex hull
%activateBrain(cortex_convex, vcontribs, tala, ix, cmapstruct, viewstruct );

end % end of function

