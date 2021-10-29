%% Calculate R^2 between period of task and baseline

% 输入数据 SEEG和EMG
% addpath('G:\毕业设计备份\毕业设计(重做)\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\SEEG_Data')
% load('power_of_gamma_resized.mat')
% addpath('G:\毕业设计备份\毕业设计(重做)\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\HDEMG_Data')
% load('emg_resized.mat')

protocol=1;
trial=[1:20,31:40];
channel=[8 9 10 18 19 20 21 22 23 24 62 63 69 70 105 107 108 109 110];
channel_selected=14;
gamma=squeeze(power_of_gamma_resized(:,trial,channel,protocol));
%% Fig.6 
%取每个trial 任务段 gamma的平均值，100个trial,即100个值
% 对应baseline同样操作，得到100个值
%这两个100行的列向量，是rsqu的两个输入，得到R^2值。最后对所有任务相关的通道做平均
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
% 每100ms取一次 0.1*2000=200个数据点
for i=1:length(channel)
        Base=(median(gamma(25000:27000,:,i)))'; %给每一列做平均，即每一个电极下，每一个trial的baseline的中值
        % [gamma_norm(i,:),PS]=mapminmax(gamma_mean(:,i)',0,1);
        for j=1:150
            Task=(median(gamma((1+(j-1)*200):200*j,:,i)))';
            erg(j,i)=rsqu(Base,Task);
        end
end

erg_mean=mean(erg,2);
plot(erg_mean)






