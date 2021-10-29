% load('G:\毕业设计备份\毕业设计\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\SEEG_Data\power_resized.mat');
% load('G:\毕业设计备份\毕业设计\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\SEEG_Data\best_channel.mat');
channel=[5 6 8:10 18:25 28 31:55 60:70 75:98 103:110];
protocal=1;
% trial=[1:20,31:40];
trial=15;
% power_original=power_of_gamma_resized(:,trial,channel,protocal);
 power=power_of_gamma_resized(:,trial,channel,protocal);
% for i=1:82
%     power(:,i)=mean(power_original(:,:,i),2);
% end
power=squeeze(power);
power_res=resample(double(power),1000,2000);
baseline=power_res((end-2000+1):end,:);
Fs=1000;
WindowLength=0.2*Fs;
SlideLength=0.1*Fs;
for i=1:139
    for j=1:82;
        if i==1
            power_of_gamma(:,j)=power_res((1000+(i-1)*WindowLength+1):(1000+i*WindowLength),j);
        else
            power_of_gamma(:,j)=power_res((1000+(i-1)*SlideLength+1):(1000+(i-1)*SlideLength+WindowLength),j);
        end
        power_of_basel(j)=median(baseline(:,j));
        basel_std(j)=std(baseline(:,j));
        power_of_gamma(i,j)=median(power_of_gamma(:,j));
        activation_val(i,j)=(power_of_gamma(i,j)-power_of_basel(j))/basel_std(j);
    end
end
activation_val=activation_val';

for j=1:82
    Etala.activations_gamma(channel(j),(2+(protocal-1)*139):(139*protocal+1))=activation_val(j,:);
end

clear activation_val
    
    