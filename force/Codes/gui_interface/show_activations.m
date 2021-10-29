function show_activations(handles)
%% calculate the electrode contribution  by Guangye Li (liguangye.hust@Gmail.com)
%%
addpath(genpath([cd,'/force/nicebrain']));
subjectPath=[cd,'/force/PF6_SYF_2018_08_09_Simply/BrainElectrodes'];
Electrode_Folder=[subjectPath,'/electrodes_Final_Anatomy_wm.mat']; 
Brain_Model_Folder=[subjectPath,'/WholeCortex.mat'];
load(Electrode_Folder);
load(Brain_Model_Folder);
load([cd,'/force/activation_data/MATLAB/Etala_p1.mat']);
load([cd,'/force/activation_data/MATLAB/Etala.mat']);
load([cd,'/force/activation_data/MATLAB/SYF.mat']);
% for T=2:140
% activations(:,1)=Etala_p1_single.activations_gamma(:,T);  % here put the activation value of each contact to variable: activations
activations(:,1)=Etala_p1.activations_transform(:,handles.T);  
% subjectID = '2';
% pathToSubjectDir ='G:/��ҵ��Ʊ���/��ҵ���/Plot_Topography/Plot_Topography/activation_data' ;
%%
tala.activations = activations;
% cmapstruct.basecol          = [0.97, 0.92, 0.92];
% 
% cmapstruct.fading           = true;
% cmapstruct.enablecolormap   = true;
% cmapstruct.enablecolorbar   = true;
% cmapstruct.color_bar_ticks  = 4;
%% Brain activation plot
% cmapstruct.cmap = colormap('Jet');  %because colormap creates a figure
% cmapstruct.ixg2 = floor(length(cmapstruct.cmap) * 0.15);
% cmapstruct.ixg1 = -cmapstruct.ixg2;
% 
% cmapstruct.cmin = 0;
% cmapstruct.cmax = max(tala.activations(:,1));
% cla
% plotbrainfunction(cortex.vert, cortex.tri, Etala, activations,'SYF',subjectPath);  
activateBrain(cortex, vcontribs, tala, 1, cmapstruct, viewstruct);
colorbar off;
%% 
%  input {'brain','activations'} to show topography~
%% Notice by Guangye Li (liguangye.hust@Gmail.com)
% save('vcontribs') for each contact so that don't need to run above
% process again. Show activation map directly 
% saveas(gcf,['./','time=',num2str(1.2+(T-2)/10),'.jpg'])
% end
end
 