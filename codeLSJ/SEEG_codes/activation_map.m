clear all;
clc;
%cd 'Plot_Topography';


%% Localization of Electrodes 3D Coordinates
addpath(genpath([cd,'/nicebrain']));
Electrode_Folder=[cd,'/ShuYunFan/Electrodes/electrodes_Final_Anatomy_wm_All.mat']; % input electrode file folder here
Brain_Model_Folder=[cd,'/ShuYunFan/BrainModel/WholeCortex.mat'];% input brain cortex file folder here
load(Electrode_Folder);
load(Brain_Model_Folder);

Etala.electrodes=cell2mat(elec_Info_Final_wm.pos');
view_vect = input('What side of the brain do you want to view? ("front"|"top"|"lateral"|"isometric"|"right"|"left"): ');
figure(1);clf;viewBrain(cortex, Etala, {'brain','trielectrodes'}, 0.4, 10, view_vect);
axis off;
colorbar off

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Demo%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is used for calculating and plotting different cortical     %
% regions, different color indicate different regions                     %
% figure(2);clf;
% Get_3D_Cortex_Center;
% Color_Mat=load('Cortex_Center.mat');
% load('Norm_Brain.mat');
% %
% Color_Cindex=repmat([0.7,0.7,0.7],length(cortex.vert),1);
% Color_Cindex(Color_Mat.MCTX(2).Cortex_Color(:,1),:)=Color_Mat.MCTX(2).Cortex_Color(:,2:4);
% Color_Cindex(Color_Mat.MCTX(1).Cortex_Color(:,1)+size(Color_Mat.MCTX(2).vert,1),:)=Color_Mat.MCTX(1).Cortex_Color(:,2:4);
% hh=trisurf(cortex.tri, cortex.vert(:, 1), cortex.vert(:, 2), cortex.vert(:, 3),  'FaceVertexCData',  Color_Cindex, 'FaceColor', 'interp', 'CDataMapping', 'direct', 'linestyle', 'none','FaceAlpha',1);%0.1
% set(hh,'FaceLighting','phong','AmbientStrength',0.5);
% material('dull');
% viewstruct.viewvect     = [110, 10];
% viewstruct.lightpos     = [150, 0, 0];
% view(viewstruct.viewvect);
% light('Position', viewstruct.lightpos, 'Style', 'infinite');
% axis equal off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Activation Map Visualization
% figure(3);clf;
% addpath(genpath([cd,'\nicebrain']));
% activations(:,1)=elec_Info_Final_wm.activation_gamma;% here put the activation value of each contact to variable: activations
% 
% Etala.pos=elec_Info_Final_wm.pos;
% Etala.name=elec_Info_Final_wm.name;
% Etala.ana_label_name=elec_Info_Final_wm.ana_label_name;
% Etala.number=[10 14 16 16 16 12 12 14];
% NormSubj='ShuYunFan';
% subject_directory=strcat(cd,'\ShuYunFan\BrainModel\WholeCortex');
% 
% plotbrainfunction(cortex.vert, cortex.tri, Etala, activations, NormSubj, subject_directory);
% % check the meanings of each input, cortex: brain model. Etala: electrode locations
% % some information for Etala for reference.
% % Etala.pos=elec_Info_Final.pos];
% % Etala.name=elec_Info_Final.name;
% % Etala.ana_label_name=elec_Info_Final.ana_label_name;
% % Etala.number=length(elec_Info_Final.pos);
% colorbar off;
%% 
%  input {'brain','activations'} to show topography~

%% Notice by Guangye Li (liguangye.hust@Gmail.com)
% save('vcontribs') for each contact so that don't need to run above
% process again. Show activation map directly 