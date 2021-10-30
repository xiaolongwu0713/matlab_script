function [Datacell, channelNum] = preprocessing2(subj, fs)
%%
fprintf('\n subj %d: preprocessing2....', subj);
global processing_dir;
pn = subj;
Fs = fs;

sessionNum = 2;
%address=strcat('/Users/long/Documents/data/gesture/preprocessing/P',num2str(pn));
address=strcat(processing_dir,'P',num2str(pn),'/');

strname=strcat(address,'preprocessing1.mat');
load(strname,'Datacell','good_channels');

for i=1:sessionNum
        fprintf('\n session %d', i);
%% filter the BCI signal.
    Data = Datacell{i};  % 184= chn + emg1 +emg2 + emgdiff +label
    feaLabel = Data(:,end);
    EMG=Data(:,end-3:end-2);
    BCIdata = Data(:, 1:end-4);
    
    AllchannelNum = size(BCIdata,2);
    
    figure (1);clf;
    subplot(211);plot(BCIdata(:,1));
    title('raw signal');
    
    OME=[0.5 400];
    BCIdata=cFilterD_EEG(BCIdata,AllchannelNum,Fs,2,OME);
    subplot(212);plot(BCIdata(:,1));
    title('filtered signal');
%% alignment of feature_lable and EMG.
    EMGdiff = Data(:,end-1); % emg diff data
    EMGdiff_smooth=smooth(abs(EMGdiff),0.025*Fs);
    
    EMG_trigger=zeros(size(Data,1),1);
    trigger=find(feaLabel~=0); % search for the trigger position and label
    
    for trial=1:length(trigger)  % the segment number (i th)
        EMG_segment=EMGdiff(trigger(trial):trigger(trial)+5*Fs); % 5s-long EMG data segment after the trigger signal
        alarm=envelop_hilbert_v2(EMG_segment,round(0.025*Fs),1,round(0.05*Fs),0);
        % trigger plus muscle delay:find(alarm==1,1); why: -round((0.025*Fs-1)/2)
        robustIndex=trigger(trial)+find(alarm==1,1)-round((0.025*Fs-1)/2);
        
        % make the comparison of envelop_hilbert trigger and EMG mean value
        % trigger. pick the one who come first.
        EMG_segment=EMGdiff_smooth(trigger(trial):trigger(trial)+5*Fs -1); % 5s-long smoothed EMG data segment after the trigger signal
        meanval=mean(EMG_segment);
        for t=trigger(trial)+0.25*Fs:(trigger(trial)+4.5*Fs) % 0.25s-4.5s in the segment
            if EMGdiff_smooth(t)>=1.5*meanval  % use the first EMG peak in this segment as the mark
                if t>robustIndex
                        EMG_trigger(robustIndex)=feaLabel(trigger(trial));
                else
                        EMG_trigger(t)=feaLabel(trigger(trial));
                end             
                break;
            end
        end
    end
%% rereference.
    BCIdata_referenced=cAr_EEG_Local(BCIdata,good_channels,pn);                
      
    Data=[BCIdata_referenced(:,good_channels),EMG,feaLabel, EMG_trigger];% (eegdata,2*EMG, 1*fealabel,1*EMG_trigger)
    %Data=[EMG,EMGdiff,feaLabel, EMG_trigger];
    Datacell{i}=Data;          
end

channelNum = length(good_channels); 
%% save data file.
strname = strcat(address,'/preprocessing2.mat');
save(strname, 'Datacell','channelNum','-v7.3');


end

