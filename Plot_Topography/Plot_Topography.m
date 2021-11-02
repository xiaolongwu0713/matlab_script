%% calculate the electrode contribution  by Guangye Li (liguangye.hust@Gmail.com)
%%
addpath(genpath([cd,'\nicebrain']));
activations(:,1)=Etala.ele_activation_gamma; % here put the activation value of each contact to variable: activations
%%
plotbrainfunction(cortex.vert, cortex.tri, Etala, activations, NormSubj, subject_directory);
% check the meanings of each input, cortex: brain model. Etala: electrode locations
% some information for Etala for reference.
% Etala.pos=elec_Info_Final.pos];
% Etala.name=elec_Info_Final.name;
% Etala.ana_label_name=elec_Info_Final.ana_label_name;
% Etala.number=length(elec_Info_Final.pos);
colorbar off;
%% 
%  input {'brain','activations'} to show topography~

%% Notice by Guangye Li (liguangye.hust@Gmail.com)
% save('vcontribs') for each contact so that don't need to run above
% process again. Show activation map directly 

