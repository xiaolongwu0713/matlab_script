%% Setups
eeglabpath='/Users/long/BCI/matlab_scripts/eeglab2020_0';
addpath(eeglabpath);

seeg_channels=[1:15,17:29,38:119];
Fs=2000;
fs=1000;
global processed_data;
processed_data='/Users/long/Documents/BCI/matlab_scripts/force/data/';

%% power data extraction
fprintf('processing band %d. \n', band);
%bpfilter(signal,order,lcfreq,hcfreq,fs)
N=6;
epoch=load_data(999,'move1');
epochf=bpfilter(epoch,N,0.5,300,fs); 
%figure();subplot(2,1,1);pspectrum(epoch(110,:,1));subplot(2,1,2);pspectrum(epochl(110,:,1));
tmp= abs(cubeHilbert(single(epochf)));
power= tmp.^2;
filename=strcat(processed_data,'move1Power.mat');
save(filename, 'power');


%% test the activation algorithm: power
%testData(1,2); % generate the test data set, inlcuding 10hz and 120hz component.
tmp=load_data(1,'test');
epoch=tmp.data;
bandf = [8 30];
filteredEpoch = bpfilter(double(epoch), 6, bandf(1), bandf(2), 1000);
epochEvenlop= abs(cubeHilbert(single(filteredEpoch)));
power= epochEvenlop.^2;
filename=strcat(processed_data,'/SEEG_Data/','PF6_F_',num2str(session),'_testPower.mat');
save(filename,'power');

acti=activation(1,'testPowerActivation');
surface(acti);
kchn=kmostactive(acti,10); % return:(channel,trial)

%% amplitude cube
movetype=1;
band='high';
move=strcat('move',num2str(movetype));
if strcmp(band,'high')
%banf = [8 30];
    bandf = [60 300];
    filename=strcat(processed_data,'/SEEG_Data/',move,'_epochHighAmp.mat'); %move1_epochAmp.mat
elseif strcmp(band,'low')
    bandf = [8 30];
    filename=strcat(processed_data,'/SEEG_Data/',move,'_epochLowAmp.mat'); %move1_epochAmp.mat
end
epoch=load_data(1,move);
ampEpoch=zeros(size(epoch));
epochf = bpfilter(double(epoch), 6, bandf(1), bandf(2), 1000);
chnNum=size(epochf,1);trialNum=size(epochf,3);
for trial=[1:trialNum]
    trial % tracking process
    for chn=[1:chnNum]
        [cfs,frq]=cwt(double(epochf(chn,:,trial)),1000,'FrequencyLimits',[8 30]);
        amp=abs(cfs);
        ampmean=mean(amp,1);
        ampEpoch(chn,:,trial)=ampmean;
    end
end
data=ampEpoch;
%filename=strcat(processed_data,'SEEG_Data/','testLowAmp.mat');
save(filename,'data');

%% low frequency channel selection
band='high';
acti=activation(1,'move1',band); % activation(session(no effect),'move1/2/3/4','low/high');
surface(acti);
kchn=kmostactive(acti,10); % return:(channel,trial)
figure()
plotKMostActiveMove(1,band,kchn); % plotKMostActiveMove(movetype,kchn)


%% 
fb = cwtfilterbank('SignalLength',numel(data),'SamplingFrequency',1000,'FrequencyLimits',[100 160],'VoicesPerOctave',32);
cwt(double(data),'FilterBank',fb);
cwt(double(dataf),1000,'NumOctaves',10,'VoicesPerOctave',32);
figure(2)
spectopo(dataf, size(data,2), 1000,'title','its a title','freqrange',[1 500]);

fband = [8 30];
dataf = bpfilter(double(data), 6, fband(1), fband(2), 1000);
epochEvenlop= abs(hilbert(single(dataf)));
power_of_broadband_gamma_1= epochEvenlop.^2;

        
%% Extracting broadband gamma power

fprintf('\n Extracting broadband gamma power of the SEEG data');

bandf = [8 30];

filteredEpoch = prep_bpfilter(double(data_referenced_1), 6, bandf(1), bandf(2), Fs);
epochEvenlop= abs(hilbert(single(filteredEpoch)));
power_of_broadband_gamma_1= epochEvenlop.^2;

broadband_gamma_signal_2 = prep_bpfilter(double(data_referenced_2), 6, bandf(1), bandf(2), Fs);
envelope_of_broadband_gamma_2= abs(hilbert(single(broadband_gamma_signal_2)));
power_of_broadband_gamma_2= envelope_of_broadband_gamma_2.^2;

broadband_gamma_signal_3 = prep_bpfilter(double(data_referenced_3), 6, bandf(1), bandf(2), Fs);
envelope_of_broadband_gamma_3= abs(hilbert(single(broadband_gamma_signal_3)));
power_of_broadband_gamma_3= envelope_of_broadband_gamma_3.^2;

broadband_gamma_signal_4 = prep_bpfilter(double(data_referenced_4), 6, bandf(1), bandf(2), Fs);
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









       
        