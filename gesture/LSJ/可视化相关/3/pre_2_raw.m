function pre_2_raw(subj, fs, inx)

% band-pass filtering, [0.5 400]. Refer to the time-frequency diagram of guangye.

%        __________________________________________________________________
%        ____________________load and select the data______________________

    fprintf('\n subj %d: pre_2', subj);
pn = subj;
Fs = fs;
sessionNum = 2;

address=strcat('D:/lsj/preprocessing_data/P',num2str(pn));
cd(address);
Folder=strcat('preprocessing2');
if ~exist(Folder,'dir')
    mkdir(Folder);
end
strname=strcat('preprocessing1/preprocessingALL_1.mat');
load(strname,'Datacell','good_channels');
clear Folder address strname

for i=1:sessionNum
        fprintf('\n session %d', i);
%       ___________________________________________________________________
%       ________________________filter the BCI signal______________________
    Data = Datacell{i};
    BCIdata = Data(:, 1:end-2);
    AllchannelNum = size(BCIdata,2);
    
    figure (1);clf;
    subplot(311);plot(BCIdata(:,1));
    title('raw signal');
    
    OME=[0.5 400];
    BCIdata=cFilterD_EEG(BCIdata,AllchannelNum,Fs,2,OME);
    subplot(312);plot(BCIdata(:,1));
    title('filtered signal');
%       ___________________________________________________________________
%       _________________alignment of feature_lable and EMG________________
    EMGdata=Data(:,end-1);
    fea_label=Data(:,end);
    EMGdata_smooth=smooth(abs(EMGdata),0.025*Fs);
    
    EMG_trigger=zeros(size(Data,1),1);
    trigger=find(fea_label~=0); % search for the trigger position and label
    
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
                        EMG_trigger(robustIndex)=fea_label(trigger(trial));
                    else
                        EMG_trigger(t)=fea_label(trigger(trial));
                end             
                break;
            end
        end
    end
%       ___________________________________________________________________
%       ______________________________rereference__________________________
    Inx = inx;
    switch Inx
        case 1
    % laplacian.
    BCIdata_referenced=cAr_EEG_Local(BCIdata,good_channels,pn);
    tampStr =  '_Local';
        case 2      
    % CAR mean.
    BCIdata_referenced=cAr_EEG(BCIdata,good_channels);
    tampStr =  '_mean';
        case 3
    % CAR median.
    BCIdata_referenced=cAr_EEG_Median(BCIdata,good_channels);
    tampStr =  '_median';
        case 4
    %
    BCIdata_referenced=cAr_EEG_Ele_Spec(BCIdata,good_channels,pn);
    tampStr =  '_Ele_Spec';
        case 5
    BCIdata_referenced=cAr_EEG_Chn_Spec(BCIdata,good_channels);
    tampStr =  '_Chn_Spec';        
        case 6
    % GWR.
    BCIdata_referenced=cAr_EEG_CW(BCIdata,good_channels,pn);
    tampStr =  '_CW';
        case 7
    % bipolar.
    [BCIdata_referenced, good_channels_bipolar] = cAr_EEG_Bipolar(BCIdata,good_channels,pn);
    tampStr =  '_Bipolar';
    goodChns{i} = good_channels_bipolar;
        case 8
    BCIdata_referenced = BCIdata;
    tampStr =  '_Raw';
    end
    
    subplot(313);plot(BCIdata_referenced(:,1));
    title('rereferenced signal');
    
%     figure(2);clf;
%             X=fft(BCIdata(:,nchannel));
%             N=size(BCIdata,1);
%             f = Fs*(0:N-1)/N;
%             plot(f(1:N/2),abs(X(1:N/2)));
%     
%     hold on;33b
%             X=fft(BCIdata_referenced(:,nchannel));
%             plot(f(1:N/2),abs(X(1:N/2)));
%             legend('raw frequency spectrum', 'referenced frequency spectrum')

    if Inx ~= 7
        Data=[BCIdata_referenced(:,good_channels),EMG_trigger];
        Datacell{i}=Data;
    else
        if i == 1
            Datacell{i} = [BCIdata_referenced,EMG_trigger];
        elseif i == 2
            good_channels_bipolar = union(goodChns{1}, goodChns{2});
            Data=[BCIdata_referenced(:,good_channels_bipolar),EMG_trigger];
            Datacell{i}=Data;
            Datacell{1} = [Datacell{1}(:,good_channels_bipolar),Datacell{1}(:, end)]; 
            [~, corrChns] = ismember(good_channels_bipolar, good_channels);
            
        end
    end
end

channelNum = length(good_channels);  % 对于bipolar不行.
%       ___________________________________________________________________
%       ________________________save data file_____________________________
strname = strcat('preprocessing2/preprocessingALL_2',tampStr,'_V2.mat');
save(strname, 'Datacell', 'channelNum','corrChns','good_channels_bipolar', '-v7.3');