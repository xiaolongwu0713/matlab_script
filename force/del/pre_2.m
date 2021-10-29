function pre_2(subj, fs, inx)

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
load(strname);
clear Folder address strname


for i=1:sessionNum
        fprintf('\n session %d', i);
%       ___________________________________________________________________
%       ________________________filter the BCI signal______________________
    Data = Datacell{i};
    BCIdata = Data(:, 1:end-2);
    channelNum = size(BCIdata,2);
    
    figure (1);clf;
    subplot(311);plot(BCIdata(:,1));
    title('raw signal');
    
    OME=[0.5 400];
    BCIdata=cFilterD_EEG(BCIdata,channelNum,Fs,2,OME);
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
    BCIdata_referenced=cAr_EEG_Local(BCIdata,1:size(BCIdata,2),pn);
    tampStr =  '_Local';
        case 2
    % bipolar.
    BCIdata_referenced=cAr_EEG_Bipolar(BCIdata,1:size(BCIdata,2),pn);
    tampStr =  '_Bipolar';
        case 3
    % CAR mean.
    BCIdata_referenced=cAr_EEG(BCIdata,1:size(BCIdata,2));
    tampStr =  '_mean';
        case 4
    % CAR median.
    BCIdata_referenced=cAr_EEG_Median(BCIdata,1:size(BCIdata,2));
    tampStr =  '_median';
    %
%     BCIdata_referenced=cAr_EEG_Ele_Spec(BCIdata,1:size(BCIdata,2),pn);
        case 5
    % GWR.
    BCIdata_referenced=cAr_EEG_CW(BCIdata,1:size(BCIdata,2),pn);
    tampStr =  '_CW';
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
    
    Data=[BCIdata_referenced,EMG_trigger];
    Datacell{i}=Data;
    
end

%       ___________________________________________________________________
%       ________________________save data file_____________________________
strname = strcat('preprocessing2/preprocessingALL_2',tampStr,'.mat');
save(strname, 'Datacell', 'channelNum','-v7.3');