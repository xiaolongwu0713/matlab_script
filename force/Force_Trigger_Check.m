%% Load original data
function Force_Trigger_Check(pn, name,session)
global processed_data;
% processed_data==the processed_data for the current data folder,
% pn== the patient number of the current subject, e.g., 6
% name= the initials of the patient nanme, e.g., SYF
% session== the session number of the experiment to be checked, e.g., 1,2,3,4

forcef=strcat(processed_data,'/Force_Data/',name,'-',num2str(session),'-',num2str(session+1),'.daq'); 
a = fopen(forcef);
t = fread(a,'double');
x = 2:2:length(t);
force = t(x);
time = t(x-1);
force = force-min(force);
seegf=strcat(processed_data,'/SEEG_Data/PF',num2str(pn),'_F_',num2str(session),'.mat');
seeg=load(seegf);

triggerf=strcat(processed_data,'/Trigger_Data/Trigger_Information_',num2str(session),'.mat');
trigger=load(triggerf);
%% extract the trigger data points
seegtrigger=seeg.Data(30,:);
maxt=max(seegtrigger);
mint=min(seegtrigger);
threp=find(seegtrigger>0.8*(maxt+mint));
triggerseeg=ones(40,1);
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
plot(triggerseeg)
hold on
%plot(triggerseeg,seegtrigger(triggerseeg),'r.','markersize',30);
%% store trigger Information
triggerInfo.SEEGtrigger=triggerseeg;
triggerInfo.SEEGFs=seeg.Fs;
triggerInfo.TriggerSeq=trigger.Info.Exp_Seq;
triggerInfo.TriggerYaxis=trigger.Info.Yaxis;
triggerInfo.TriggerXaxis=trigger.Info.Xaxis;
triggerInfo.SEEGtriggerAlign=(triggerseeg-triggerseeg(1))/seeg.Fs; % approm 600s 

%% plot force data
rspx=repmat(triggerInfo.SEEGtriggerAlign,1,2);
rspy=repmat([0 0],size(triggerInfo.SEEGtriggerAlign,1),1);
movtype=[0 0.1;0 0.2;0 0.3;0 0.4];
colormat=[0.8 0 0;0 0.6 0.1; 0 0.1 0.6; 0 0 0];
hold on
for i=1:4
    seq=[];
    seq=find(triggerInfo.TriggerSeq==i); % index of type i movement
    rspy(seq,:)=repmat(movtype(i,:),length(seq),1);
    plot(rspx(seq,:)',rspy(seq,:)','--','color',colormat(i,:),'linewidth',1);
end
hold on
plot(time,force,'linewidth',2.5);
c=get(gca,'Ylim');
axis([-50 650 min(c) max(c)]);
xlabel('Time/ s','fontsize',16);
ylabel('Force/ MVC','fontsize',16);
end
