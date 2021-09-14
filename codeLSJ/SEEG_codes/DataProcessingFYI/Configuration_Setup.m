pn=29; % Update this for each subject %subject no.
class=1;
address=pwd;
strname=strcat('C:\Files\Raw_Data\P',num2str(pn),'\1_Raw_Data_Transfer\','P',num2str(pn),'_H1_1_Raw.mat');
load(strname);
fprintf('Check the information of the dataset and update the \n');
fprintf('information below,press enter if you finished updating\n');
eeglabpath=['C:\Files\MATLAB\eeglab_current\eeglab13_6_5b'];
addpath(eeglabpath);
%%
Fs=1000;
% eeglab;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SubInfo.Session_num=[1,2];
SubInfo.UseChn=[1:15,17:29,38:119];
SubInfo.EmgChn=[120:121];
SubInfo.TrigChn=[30:34];
bandf=[53,145];
thre=10;
clear Data;
% input('')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%