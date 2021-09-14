function fastrun(subjectID,ixv,cortexcolor,activ)
placeToSaveFile = strcat(cd, '/MATLAB/', subjectID, '.mat');
% mkdir(strcat(pathToSubjectDir, '/MATLAB/'));
load(placeToSaveFile);

%% Display options
fprintf('what2view - a column cell of strings specifying what\nshall be visualized:\npossible values: ''brain'' - shows the grey brain\n''activations'' - shows the activations\n''electrodes'' - shows the original electrode locations\n''trielectrodes'' - shows the projected electrode locations\n(e.g. {''brain'', ''activations''} )\n');
viewstruct.what2view = input('Enter what2view: ');
param.electrodes_pos = input('What side of the brain do you want to view? ("front"|"top"|"lateral"|"isometric"|"right"|"left"): ');


% if strcmp(param.electrodes_pos,'right')
%     viewstruct.viewvect     = [90, 0];
%     viewstruct.lightpos     = [150, 0, 0];
% elseif strcmp(param.electrodes_pos,'left')
%     viewstruct.viewvect     = [-104, 15];
%     viewstruct.lightpos     = [-150, -30, 0];
%     
% end

if strcmp(param.electrodes_pos,'front')
%%%%%front view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   viewstruct.lightpos=[0,180,0];
    viewstruct.viewvect=[180,0];
elseif strcmp(param.electrodes_pos,'top')
%%%%%top view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    viewstruct.lightpos=[0,0,80];
    viewstruct.viewvect=[0,90];
elseif strcmp(param.electrodes_pos,'lateral')
%%%%%lateral view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   viewstruct.lightpos=[-80,0,0];
   viewstruct.viewvect=[-90,0];
elseif strcmp(param.electrodes_pos,'isometric')
%%%%%isometric view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   viewstruct.lightpos=[-100,80,45];
   viewstruct.viewvect=[-108,30];
   
elseif strcmp(param.electrodes_pos,'right')
     viewstruct.viewvect = [110, 0];
     viewstruct.lightpos = [150, 0, 0];
elseif strcmp(param.electrodes_pos,'left')
     viewstruct.viewvect = [270, 0];
     viewstruct.lightpos = [-150,0, 10];   
else
    error('wrong input, check your spelling');
end


viewstruct.material     = 'dull';
viewstruct.enablelight  = 1;
viewstruct.enableaxis   = 0;
viewstruct.lightingtype = 'gouraud';
viewstruct.enablecortexcolor=cortexcolor;
viewstruct.enablewhitematter=0;

II = strmatch('activations', viewstruct.what2view,'exact');
if ~isempty(II),
    cmapstruct.basecol          = [0.97, 0.92, 0.92];
else
    cmapstruct.basecol          = [0.8, 0.8, 0.8];
end
cmapstruct.fading           = true;
cmapstruct.enablecolormap   = true;
cmapstruct.enablecolorbar   = true;
cmapstruct.color_bar_ticks  = 4;

% ix = 1;
ix=ixv;
tala.activations(:,ix)=activ;
%% Brain activation plot
cmapstruct.cmap = colormap('Jet'); close(gcf); %because colormap creates a figure
cmapstruct.ixg2 = floor(length(cmapstruct.cmap) * 0.15);
cmapstruct.ixg1 = -cmapstruct.ixg2;

cmapstruct.cmin = -log(0.01/length(tala.activations));
%cmapstruct.cmin = 0*max(tala.activations(:,ix));
cmapstruct.cmax = 0.85*max(tala.activations(:,ix));

%figure('visible', 'on');
%set(gcf,'Color','w');

% run activateBrain to generate the visualization
activateBrain(cortex, vcontribs, tala, ix, cmapstruct, viewstruct);
end
