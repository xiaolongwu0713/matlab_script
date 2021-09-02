%% ------------------------------------------------------------------------------------------------ %%
% load data
pn = 2;
address=strcat('/Volumes/Samsung_T5/data/ruijin/RJ_M_Raw_Data/P',num2str(pn)); 
if ~exist(address,'dir')
    mkdir(address);
end
Folder=strcat('/Volumes/Samsung_T5/data/ruijin/RJ_M_Raw_Data/P',num2str(pn),'/A1.mat');
save(Folder, 'EEG','-v7.3'); % EEG.srate, data.
%% ------------------------------------------------------------------------------------------------ %%
RJ_EEG_M_pre_v1;
%% ------------------------------------------------------------------------------------------------ %%
RJ_EEG_M_anls_v1;