function roi_surface_add(roi,roi_col)
% this is a cannibalized function for adding colored ROI surfaces to brain
% plots kjm 5/15, cannibalized from    K.J. Miller & D. Hermes, ctmr package
%  

%% make colormap to reflect

if exist('roi_col')~=1, roi_col=-4; end
% make sure brain doesn't change color

cm=.7+zeros(9,3); %all gray (brain)
cm(1,:)=[1 0 0]; % -4 =red
cm(2,:)=[1 .5 0]; % -3 = orange
cm(3,:)=[1 1 0]; % -2 = yellow
cm(4,:)=[0 1 0]; % -1 = green
cm(6,:)=[0 0 1]; % 1 =blue
cm(7,:)=[.7 .4 1]; % 2 = indigo
cm(8,:)=[1 0 1]; % 3 = pink
cm(9,:)=[.2 .2 .2]; % 4 = dark gray


%%



% NOTE CAN HAVE IT FEED VERTEX INDICES IF DIFFERENT SURFACE COLORS ARE
% DESIRED -- THEN CUSTOM MAKE COLORMAPS, ETC AND COLOR SURFACE 

% c=ones(length(roi.vert(:,1)),1)*roi_col;
c=roi_col*ones(length(roi.vert(:,1)),1).'; % set all to the same color

%%
    a=tripatch(roi, 'nofigure', c');
    shading interp;
    a=get(gca);
    
%%NOTE: MAY WANT TO MAKE AXIS THE SAME MAGNITUDE ACROSS ALL COMPONENTS TO REFLECT
%%RELEVANCE OF CHANNEL FOR COMPARISON's ACROSS CORTICES
    d=a.CLim;
    set(gca,'CLim',4*[-1 1])
%     l=light;
    colormap(cm)
%     lighting gouraud; %play with lighting...
    % material dull;
    material([.3 .8 .1 10 1]);
    axis off
    set(gcf,'Renderer', 'zbuffer')
