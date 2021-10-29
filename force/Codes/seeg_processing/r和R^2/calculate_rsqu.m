%% Calculate R^2 between period of task and baseline

% �������� SEEG��EMG
% addpath('G:\��ҵ��Ʊ���\��ҵ���(����)\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\SEEG_Data')
% load('power_of_gamma_resized.mat')
% addpath('G:\��ҵ��Ʊ���\��ҵ���(����)\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\HDEMG_Data')
% load('emg_resized.mat')

protocol=1;
trial=[1:20,31:40];
channel=[8 9 10 18 19 20 21 22 23 24 62 63 69 70 105 107 108 109 110];
channel_selected=14;
gamma=squeeze(power_of_gamma_resized(:,trial,channel,protocol));
%% Fig.6 
%ȡÿ��trial ����� gamma��ƽ��ֵ��100��trial,��100��ֵ
% ��Ӧbaselineͬ���������õ�100��ֵ
%������100�е�����������rsqu���������룬�õ�R^2ֵ����������������ص�ͨ����ƽ��
for i=1:length(channel)
    for j=1:length(trial)
        gamma_task(:,j,i)=gamma(10001:15000,j,i);
        gamma_basel(:,j,i)=gamma(22000:27000,j,i);
        gamma_task_median(j,i)=median(gamma_task(:,j,i));
        gamma_basel_median(j,i)=median(gamma_basel(:,j,i));
        % [gamma_norm(i,:),PS]=mapminmax(gamma_mean(:,i)',0,1);
    end
end

for i=1:length(channel)
    erg_fig6(i)=rsqu(gamma_task_median(:,i),gamma_basel_median(:,i));
end
erg_fig6=mean(erg_fig6);

%% Fig.7
% ÿ100msȡһ�� 0.1*2000=200�����ݵ�
for i=1:length(channel)
        Base=(median(gamma(25000:27000,:,i)))'; %��ÿһ����ƽ������ÿһ���缫�£�ÿһ��trial��baseline����ֵ
        % [gamma_norm(i,:),PS]=mapminmax(gamma_mean(:,i)',0,1);
        for j=1:150
            Task=(median(gamma((1+(j-1)*200):200*j,:,i)))';
            erg(j,i)=rsqu(Base,Task);
        end
end

erg_mean=mean(erg,2);
plot(erg_mean)






