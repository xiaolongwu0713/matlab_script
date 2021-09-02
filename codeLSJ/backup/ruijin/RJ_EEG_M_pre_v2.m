% function RJ_EEG_M_pre_v1
clear all;
clc;
pn=2;

address=strcat('/Volumes/Samsung_T5/data/ruijin/MI/RJ_MI_preprocessing_data/P',num2str(pn)); %mac
if ~exist(address,'dir')
    mkdir(address);
end
cd(address);

Folder=strcat('/Volumes/Samsung_T5/data/ruijin/MI/RJ_MI_preprocessing_data/P',num2str(pn),'/preprocessing');
if ~exist(Folder,'dir')
    mkdir(Folder);
end

SubInfo.UseChn = [1:179];
SubInfo.EmgChn = [180];

strname=strcat('/Volumes/Samsung_T5/data/ruijin/MI/RJ_MI_Raw_Data/P',num2str(pn),'/H1.mat');
load(strname);


data=double(EEG.data(SubInfo.UseChn, :)');
EMGdata = double(EEG.data(SubInfo.EmgChn, :)');
Fs = EEG.srate;

triggerNum = size(EEG.event, 2) - 5;
for i=2:triggerNum + 1
    
    logicpos=isstrprop(EEG.event(:,i).type,'digit');
    digpos=str2double(EEG.event(:,i).type(logicpos)); % logical indexing
    
    triggerInf(i-1,1:2)=[EEG.event(:,i).latency digpos];  
end

trialInx = find(triggerInf(:, 2) == 1);
trialNum = length(trialInx);

ftrLabel = zeros( size(data, 1), 1 );
ftrLabel(triggerInf(trialInx, 1), 1) = triggerInf(trialInx + 1, 2) - 20;

figure(1);clf;
plot(ftrLabel);
title('trigger5Task');
%      ___________________________________________________________________
%      **********************filter the EMG signal************************
    
    nEMG = size(EMGdata, 2);
    
    %      	Notch IIRCOMB filter
    F0=50;q=30;
    n=round(Fs/F0);
    bw=(F0/(Fs/2))/q;
    [B,A] = iircomb(n, bw, 'notch');  % 50Hz 'notch'
    EMGdata(:,1:nEMG)=filtfilt(B,A,EMGdata(:,1:nEMG));
    
    
    %    	Bandpass filter
    w0=[1.5/(Fs/2),150/(Fs/2)];
    [B,A]=butter(4,w0);
    EMGdata(:,1:nEMG)=filtfilt(B,A,EMGdata(:,1:nEMG));
    
  badTrials   = [];
  for i = 1: trialNum
%     figure (i+1);clf;
%     plot(EMGdata( triggerInf(trialInx(i), 1):  triggerInf(trialInx(i)+3, 1) + 2.5*Fs));
%     title(['EMGdata of ',num2str(ftrLabel(trialInx(i), 1))])
    
      % remove bad trials.
      baseMean5EMG = mean( abs(EMGdata( triggerInf(trialInx(i), 1):  triggerInf(trialInx(i)+3, 1) - 1*Fs )));
      taskMean5EMG = mean( abs(EMGdata( triggerInf(trialInx(i)+3, 1):  triggerInf(trialInx(i)+3, 1) + 1*Fs)));
      if  ( floor(ftrLabel(triggerInf(trialInx(i), 1), 1)/4) && taskMean5EMG > 2*baseMean5EMG) || ( ~floor(ftrLabel(triggerInf(trialInx(i), 1), 1)/4) && taskMean5EMG < 2*baseMean5EMG)
              badTrials = [badTrials, i];
      end
  end

  ftrLabel(triggerInf(trialInx(badTrials), 1), 1) = -1;

%      ___________________________________________________________________
%      **********************filter the EEG signal************************


goodChannels = remove_bad_channels(data, Fs, 10);
data = data(:, goodChannels);

channelNum = size(data, 2);
OME=[0.5, 400];
data = cFilterD_EEG(data, channelNum, Fs, 2, OME);

meanval = mean(data, 2);
data = data-repmat(meanval,1,size(data,2));



strname = strcat('/Volumes/Samsung_T5/data/ruijin/MI/RJ_MI_preprocessing_data/P',num2str(pn),'/preprocessing/preprocessingAll_v2.mat');
save(strname,'data', 'ftrLabel', 'Fs', '-v7.3');



