session=2;
data=load_data(session,'seeg'); %data=load_data(2,'force'); 
seeg=data.seeg;
seeg=resample(seeg',1000,2000)';
%plot(seeg(1,:));hold on;

trigger_tmp=data.trigger_channel;
trigger_res=resample((data.trigger_channel)',1000,2000)';
trigger=get_trigger_norm(trigger_res);
plot(trigger);hold on;

force_data=load_data(1,'force');
force_tmp=force_data.force;
index = 2:2:length(force_tmp);
force = force_tmp(index);
time = force_tmp(index-1);
force=resample(force,1000,5000);
padding=ones(find(trigger,1,'first'),1);
force1=[padding',force'];
plot(force1-2.7);hold on;
