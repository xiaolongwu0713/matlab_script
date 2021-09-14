function Data=Filter_EMG_Chn(data,Fs,ome)
% This function is to filter and store the correct EMG channels to be used
% when the subject performing the task
% by Liguangye (liguangye.hust@gmail.com)
data=double(data);
data=cFilterD_EMG(data,2,Fs,2,ome); % Filter the raw EMG signal
Data=data(:,1)-data(:,2);% differential EMG data
end