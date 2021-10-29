function [triggerseeg]=Force_Trigger_Check(trigger_stem)
% %% Load original data
% % forcef='C:\Files\Raw_Data\SEEG_EMG_FORCE\PF1_XYF_2018_05_11\Force_Data\XYF-1-2.daq';
% forcef='E:\研究生资料\画大脑和电极\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\Force_Data\SYF-1-2.daq';
% a = fopen(forcef);
% t = fread(a,'double');
% x = 2:2:length(t);
% force = t(x);
% time = t(x-1);
% force = force-min(force);
% % seegf='C:\Files\Raw_Data\SEEG_EMG_FORCE\PF1_XYF_2018_05_11\SEEG_Data\PF1_FS_1_Raw.mat';
% seegf='E:\研究生资料\画大脑和电极\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\SEEG_Data\PF6_F_1(1).mat';
% seeg=load(seegf);
% 
% % triggerf='C:\Files\Raw_Data\SEEG_EMG_FORCE\PF1_XYF_2018_05_11\Trigger_Data\Trigger_Information_1.mat';
% triggerf='E:\研究生资料\画大脑和电极\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\Trigger_Data\Trigger_Information_1.mat';
% trigger=load(triggerf);
%% extract the trigger data points
% seegtrigger=seeg.Data(39,:);
% seegtrigger=seeg.Data(30,:);
seeg.Fs=2000;
seegtrigger=trigger_stem;
% bad_data=find((seegtrigger>8000)|(seegtrigger<-1000));
% seegtrigger(bad_data)=nan;
maxt=max(seegtrigger);
mint=min(seegtrigger);
% meant=mean(seegtrigger);
threp=find(seegtrigger<0.3*(maxt+mint));  %threp 是索引值下标 seegtrigger的
triggerseeg=zeros(40,1);
index=0;
for d=1:length(threp)
    if d==1
        index=index+1;
        triggerseeg(index)=threp(d);
    else
        if threp(d)-threp(d-1)>10*seeg.Fs && index<40
            index=index+1;
            triggerseeg(index)=threp(d);
        end
    end    
end
% plot(threp,seegtrigger(threp),'r.','markersize',30);
% hold on
% figure
% plot(seegtrigger)
% hold on
% plot(triggerseeg,seegtrigger(triggerseeg),'r.','markersize',30);

% %% store trigger Information
% triggerInfo.SEEGtrigger=triggerseeg;
% triggerInfo.SEEGFs=seeg.Fs;
% triggerInfo.TriggerSeq=trigger.Info.Exp_Seq;
% triggerInfo.TriggerYaxis=trigger.Info.Yaxis;
% triggerInfo.TriggerXaxis=trigger.Info.Xaxis;
% triggerInfo.SEEGtriggerAlign=(triggerseeg-triggerseeg(1))/seeg.Fs;
% 
% %% plot force data
% rspx=repmat(triggerInfo.SEEGtriggerAlign,1,2);
% rspy=repmat([0 0],size(triggerInfo.SEEGtriggerAlign,1),1);
% movtype=[0 0.1;0 0.2;0 0.3;0 0.4];
% colormat=[0.8 0 0;0 0.6 0.1; 0 0.1 0.6; 0 0 0];
% hold on
% for i=1:4
%     seq=[];
%     seq=find(triggerInfo.TriggerSeq==i);
%     rspy(seq,:)=repmat(movtype(i,:),length(seq),1);
%     plot(rspx(seq,:)',rspy(seq,:)','--','color',colormat(i,:),'linewidth',1);
% end
% hold on
% plot(time,force,'linewidth',2.5);
% c=get(gca,'Ylim');
% axis([-50 650 min(c) max(c)]);
% xlabel('Time/ s','fontsize',16);
% ylabel('Force/ MVC','fontsize',16);

