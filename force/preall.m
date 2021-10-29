eeglabpath='/Users/long/BCI/matlab_scripts/eeglab2020_0';
%addpath(eeglabpath);
sessions=4;
useChannels=[1:15,17:29,38:119];
power1='8-30';
fs_res=1000;
fs=1000;
Fs=2000;
global processed_data root_path activeChannels;
root_path='/Users/long/Documents/BCI/matlab_scripts/force/';
processed_data='/Users/long/Documents/BCI/matlab_scripts/force/data/';
%activeChannels=[8 9 10 18 19 20 21 22 23 24 62 63 69 70 105 107 108 109 110];
activeChannels=[8 9 10 18 19 20 21 22 23 24 38 39 60 61 62 63 64 68 69 70 87 88 89 97 98 104 107 108 109 110];

%badtrial{1}=[7:30,38];
%badtrial{2}=[21,23,24,28];
%badtrial{3}=[2,4,8,11:30,31];
%badtrial{4}=[11,13,15,17,21,23:27,29,30];

% less strictly on bad trials
badtrial{1}=[22,23,24,26];
badtrial{2}=[23,24,28];
badtrial{3}=[4,8,11,16,21:25,29];
badtrial{4}=[24,29];

for i=[1:4]
    goodtrial{i}=setdiff(1:40,badtrial{i});
end







