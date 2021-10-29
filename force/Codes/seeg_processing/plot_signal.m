addpath('G:\毕业设计备份\毕业设计\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\SEEG_Data\power_resized');
addpath('G:\毕业设计备份\毕业设计\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\Force_Data');
addpath('G:\毕业设计备份\毕业设计\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\HDEMG_Data');
addpath('G:\毕业设计备份\毕业设计\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\SEEG_Data');
load('emg_resized.mat');
load('force_resized.mat');
load('data_resized.mat');
load('power_of_delta_resized.mat');
load('power_of_theta_resized.mat');
load('power_of_alpha_resized.mat');
load('power_of_beta_resized.mat');
load('power_resized.mat');

Fs=2000;

channel=[1:20,31:40];

h  = fdesign.lowpass('N,F3dB', 4, 5, Fs); % OME为低通截止频率：可取5hz
Hd = design(h, 'butter');
[B A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);

N=30000; %信号长度
Fs=2000; %采样频率
dt=1/Fs; %采样间隔
t=(0:(N-1))*dt;  % 时间序列
ch=22;

%% protocal 1
% 取第ch个通道
data_p1=mean(data_resized(:,channel,ch,1),2);
emg_p1=mean(emg_resized(:,channel,1),2);
force_p1=mean(force_resized(:,channel,1),2);
power_of_delta_p1=mean(power_of_delta_resized(:,channel,ch,1),2);
power_of_theta_p1=mean(power_of_theta_resized(:,channel,ch,1),2);
power_of_alpha_p1=mean(power_of_alpha_resized(:,channel,ch,1),2);
power_of_beta_p1=mean(power_of_beta_resized(:,channel,ch,1),2);
power_of_gamma_p1=mean(power_of_gamma_resized(:,channel,ch,1),2);
% % 

power_of_delta_p1_basel=mean(power_of_delta_p1((end-4000+1):end));
power_of_delta_p1_norm=power_of_delta_p1/power_of_delta_p1_basel;

power_of_theta_p1_basel=mean(power_of_theta_p1((end-4000+1):end));
power_of_theta_p1_norm=power_of_theta_p1/power_of_theta_p1_basel;

power_of_alpha_p1_basel=mean(power_of_alpha_p1((end-4000+1):end));
power_of_alpha_p1_norm=power_of_alpha_p1/power_of_alpha_p1_basel;

power_of_beta_p1_basel=mean(power_of_beta_p1((end-4000+1):end));
power_of_beta_p1_norm=power_of_beta_p1/power_of_beta_p1_basel;

power_of_gamma_p1_basel=mean(power_of_gamma_p1((end-4000+1):end));
power_of_gamma_p1_norm=power_of_gamma_p1/power_of_gamma_p1_basel;

% power_of_gamma_after_lowpass=filtfilt(B,A,double(power_of_gamma_p1_norm));

data_p1_smoothed=smoothts(data_p1);
data_p1_smoothed_basel=mean(data_p1_smoothed((end-4000+1):end));
data_p1_smoothed_norm=data_p1_smoothed/data_p1_smoothed_basel;

% emg_p1_basel=mean(emg_p1(1:2000));
% emg_p1_norm=emg_p1/emg_p1_basel;

figure
subplot(4,1,1)
plot(t,100*force_p1,'r','linewidth',2);
hold on
plot([2,2],ylim,'r--','linewidth',1.5);
plot([7.5 7.5],ylim,'black--','linewidth',0.6);
ylabel('Ratio(%)','fontsize',16)
ylim([0 60])
legend('Force')

subplot(4,1,4)
plot(t,power_of_delta_p1_norm,'blue','linewidth',1.2);
hold on
plot(t,power_of_theta_p1_norm,'green','linewidth',1.2);
plot(t,power_of_alpha_p1_norm,'red','linewidth',1.2);
plot(t,power_of_beta_p1_norm,'yellow','linewidth',1.2);
plot(t,power_of_gamma_p1_norm,'m','linewidth',1.2);
% plot(t,data_p1_smoothed_norm,'c','linewidth',1.2);
% plot(t,5*force_p1,'black','linewidth',1.2);
plot([2,2],ylim,'r--','linewidth',1.5);
plot([7.5 7.5],ylim,'black--','linewidth',0.6);
xlabel('Time(s)','fontsize',16)
ylabel('Power (μV^2)','fontsize',16)
% x=2:7.5;
% task=area(x,3.5*(x>=2&x<=7.5));
% task.FaceColor=[1,0.5,0];
% task.FaceAlpha=0.1;
hold off
legend('delta','theta','alpha','beta','gamma');

subplot(4,1,2)
plot(t,emg_p1);
hold on
plot([2,2],ylim,'r--','linewidth',1.5);
plot([7.5 7.5],ylim,'black--','linewidth',0.6);
hold off
ylabel('Amplitude (μV)','fontsize',16)
legend('emg')

subplot(4,1,3)
plot(t,data_p1_smoothed);
hold on
plot([2,2],ylim,'r--','linewidth',1.5);
plot([7.5 7.5],ylim,'black--','linewidth',0.6);
hold off
ylabel('Amplitude (mV）','fontsize',16)
legend('seeg')

%% protocal 2
data_p2=mean(data_resized(:,channel,ch,2),2);
emg_p2=mean(emg_resized(:,channel,2),2);
force_p2=mean(force_resized(:,channel,2),2);
power_of_delta_p2=mean(power_of_delta_resized(:,channel,ch,2),2);
power_of_theta_p2=mean(power_of_theta_resized(:,channel,ch,2),2);
power_of_alpha_p2=mean(power_of_alpha_resized(:,channel,ch,2),2);
power_of_beta_p2=mean(power_of_beta_resized(:,channel,ch,2),2);
power_of_gamma_p2=mean(power_of_gamma_resized(:,channel,ch,2),2);
% 


power_of_delta_p2_basel=mean(power_of_delta_p2((end-2000+1):end));
power_of_delta_p2_norm=power_of_delta_p2/power_of_delta_p2_basel;

power_of_theta_p2_basel=mean(power_of_theta_p2((end-2000+1):end));
power_of_theta_p2_norm=power_of_theta_p2/power_of_theta_p2_basel;

power_of_alpha_p2_basel=mean(power_of_alpha_p2((end-2000+1):end));
power_of_alpha_p2_norm=power_of_alpha_p2/power_of_alpha_p2_basel;

power_of_beta_p2_basel=mean(power_of_beta_p2((end-2000+1):end));
power_of_beta_p2_norm=power_of_beta_p2/power_of_beta_p2_basel;

power_of_gamma_p2_basel=mean(power_of_gamma_p2((end-2000+1):end));
power_of_gamma_p2_norm=power_of_gamma_p2/power_of_gamma_p2_basel;

power_of_gamma_after_lowpass=filtfilt(B,A,double(power_of_gamma_p2_norm));

data_p2_smoothed=smoothts(data_p2);
data_p2_smoothed_basel=mean(data_p2_smoothed((end-2000+1):end));
data_p2_smoothed_norm=data_p2_smoothed/data_p2_smoothed_basel;

subplot(4,1,1)
plot(t,100*force_p2,'r','linewidth',2);
hold on
plot([2,2],ylim,'r--','linewidth',1.5);
plot([13.5 13.5],ylim,'black--','linewidth',0.6);
ylabel('Ratio(%)','fontsize',16)
ylim([0 100])
legend('Force')
subplot(4,1,2)
plot(t,power_of_delta_p2_norm,'blue','linewidth',1.2);
hold on
plot(t,power_of_theta_p2_norm,'green','linewidth',1.2);
plot(t,power_of_alpha_p2_norm,'red','linewidth',1.2);
plot(t,power_of_beta_p2_norm,'yellow','linewidth',1.2);
plot(t,power_of_gamma_after_lowpass,'m','linewidth',1.2);
% plot(t,5*force_p2,'black','linewidth',1.2);
plot([2,2],ylim,'r--','linewidth',1.5);
plot([13.5 13.5],ylim,'black--','linewidth',0.6);
hold off
ylabel('Power(μv^2)','fontsize',16)
legend('delta','theta','alpha','beta','gamma');
subplot(4,1,4)
plot(t,emg_p2);
hold on
plot([2,2],ylim,'r--','linewidth',1.5);
plot([13.5 13.5],ylim,'black--','linewidth',0.6);
xlabel('Time(s)','fontsize',16)
ylabel('Amplitude','fontsize',16)
legend('emg')
subplot(4,1,3)
plot(t,data_p2_smoothed);
hold on
plot([2,2],ylim,'r--','linewidth',1.5);
plot([13.5 13.5],ylim,'black--','linewidth',0.6);
hold off
legend('seeg')
ylabel('Amplitude(μv)','fontsize',16)
%% protocal 3
data_p3=mean(data_resized(:,channel,69,3),2);
emg_p3=mean(emg_resized(:,channel,3),2);
force_p3=mean(force_resized(:,channel,3),2);
power_of_delta_p3=mean(power_of_delta_resized(:,channel,69,3),2);
power_of_theta_p3=mean(power_of_theta_resized(:,channel,69,3),2);
power_of_alpha_p3=mean(power_of_alpha_resized(:,channel,69,3),2);
power_of_beta_p3=mean(power_of_beta_resized(:,channel,69,3),2);
power_of_gamma_p3=mean(power_of_gamma_resized(:,channel,69,3),2);
% 

power_of_delta_p3_basel=mean(power_of_delta_p3((end-4000+1):end));
power_of_delta_p3_norm=power_of_delta_p3/power_of_delta_p3_basel;

power_of_theta_p3_basel=mean(power_of_theta_p3((end-4000+1):end));
power_of_theta_p3_norm=power_of_theta_p3/power_of_theta_p3_basel;

power_of_alpha_p3_basel=mean(power_of_alpha_p3((end-4000+1):end));
power_of_alpha_p3_norm=power_of_alpha_p3/power_of_alpha_p3_basel;

power_of_beta_p3_basel=mean(power_of_beta_p3((end-4000+1):end));
power_of_beta_p3_norm=power_of_beta_p3/power_of_beta_p3_basel;

power_of_gamma_p3_basel=mean(power_of_gamma_p3((end-4000+1):end));
power_of_gamma_p3_norm=power_of_gamma_p3/power_of_gamma_p3_basel;

power_of_gamma_after_lowpass=filtfilt(B,A,double(power_of_gamma_p3_norm));

data_p3_smoothed=smoothts(data_p3);
data_p3_smoothed_basel=mean(data_p3_smoothed((end-4000+1):end));
data_p3_smoothed_norm=data_p3_smoothed/data_p3_smoothed_basel;


subplot(4,1,1)
plot(t,100*force_p3,'r','linewidth',2);
hold on
plot([2,2],ylim,'r--','linewidth',1.5);
plot([5.5 5.5],ylim,'black--','linewidth',0.6);
ylabel('Ratio(%)','fontsize',16)
ylim([0 60])
legend('Force')

subplot(4,1,2)
plot(t,power_of_delta_p3_norm,'blue','linewidth',1.2);
hold on
plot(t,power_of_theta_p3_norm,'green','linewidth',1.2);
plot(t,power_of_alpha_p3_norm,'red','linewidth',1.2);
plot(t,power_of_beta_p3_norm,'yellow','linewidth',1.2);
plot(t,power_of_gamma_after_lowpass,'m','linewidth',1.2);
% plot(t,10*force_p3,'black','linewidth',1.2);
plot([2,2],ylim,'r--','linewidth',1.5);
plot([5.5 5.5],ylim,'black--','linewidth',0.6);
hold off
legend('delta','theta','alpha','beta','gamma');
ylabel('Power(μv^2)','fontsize',16)
subplot(4,1,4)
plot(t,emg_p3);
hold on
plot([2,2],ylim,'r--','linewidth',1.5);
plot([5.5 5.5],ylim,'black--','linewidth',0.6);
hold off
legend('emg')
xlabel('Time(s)','fontsize',16)
ylabel('Amplitude','fontsize',16)
subplot(4,1,3)
plot(t,data_p3_smoothed);
hold on
plot([2,2],ylim,'r--','linewidth',1.5);
plot([5.5 5.5],ylim,'black--','linewidth',0.6);
hold off
legend('seeg')
ylabel('Amplitude(μv)','fontsize',16)

%% protocal 4
data_p4=mean(data_resized(:,channel,ch,4),2);
emg_p4=mean(emg_resized(:,channel,4),2);
force_p4=mean(force_resized(:,channel,4),2);
power_of_delta_p4=mean(power_of_delta_resized(:,channel,ch,4),2);
power_of_theta_p4=mean(power_of_theta_resized(:,channel,ch,4),2);
power_of_alpha_p4=mean(power_of_alpha_resized(:,channel,ch,4),2);
power_of_beta_p4=mean(power_of_beta_resized(:,channel,ch,4),2);
power_of_gamma_p4=mean(power_of_gamma_resized(:,channel,ch,4),2);
% 

power_of_delta_p4_basel=mean(power_of_delta_p4((end-4000+1):end));
power_of_delta_p4_norm=power_of_delta_p4/power_of_delta_p4_basel;

power_of_theta_p4_basel=mean(power_of_theta_p4((end-4000+1):end));
power_of_theta_p4_norm=power_of_theta_p4/power_of_theta_p4_basel;

power_of_alpha_p4_basel=mean(power_of_alpha_p4((end-4000+1):end));
power_of_alpha_p4_norm=power_of_alpha_p4/power_of_alpha_p4_basel;

power_of_beta_p4_basel=mean(power_of_beta_p4((end-4000+1):end));
power_of_beta_p4_norm=power_of_beta_p4/power_of_beta_p4_basel;

power_of_gamma_p4_basel=mean(power_of_gamma_p4((end-4000+1):end));
power_of_gamma_p4_norm=power_of_gamma_p4/power_of_gamma_p4_basel;

power_of_gamma_after_lowpass=filtfilt(B,A,double(power_of_gamma_p4_norm));

data_p4_smoothed=smoothts(data_p4);
data_p4_smoothed_basel=mean(data_p4_smoothed((end-4000+1):end));
data_p4_smoothed_norm=data_p4_smoothed/data_p4_smoothed_basel;

subplot(4,1,1)
plot(t,100*force_p4,'r','linewidth',2);
hold on
plot([2,2],ylim,'r--','linewidth',1.5);
plot([7.5 7.5],ylim,'black--','linewidth',0.6);
ylabel('Ratio(%)','fontsize',16)
ylim([0 100])
legend('Force')
subplot(4,1,2)
plot(t,power_of_delta_p4_norm,'blue','linewidth',1.2);
hold on
plot(t,power_of_theta_p4_norm,'green','linewidth',1.2);
plot(t,power_of_alpha_p4_norm,'red','linewidth',1.2);
plot(t,power_of_beta_p4_norm,'yellow','linewidth',1.2);
plot(t,power_of_gamma_after_lowpass,'m','linewidth',1.2);
% plot(t,5*force_p4,'black','linewidth',1.2);
plot([2,2],ylim,'r--','linewidth',1.5);
plot([7.5 7.5],ylim,'black--','linewidth',0.6);
hold off
legend('delta','theta','alpha','beta','gamma');
ylabel('Power(μv^2)','fontsize',16)
subplot(4,1,4)
plot(t,emg_p4);
hold on
plot([2,2],ylim,'r--','linewidth',1.5);
plot([7.5 7.5],ylim,'black--','linewidth',0.6);
legend('emg')
xlabel('Time(s)','fontsize',16)
ylabel('Amplitude','fontsize',16)
subplot(4,1,3)
plot(t,data_p4_smoothed);
hold on
plot([2,2],ylim,'r--','linewidth',1.5);
plot([7.5 7.5],ylim,'black--','linewidth',0.6);
hold off
legend('seeg')
ylabel('Amplitude(μv)','fontsize',16)