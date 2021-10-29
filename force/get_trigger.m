function trigger1=get_trigger(trigger_channel_original)
% change the prev_trigger and next_trigger if do resample
trigger_channel=rescale(trigger_channel_original,-1,1);
trigger=zeros(1,size(trigger_channel,2));
index=(trigger_channel > 0.2 & trigger_channel < 0.6);
trigger(index)=1;
x=[1:size(trigger_channel,2)];
%findpeaks(trigger,x);hold on;
%plot(locs,0,'o');
%xticks(locs); % estimate=(before:509530+after:569770)/2
%a=[1:41];
%xticklabels(num2cell(a)) % index each marker from 1 to 41
prev_trigger=254770;
next_trigger=284890;
estimate=(prev_trigger+next_trigger)/2;
trigger(prev_trigger+1:next_trigger-1)=0;
trigger(estimate)=1;

trigger1=trigger;
% remove some continuous ones
for i=1:size(trigger1,2)
    if trigger1(i)==1 && trigger1(i+1)==1
        trigger1(i+1:i+20)=0;
    end
end
    
end