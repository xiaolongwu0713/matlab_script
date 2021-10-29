function trigger=get_trigger_norm(trigger_channel_original)
% change the prev_trigger and next_trigger if do resample
trigger_channel=rescale(trigger_channel_original,-1,1);
trigger=zeros(1,size(trigger_channel,2));
index=(trigger_channel > 0.2);
trigger(index)=1;

% remove some continuous ones
for i=1:size(trigger,2)
    if trigger(i)==1 && trigger(i+1)==1
        trigger(i+1:i+3000)=0;
        i=i+3000;
    end
end
    
end