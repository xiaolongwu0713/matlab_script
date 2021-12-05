function [Datacell, channelNum] = pre_2_Algorithm(subj, fs)
%%


fprintf('\n subj %d: pre_2_Algorithm', subj);
pn = subj;
Fs = fs;

sessionNum = 2;
address=strcat('/Volumes/Samsung_T5/data/gesture/LSJ/P',num2str(pn),'/');
Folder=strcat(address,'preprocessing2/');
if ~exist(Folder,'dir')
    mkdir(Folder);
end

strname=strcat(address,'preprocessing1/preprocessingALL_1.mat');
load(strname,'Datacell','good_channels');

for i=1:sessionNum
        fprintf('\n session %d', i);
%% filter the BCI signal.
    Data = Datacell{i};
    BCIdata = Data(:, 1:end-2);
    AllchannelNum = size(BCIdata,2);
    
    figure (1);clf;
    subplot(211);plot(BCIdata(:,1));
    title('raw signal');
    
    OME=[0.5 400];
    BCIdata=cFilterD_EEG(BCIdata,AllchannelNum,Fs,2,OME);
    subplot(212);plot(BCIdata(:,1));
    title('filtered signal');
%% alignment of feature_lable and EMG.
    EMGdata = Data(:,end-1);
    feaLabel = Data(:,end);
    EMGdata_smooth=smooth(abs(EMGdata),0.025*Fs);
    
    EMG_trigger=zeros(size(Data,1),1);
    trigger=find(feaLabel~=0); % search for the trigger position and label
    
    for trial=1:length(trigger)  % the segment number (i th)
        EMG_segment=EMGdata(trigger(trial):trigger(trial)+5*Fs); % 5s-long EMG data segment after the trigger signal
        alarm=envelop_hilbert_v2(EMG_segment,round(0.025*Fs),1,round(0.05*Fs),0);
        robustIndex=trigger(trial)+find(alarm==1,1)-round((0.025*Fs-1)/2);
        % the position of the first detected EMG activity in i(th) trial segment among the whole signal
        
        % make the comparison of envelop_hilbert trigger and EMG mean value trigger
        for t=trigger(trial)+0.25*Fs:(trigger(trial)+4.5*Fs) % 0.25s-4.5s in the segment
            EMG_segment=EMGdata_smooth(trigger(trial):trigger(trial)+5*Fs -1); % 5s-long smoothed EMG data segment after the trigger signal
            meanval=mean(EMG_segment);
            if EMGdata_smooth(t)>=1.5*meanval  % use the first EMG peak in this segment as the mark
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
      
    Data=[BCIdata_referenced(:,good_channels), EMG_trigger];
    Datacell{i}=Data;          
end

channelNum = length(good_channels); 
%% save data file.
strname = strcat(Folder,'preprocessingALL_2.mat');
save(strname, 'Datacell','channelNum','-v7.3');


end

