%% calculate the electrode contribution  by Guangye Li (liguangye.hust@Gmail.com)
%% 
addpath(genpath([cd,'/nicebrain']));
Electrode_Folder=[cd,'/BrainElectrodes/WholeCortex1.mat']; % electrodes_Final_Anatomy_wm_All.mat.input electrode file folder here
Brain_Model_Folder=[cd,'/BrainElectrodes/electrodes_Final_Norm.mat'];% input brain cortex file folder here
load(Electrode_Folder);
load(Brain_Model_Folder);
%%
Etala.electrodes=cell2mat(elec_Info_Final_wm.pos');
view_vect = input('What side of the brain do you want to view? ("front"|"top"|"lateral"|"isometric"|"right"|"left"): ');
viewBrain(cortex, Etala, {'brain','electrodes'}, 0.1, 50, view_vect); % 0.1
axis off;
colorbar off