data_dir='/Volumes/Samsung_T5/data/simit/XY20210823/CCEP_1/preprocessing/raw_EEG.mat';
load(data_dir);
data=EEG.data;
events=EEG.event;
eeglab redraw;
fs=4000;
latency=events.latency;


data_sub=zeros(size(data,1)-1, size(data,2));
for rowi = 1:size(data_sub,1)
    data_sub(rowi,:)=data(rowi+1,:)-data(rowi,:);
end

achn=data_sub(25,40*fs:60*fs);
















