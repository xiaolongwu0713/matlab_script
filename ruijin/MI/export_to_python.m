% name the dataset as 'data' when import through eeglab, then run below.
data=EEG.data;
events=EEG.event;
event_num=size(events,2);
event_type={};
event_latency=[];
for i=1:event_num
    event_type=[event_type,events(i).type];
    event_latency=[event_latency,events(i).latency];
end

save('/Volumes/Samsung_T5/data/ruijin/MI/RJ_MI_Raw_Data/P2/tmp/v_data.mat', 'data','-v7.3');
save('/Volumes/Samsung_T5/data/ruijin/MI/RJ_MI_Raw_Data/P2/tmp/v_event_type.mat', 'event_type','-v7.3');
save('/Volumes/Samsung_T5/data/ruijin/MI/RJ_MI_Raw_Data/P2/tmp/v_event_latency.mat', 'event_latency','-v7.3');


