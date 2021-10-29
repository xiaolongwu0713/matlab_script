addpath('G:\毕业设计备份\毕业设计(重做)\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\BrainElectrodes');
load('Electrode_Name_SEEG.mat');
load('SignalChanel_Electrode_Registration.mat');
load('electrodes_Final_Anatomy_wm.mat');
best_channel=[8 9 10 18 19 20 21 22 23 24 62 63 69 70 105 107 108 109 110];
channel=[5 6 8:10 18:25 28 31:55 60:70 75:98 103:110];
n=length(channel);
for i=1:n
    channel_transform(i)=find(CHN==channel(i));
end

load('G:\毕业设计备份\毕业设计(重做)\Plot_Topography\Plot_Topography\activation_data\MATLAB\Etala_p1.mat')
activations=zeros(110,140);
for i=1:n
    activations(channel_transform(i),:)=Etala_p1.activations_gamma(channel(i),:);
end
