eeglabpath='/Users/long/BCI/matlab_scripts/eeglab2020_0';
addpath(eeglabpath);
%eeglab;
seeg_channels=[1:15,17:29,38:119];
fs_res=1000;
global processed_data; session=1;
processed_data='/Users/long/Documents/BCI/matlab_scripts/force/data/';

%% Load SEEG
session=1;
data=load_data(session,'seeg'); %data=load_data(2,'force'); 
seeg=data.seeg;
channels=data.channels;
fs=data.fs;
seeg=resample(seeg',fs_res,fs)';
%filename=strcat(processed_data,'/SEEG_Data/','PF6_F_SEEG',num2str(session),'.mat');
%save(filename, 'seeg');

EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',seeg,'srate',1000,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','seeg','gui','off');
eeglab redraw;

%% Save trigger channel and Extract Trigger marker
trigger_channel=resample(data.trigger_channel,1000,2000);
filename=strcat(processed_data,'/Trigger_Data/','PF6_F_trigger_',num2str(session),'.mat');
save(filename,'trigger_channel');

load(filename);
trigger=get_trigger(trigger_channel);
trigger=get_trigger_norm(trigger_channel);
% remove last trigger
index=find(trigger,1,'last');
trigger(index)=0;
%check
plot(trigger);hold on; xticks(find(trigger));xticklabels([1:sum(trigger)]);

export_to_eeglab_event(trigger,session);
% get movement type info
schemadata=load_data(1,'trigger');
movement=schemadata.Exp_Seq; % movement=1,2,3,4
index=find(trigger);
trigger(index(1:40))=movement;
filename=strcat(processed_data,'/Trigger_Data/','PF6_F_movement_',num2str(session),'.mat');
save(filename, 'trigger');
% plot 10 target force
xaxis=schemadata.xaxis; % 40 cells containing 5 points each
yaxis=schemadata.yaxis;
for i=1:10
    subplot(2,5,i);
    x=xaxis(i);
    y=yaxis(i);
    plot(x{1},y{1});
end

% import event file into EEGLab
eventfile=strcat(processed_data,'/eeglab/',num2str(session),'_eventtable.txt');
EEG = pop_importevent( EEG, 'event',eventfile,'fields',{'type','latency','duration'},'timeunit',0.001);
eeglab redraw;

%% load force
force_data=load_data(1,'force');
force_tmp=force_data.force;
index = 2:2:length(force_tmp);
force = force_tmp(index);
time = force_tmp(index-1);

%% load emg TODO: remove the anormal lines
data=load_data(1,'emg'); %data=load_data(2,'force'); 
emg=data.emg;
EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',seeg,'srate',1000,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','emg','gui','off');
eeglab redraw;

%% load schema
schemadata=load_data(1,'trigger');
task_duration=schemadata.task_time;
trial_duration=schemadata.trial_length;
xaxis=schemadata.xaxis; % 40 cells containing 5 points each
yaxis=schemadata.yaxis;
movement=schemadata.Exp_Seq;
EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',Data,'srate',Fs,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','alldata','gui','off');
eeglab redraw;



%% Remove bad channels
fprintf('\n Analysis of bad channels');
both=split_good_bad_channels(seeg',session,fs,10); % split and save to good/bad file
good=both.good;
bad=both.bad;
% load saved data
filename=strcat(processed_data,'SEEG_Data/','PF6_F_SEEG',num2str(session),'good','.mat');
load(filename); % var:good
seeg=good;
%% Band-pass filter
% before
fprintf('\n High-pass filter of the SEEG data');
% spectopo(data, length, fs,'title','whatever','frequence',[low,high]);
spectopo(seeg(1,:), size(seeg,2), fs,'title','its a title','freqrange',[1 500]);
k=2;
OME=[0.5 400];
% K=0:low pass filter; K=1:bandpass; K=2:bandpass + notch filter
seeg_filtered=cFilterD_EEG(seeg',size(seeg,1),fs,k,OME); seeg_filtered=seeg_filtered';%
filename=strcat(processed_data,'SEEG_Data/','PF6_F_SEEG',num2str(session),'_filtered','.mat');
save(filename,'seeg_filtered');
% after
figure
spectopo(seeg_filtered(1,:), size(seeg_filtered,2), fs,'title','its a title','freqrange',[1 500]);
%% SKIP NOW:  Laplatian Re-reference 

data_referenced_1=cAr_EEG_Local(data_filtered_1,good_channels);
data_referenced_2=cAr_EEG_Local(data_filtered_2,good_channels);
data_referenced_3=cAr_EEG_Local(data_filtered_3,good_channels);
data_referenced_4=cAr_EEG_Local(data_filtered_4,good_channels);

save('G:\��ҵ��Ʊ���\��ҵ���(����)\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\SEEG_Data\data_referenced_.mat' ,'data_referenced_1','data_referenced_2' ,'data_referenced_3', 'data_referenced_4');
%% EPOCH
filename=strcat(processed_data,'SEEG_Data/','PF6_F_SEEG',num2str(session),'_filtered','.mat');
load(filename); seeg=seeg_filtered; clear seeg_filtered;% load seeg_filtered

EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',seeg,'srate',1000,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','seeg','gui','off');
eeglab redraw;

eventfile=strcat(processed_data,'eeglab/',num2str(session),'_eventtable.txt');
EEG = pop_importevent( EEG, 'event',eventfile,'fields',{'type','latency','duration'},'timeunit',0.001);
eeglab redraw;

epoch=strcat('epoch',num2str(1))
EEG = pop_epoch( EEG, {  1  }, [0 15], 'newname', epoch, 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off');
eeglab redraw;
epoch=EEG.data;
filename=strcat(processed_data,'SEEG_Data/','PF6_F_',num2str(session),'_EPOCH','.mat');
save(filename, 'epoch');
%% Extracting broadband gamma power

fprintf('\n Extracting broadband gamma power of the SEEG data');

broadband_gamma_range = [8 30];

broadband_gamma_signal_1 = prep_bpfilter(double(data_referenced_1), 6, broadband_gamma_range(1), broadband_gamma_range(2), Fs);
envelope_of_broadband_gamma_1= abs(hilbert(single(broadband_gamma_signal_1)));
power_of_broadband_gamma_1= envelope_of_broadband_gamma_1.^2;

broadband_gamma_signal_2 = prep_bpfilter(double(data_referenced_2), 6, broadband_gamma_range(1), broadband_gamma_range(2), Fs);
envelope_of_broadband_gamma_2= abs(hilbert(single(broadband_gamma_signal_2)));
power_of_broadband_gamma_2= envelope_of_broadband_gamma_2.^2;

broadband_gamma_signal_3 = prep_bpfilter(double(data_referenced_3), 6, broadband_gamma_range(1), broadband_gamma_range(2), Fs);
envelope_of_broadband_gamma_3= abs(hilbert(single(broadband_gamma_signal_3)));
power_of_broadband_gamma_3= envelope_of_broadband_gamma_3.^2;

broadband_gamma_signal_4 = prep_bpfilter(double(data_referenced_4), 6, broadband_gamma_range(1), broadband_gamma_range(2), Fs);
envelope_of_broadband_gamma_4= abs(hilbert(single(broadband_gamma_signal_4)));
power_of_broadband_gamma_4= envelope_of_broadband_gamma_4.^2;

% saving the power in the 'features' folder
save('.\features\power_of_broadband_gamma_1', 'power_of_broadband_gamma_1')
save('.\features\power_of_broadband_gamma_2', 'power_of_broadband_gamma_2')
save('.\features\power_of_broadband_gamma_3', 'power_of_broadband_gamma_3')
save('.\features\power_of_broadband_gamma_4', 'power_of_broadband_gamma_4')

% fprintf('\n Extracting broadband gamma power of the SEEG data');

% broadband_gamma_range = [18 26];
% 
% broadband_gamma_signal_1 = prep_bpfilter(double(data_referenced_1), 6, broadband_gamma_range(1), broadband_gamma_range(2), Fs);
% envelope_of_broadband_gamma_1= abs(hilbert(single(broadband_gamma_signal_1)));
% power_of_broadband_gamma_1= envelope_of_broadband_gamma_1.^2;
% 
% broadband_gamma_signal_2 = prep_bpfilter(double(data_referenced_2), 6, broadband_gamma_range(1), broadband_gamma_range(2), Fs);
% envelope_of_broadband_gamma_2= abs(hilbert(single(broadband_gamma_signal_2)));
% power_of_broadband_gamma_2= envelope_of_broadband_gamma_2.^2;
% 
% broadband_gamma_signal_3 = prep_bpfilter(double(data_referenced_3), 6, broadband_gamma_range(1), broadband_gamma_range(2), Fs);
% envelope_of_broadband_gamma_3= abs(hilbert(single(broadband_gamma_signal_3)));
% power_of_broadband_gamma_3= envelope_of_broadband_gamma_3.^2;
% 
% broadband_gamma_signal_4 = prep_bpfilter(double(data_referenced_4), 6, broadband_gamma_range(1), broadband_gamma_range(2), Fs);
% envelope_of_broadband_gamma_4= abs(hilbert(single(broadband_gamma_signal_4)));
% power_of_broadband_gamma_4= envelope_of_broadband_gamma_4.^2;
% 
% % saving the power in the 'features' folder
% save('.\features2\power_of_beta_1', 'power_of_broadband_gamma_1')
% save('.\features2\power_of_beta_2', 'power_of_broadband_gamma_2')
% save('.\features2\power_of_beta_3', 'power_of_broadband_gamma_3')
% save('.\features2\power_of_beta_4', 'power_of_broadband_gamma_4')
%% Power_Data Segmentation

fprintf('Power_Data Segmentation');

load('J:\��ҵ��Ʊ���\��ҵ���(����)\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\Trigger_Data\trigger.mat');
clear trigger_1 trigger_2 trigger_3 trigger_4

load('J:\��ҵ��Ʊ���\��ҵ���(����)\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\Trigger_Data\seq_built.mat');

% power_of_gamma_1=zeros(30000,110,40);
% power_of_gamma_2=zeros(30000,110,40);
% power_of_gamma_3=zeros(30000,110,40);
% power_of_gamma_4=zeros(30000,110,40);

% seq_1=build_seq(seq_1);
% seq_2=build_seq(seq_2);
% seq_3=build_seq(seq_3);
% seq_4=build_seq(seq_4);

power_of_gamma_1=build_data(power_of_broadband_gamma_1,triggerseeg_1);
power_of_gamma_2=build_data(power_of_broadband_gamma_2,triggerseeg_2);
power_of_gamma_3=build_data(power_of_broadband_gamma_3,triggerseeg_3);
power_of_gamma_4=build_data(power_of_broadband_gamma_4,triggerseeg_4);

% power_resized=data_segmentation(1,power_of_gamma_1,seq_1);
% power_resized=data_segmentation(2,power_of_gamma_2,seq_2);
% power_resized=data_segmentation(3,power_of_gamma_3,seq_3);
% power_resized=data_segmentation(4,power_of_gamma_4,seq_4);

power_of_gamma_1=permute(power_of_gamma_1,[1,3,2]);
power_of_gamma_2=permute(power_of_gamma_2,[1,3,2]);
power_of_gamma_3=permute(power_of_gamma_3,[1,3,2]);
power_of_gamma_4=permute(power_of_gamma_4,[1,3,2]);

%����protocal �ֳ�30000*10*110��һ������� trial_i_j,i��ʾsession,j��ʾprotocal
trial_1_1=power_of_gamma_1(:,seq_1(1,:),:);
trial_1_2=power_of_gamma_1(:,seq_1(2,:),:);
trial_1_3=power_of_gamma_1(:,seq_1(3,:),:);
trial_1_4=power_of_gamma_1(:,seq_1(4,:),:);

trial_2_1=power_of_gamma_2(:,seq_2(1,:),:);
trial_2_2=power_of_gamma_2(:,seq_2(2,:),:);
trial_2_3=power_of_gamma_2(:,seq_2(3,:),:);
trial_2_4=power_of_gamma_2(:,seq_2(4,:),:);

trial_3_1=power_of_gamma_3(:,seq_3(1,:),:);
trial_3_2=power_of_gamma_3(:,seq_3(2,:),:);
trial_3_3=power_of_gamma_3(:,seq_3(3,:),:);
trial_3_4=power_of_gamma_3(:,seq_3(4,:),:);

trial_4_1=power_of_gamma_4(:,seq_4(1,:),:);
trial_4_2=power_of_gamma_4(:,seq_4(2,:),:);
trial_4_3=power_of_gamma_4(:,seq_4(3,:),:);
trial_4_4=power_of_gamma_4(:,seq_4(4,:),:);

power_resized=zeros(30000,40,110,4);

power_resized(:,1:10,:,1)=trial_1_1;
power_resized(:,11:20,:,1)=trial_2_1;
power_resized(:,21:30,:,1)=trial_3_1;
power_resized(:,31:40,:,1)=trial_4_1;

power_resized(:,1:10,:,2)=trial_1_2;
power_resized(:,11:20,:,2)=trial_2_2;
power_resized(:,21:30,:,2)=trial_3_2;
power_resized(:,31:40,:,2)=trial_4_2;

power_resized(:,1:10,:,3)=trial_1_3;
power_resized(:,11:20,:,3)=trial_2_3;
power_resized(:,21:30,:,3)=trial_3_3;
power_resized(:,31:40,:,3)=trial_4_3;

power_resized(:,1:10,:,4)=trial_1_4;
power_resized(:,11:20,:,4)=trial_2_4;
power_resized(:,21:30,:,4)=trial_3_4;
power_resized(:,31:40,:,4)=trial_4_4;

save('.\power2\power_of_beta_1', 'power_of_gamma_1')
save('.\power2\power_of_beta_2', 'power_of_gamma_2')
save('.\power2\power_of_beta_3', 'power_of_gamma_3')
save('.\power2\power_of_beta_4', 'power_of_gamma_4')

save('.\power_of_gamma_resized.mat', 'power_resized')

%% Examine data

fprintf('Examine data');
for i=1:110
figure
examine_data=power_resized(:,[1:20,31:40],i,1); %30000*40*110*4
examine_data_avg=mean(examine_data,2);
subplot(2,1,1)
plot(examine_data_avg)
%�˲�ƽ��
h  = fdesign.lowpass('N,F3dB', 4,10, Fs); % OMEΪ��ͨ��ֹƵ�ʣ���ȡ5hz
Hd = design(h, 'butter');
[B A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
examine_data_after_lowpass=filtfilt(B,A,double(examine_data_avg));
subplot(2,1,2)
plot(examine_data_after_lowpass)
saveas(gcf,['./','channel_',num2str(i),'.jpg'])
end









