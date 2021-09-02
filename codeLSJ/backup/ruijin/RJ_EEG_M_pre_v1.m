% function RJ_EEG_M_pre_v1
clear all;clc;
pn=1;

address=strcat('/Volumes/lsj/RJ_M_preprocessing_data/P',num2str(pn)); %mac
if ~exist(address,'dir')
    mkdir(address);
end
cd(address);

Folder=strcat('/Volumes/lsj/RJ_M_preprocessing_data/P',num2str(pn),'/preprocessing');
if ~exist(Folder,'dir')
    mkdir(Folder);
end



strname=strcat('/Volumes/lsj/RJ_M_Raw_Data/P',num2str(pn),'/H1.mat');
load(strname);


data=double(EEG.data);
Fs = EEG.srate;

triggerNum = size(EEG.event, 2);
triggerInf = zeros(triggerNum-2, 2);   % 第一个和最后一个trigger去掉.
for i=2:triggerNum-1
    
    logicpos=isstrprop(EEG.event(:,i).type,'digit');
    digpos=str2double(EEG.event(:,i).type(logicpos));
    
    triggerInf(i-1,1:2)=[EEG.event(:,i).latency digpos];  
end


%      ___________________________________________________________________
%      **********************filter the EEG signal************************

data=data';

goodChannels = remove_bad_channels(data, Fs, 10);
data = data(:, goodChannels);

channelNum = size(data, 2);
OME=[0.5, 400];
data = cFilterD_EEG(data, channelNum, Fs, 2, OME);

meanval = mean(data, 2);
data = data-repmat(meanval,1,size(data,2));



strname = strcat('/Volumes/lsj/RJ_M_preprocessing_data/P',num2str(pn),'/preprocessing/preprocessingAll_v1.mat');
save(strname,'data', 'triggerInf', 'Fs', '-v7.3');



