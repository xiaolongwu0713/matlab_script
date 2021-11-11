clear;clc;
%%
% p1,p2,p3 trigger 标记方式和之后的不一致.
% p4 范式时间预值和之后的不一致.
% p8 trigger的时间全乱. trigger[359,360]是两个session交替.
SessionInf = [1 3 3 2 2 2 2 1 2 1 2 2];
%%
global data_dir;
if strcmp(strip(computer),'longsMac')
    data_dir='/Volumes/Samsung_T5/data/ruijin/gonogo/';
    eeglab_path='/Users/long/Documents/BCI/matlab_plugin/eeglab2021.1';
    addpath(eeglab_path);
elseif strcmp(strip(computer),'workstation') | strcmp(strip(computer),'PCWIN64')
    data_dir='H:/Long/data/ruijin/gonogo/';
    eeglab_path=['C:/Users/wuxiaolong/Desktop/BCI/eeglab2021.1'];
    comm_path=['C:/Users/wuxiaolong/Desktop/BCI/matlab_script/common'];
    addpath(eeglab_path);
    addpath(comm_path);
end
%%
for subj = [5:7 9:12] %:length(SessionInf)
%for subj = [5] %:length(SessionInf)
%%
RJ_EEG_pre_v2(subj, SessionInf(subj));

%%
RJ_EEG_analysis_v4(subj, SessionInf(subj))
%RJ_EEG_analysis_v5(subj, SessionInf(subj));

%RJ_EEG_analysis_v6(subj, SessionInf(subj));
% close all;
end