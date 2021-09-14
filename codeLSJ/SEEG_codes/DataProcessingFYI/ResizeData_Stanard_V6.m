function [ RsData ] = ResizeData_Stanard_V6( rawdata,Fs,Duration,session)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This function is written to resize the rawdata to the standard size
%   fea_Label is the label vector that mark the index of classes appeared
%   during the experiments.
%   Fs is the sampling rate of the data.
%   Duration is the duration of each motion.
%   TRIAL_NUM is the number of trials run in the experiment.
%   duration*Fs (Rest) - duration*Fs (Motion)
%   RsData is the resized data. Shall use Getmarker.m first.
%   written by Liguangye (liguangye.hust@gmail.com) @2016.04.27 @SJTU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  use this function after the using the function :"Load_Resize_V2"
%  shift the index point back 200ms, because the movement generally
%  starts from the 500ms after the trigger onset. updated by LGY
%  @2016.09.05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H=size(rawdata,2);
fea_label=rawdata(:,end);% last column is the feal_label data
index=find(fea_label~=0);
EMG_marker=Cal_Latency_EMG_V2(rawdata(:,end-1),fea_label);% the end-1 column is the EMG data;
index_emg=find(EMG_marker~=0);
rawdata(:,end)=zeros(size(rawdata,1),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% plot the shift result %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
clf;
plot([200*fea_label,EMG_marker*500,abs(rawdata(:,end-1))]);
fprintf('check the shift result here~, if OK press enter to continue');
input('');
fprintf('Programs goes down~');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(index_emg)<length(index)
    valuemarkindex=zeros(length(index_emg),1);
    
    for i=1:length(index_emg)
        for j=1:length(index)
            if index_emg(i)>=index(j) && index_emg(i)<=(index(j)+4500)
                valuemarkindex(i)=j;
            end
        end
    end
    meantime=abs(mean(index_emg-index(valuemarkindex)))-100;
    %     meantime=meantime-100;% shift for measuring errors;
    for i=valuemarkindex
        rawdata(index_emg(i)-100:(index_emg(i)-100+Duration*Fs-1),end)=fea_label(index(i));
    end
    valueleft=setdiff([1:length(index)],valuemarkindex);
    for i=valueleft
        rawdata(index(i)+meantime:(index(i)+meantime+Duration*Fs-1),end)=fea_label(index(i));
    end
    
else
    for i=1:length(index)
        rawdata(index_emg(i)-100:(index_emg(i)-100+Duration*Fs-1),end)=fea_label(index(i));
    end
    meantime=abs(mean(index_emg-index))-100; % get mean latency
    
end
save(strcat('meantime_',num2str(session)),'meantime');
%%%%%%%%%%%%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%%%%%%%%%%%shall get the delay for each trial
% RsData=zeros(index(end)-index(1)+1+2*Duration*Fs,H);
RsData=rawdata;
end

