function [intersec, reactive_channels] = channel_selection(Datacell, nchn, Fs, nsession)

% channel selection.
% Alpha and gamma are selected for permutation test. The sorting values of
% two frequency bands in two sessions are summed.
%
% input:  Datacell - cell, processed by pre_2.m.
%         nchn - nummber of channel.
%         Fs - sampling frequency.
%         nsession - default 2.
% output: inx - all channels are sorted according to the p_value of permutation test.
 

if (nargin<3)
    Fs = 1000;
    nsession = 2;
end

if (nargin<4)
    nsession = 2;
end

band.alpha = [1, 30 ];band.gamma = [60, 195];

for i=1:nsession
            fprintf('\n session %d', i);
    BCIdata=Datacell{i}(:,1:end-1);
    
% extract each frequency band power.


   	h=fdesign.bandpass('N,F3dB1,F3dB2', 6,band.alpha(1),band.alpha(2), Fs);
    Hd=design(h,'butter');
    [B, A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
    alpha_signal=filtfilt(B,A,BCIdata);
    alpha_envelope= abs(hilbert(single(alpha_signal)));
    power.alpha = alpha_envelope.^2;
    
    
   	h=fdesign.bandpass('N,F3dB1,F3dB2', 6,band.gamma(1),band.gamma(2), Fs);
    Hd=design(h,'butter');
    [B, A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
    gamma_signal=filtfilt(B,A,BCIdata);
    gamma_envelope= abs(hilbert(single(gamma_signal)));
    power.gamma= gamma_envelope.^2;
  

% cut into segment  .  
    
    EMG_trigger=Datacell{i}(:, end); 
    trigger=find(EMG_trigger~=0);
    ntrial=length(trigger);
    seg_duration=8*Fs;
 
    for trial=1:ntrial
        
        POWER_ALPHA{trial}=power.alpha(trigger(trial)+0.25*Fs- seg_duration/2:trigger(trial)+0.25*Fs+ seg_duration/2-1,1:nchn);
        POWER_GAMMA{trial}=power.gamma(trigger(trial)+0.25*Fs- seg_duration/2:trigger(trial)+0.25*Fs+ seg_duration/2-1,1:nchn);
        
  
    end
    
%  channel selection .

    [~,index_a,~] =location_identification(POWER_ALPHA,Fs,nchn,ntrial);
    [~,index_b,~] =location_identification(POWER_GAMMA,Fs,nchn,ntrial);
 

    reactive_channels{i} = [index_a;index_b];
     
end
% select the 10 most relavent channels.

k = 0;
intersec = [];
while length(intersec) < 10
intersec = intersect(intersect(reactive_channels{1}(1:k), reactive_channels{1}(1:k)),...
                               intersect(reactive_channels{2}(1:k),reactive_channels{2}(1:k)));
      k = k + 1;
end

%%
% % Channel selection using single frequency band .
% band.alpha = [1,4];
% 
% for i=1:nsession
%             fprintf('\n session %d', i);
%     BCIdata=Datacell{i}(:,1:end-1);
%     
% % extract each frequency band power.
% 
%    	h=fdesign.bandpass('N,F3dB1,F3dB2', 6,band.alpha(1),band.alpha(2), Fs);
%     Hd=design(h,'butter');
%     [B, A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
%     alpha_signal=filtfilt(B,A,BCIdata);
%     alpha_envelope= abs(hilbert(single(alpha_signal)));
%     power.alpha = alpha_envelope.^2;
%     
% % cut into segment  .  
%     
%     EMG_trigger=Datacell{i}(:, end); 
%     trigger=find(EMG_trigger~=0);
%     ntrial=length(trigger);
%     seg_duration=8*Fs;
%  
%     for trial=1:ntrial
%         
%         POWER_ALPHA{trial}=power.alpha(trigger(trial)+0.25*Fs- seg_duration/2:trigger(trial)+0.25*Fs+ seg_duration/2-1,1:nchn);
%        
%     end
%     
% %  channel selection .
% 
%     [~,index_a,~] =location_identification(POWER_ALPHA,Fs,nchn,ntrial);
%     
%     reactive_channels{i} = index_a;
% end
% % select the 10 most relavent channels.
% 
% k = 0;
% intersec = [];
% while length(intersec) < 10
%     intersec = intersect(reactive_channels{1}(1:k),reactive_channels{2}(1:k));
%     k = k + 1;
% end
% 
% 
