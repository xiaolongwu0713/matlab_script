clear;clc;
%%
% p1,p2,p3 trigger 标记方式和之后的不一致.
% p4 范式时间预值和之后的不一致.
% p8 trigger的时间全乱. trigger[359,360]是两个session交替.
SessionInf = [1 3 3 2 2 2 2 1 2 1 2 2];
%% load data.
% subj = 12;
% address=strcat('D:/lsj/RJ_Raw_Data/P',num2str(subj)); %mac
% if ~exist(address,'dir')
%     mkdir(address);
% end
% Folder=strcat('D:/lsj/RJ_Raw_Data/P',num2str(subj),'/H2.mat');
% save(Folder, 'EEG'); % EEG.srate, data, event.

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