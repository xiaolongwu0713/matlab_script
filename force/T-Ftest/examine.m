%% Load SEEG data

fprintf('\n Loading SEEG signal');

addpath('G:\��ҵ��Ʊ���\��ҵ���\Plot_Topography\Plot_Topography\t-f����');
seeg_channels=[1:15,17:29,38:119];
load('PF6_F_1.mat');
data_1=Data(seeg_channels,:)';
load('PF6_F_2.mat');
data_2=Data(seeg_channels,:)';
load('PF6_F_3.mat');
data_3=Data(seeg_channels,:)';
load('PF6_F_4.mat');
data_4=Data(seeg_channels,:)';
% ���ݸ�ʽΪ���д���,Fs��֪��

number_of_channels=size(data_1,2);

clear ChnName Data ;

%% Remove bad channels

fprintf('\n Analysis of bad channels');

% Some channels are noisy and we will not keep them in the analysis. Here, 
% we define the good channels as the ones that do not contain significant
% 50 Hz noise. The function 'remove_bad_channels' returns an array 
% containing the indices of the channels that do not contain noise. 
% good_channels = remove_bad_channels(signal, sampling_rate);

good_channels= remove_bad_channels(data_1, Fs,10);
bad_channels= setdiff(1:110, good_channels); 
% good_channels_2= remove_bad_channels(data_2, Fs,10);
% bad_channels_2= setdiff(1:110, good_channels_2); 
% good_channels_3= remove_bad_channels(data_3, Fs,10);
% bad_channels_3= setdiff(1:110, good_channels_3); 
% good_channels_4= remove_bad_channels(data_4, Fs,10);
% bad_channels_4= setdiff(1:110, good_channels_4); 

%% High-pass filter

fprintf('\n High-pass filter of the SEEG data');

k=2;
OME=[0.5 400];
data_filtered_1=cFilterD_EEG(data_1,number_of_channels,Fs,k,OME); %�˲�ʱ�����Ȳ�����bad channels
data_filtered_2=cFilterD_EEG(data_2,number_of_channels,Fs,k,OME); 
data_filtered_3=cFilterD_EEG(data_3,number_of_channels,Fs,k,OME); 
data_filtered_4=cFilterD_EEG(data_4,number_of_channels,Fs,k,OME); 

clear k OME;

%% Laplatian Re-reference

data_referenced_1=cAr_EEG_Local(data_1,good_channels);
data_referenced_2=cAr_EEG_Local(data_2,good_channels);
data_referenced_3=cAr_EEG_Local(data_3,good_channels);
data_referenced_4=cAr_EEG_Local(data_4,good_channels);

save('G:\��ҵ��Ʊ���\��ҵ���\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\SEEG_Data\data_referenced.mat' ,'data_referenced_1','data_referenced_2' ,'data_referenced_3', 'data_referenced_4');


%% Extracting broadband gamma power

fprintf('\n Extracting broadband gamma power of the SEEG data');

broadband_gamma_range = [60 140];

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

%% Power_Data Segmentation

fprintf('Power_Data Segmentation');

load('G:\��ҵ��Ʊ���\��ҵ���\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\Trigger_Data\trigger.mat');
clear trigger_1 trigger_2 trigger_3 trigger_4

load('G:\��ҵ��Ʊ���\��ҵ���\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\Trigger_Data\seq.mat');

% power_of_gamma_1=zeros(30000,110,4);
% power_of_gamma_2=zeros(30000,110,4);
% power_of_gamma_3=zeros(30000,110,4);
% power_of_gamma_4=zeros(30000,110,4);

seq_1=build_seq(seq_1);
seq_2=build_seq(seq_2);
seq_3=build_seq(seq_3);
seq_4=build_seq(seq_4);

power_of_gamma_1=build_data(power_of_broadband_gamma_1,triggerseeg_1);
power_of_gamma_2=build_data(power_of_broadband_gamma_2,triggerseeg_2);
power_of_gamma_3=build_data(power_of_broadband_gamma_3,triggerseeg_3);
power_of_gamma_4=build_data(power_of_broadband_gamma_4,triggerseeg_4);

power_resized=data_segmentation(1,power_of_gamma_1,seq_1);
power_resized=data_segmentation(2,power_of_gamma_2,seq_2);
power_resized=data_segmentation(3,power_of_gamma_3,seq_3);
power_resized=data_segmentation(4,power_of_gamma_4,seq_4);


save('.\power\power_of_gamma_1', 'power_of_gamma_1')
save('.\power\power_of_gamma_2', 'power_of_gamma_2')
save('.\power\power_of_gamma_3', 'power_of_gamma_3')
save('.\power\power_of_gamma_4', 'power_of_gamma_4')

save('.\power_resized.mat', 'power_resized')

%% Examine data

fprintf('Examine data');

examine_data=power_resized(:,:,3,21); %30000*40*4*110
examine_data_avg=mean(examine_data,2);
subplot(1,2,1)
plot(examine_data_avg)
%�˲�ƽ��
h  = fdesign.lowpass('N,F3dB', 4, 5, Fs); % OMEΪ��ͨ��ֹƵ�ʣ���ȡ5hz
Hd = design(h, 'butter');
[B A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
examine_data_after_lowpass=filtfilt(B,A,double(examine_data_avg));
subplot(1,2,2)
plot(examine_data_after_lowpass)
