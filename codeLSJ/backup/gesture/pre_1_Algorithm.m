function [Datacell, good_channels] = pre_1_Algorithm(subj, fs, subInfo)
%% ����Ԥ����.
% 1. �� Data ��� feature label.
% 2. �� EMG �˲�.
% 3. ɸѡ bad_Chn, 2 sessions ȡ����Ϊ bad_Chn.
     fprintf('\n subj %d: pre_1_Algorithm', subj);
pn = subj;  
   
SubInfo.Session_num = subInfo.Session_num; 
SubInfo.UseChn = subInfo.UseChn;
SubInfo.EmgChn = subInfo.EmgChn;
SubInfo.TrigChn = subInfo.TrigChn;

sessionNum = 2;
%/Volumes/Samsung_T5/data/gesture/LSJ
address=strcat('/Volumes/Samsung_T5/data/gesture/preprocessing_tf/P',num2str(pn));
if ~exist(address,'dir')
    mkdir(address);
end
Folder=strcat(address,'/preprocessing1');
if ~exist(Folder,'dir')
    mkdir(Folder);
end

Datacell = cell(1, sessionNum);
for i=1:sessionNum
    Fs = fs; 
    fprintf('\n session %d', i);
    
    strname=strcat('/Volumes/Samsung_T5/data/gesture/raw/P',num2str(pn),'/1_Raw_Data_Transfer/','P',...
                                            num2str(pn),'_H1_',num2str( SubInfo.Session_num(i)),'_Raw.mat');                                                                       
    load(strname, 'Data');
% Data matrix transposition for the resize use.
% The data type required by the function_filtfilt.
    Data = double(Data');
    if Fs > 1000
        Data = Data(1:2:end, :);
        Fs = 1000;
    end
%% integrate five triggers into one vector.
    triggerdata=Data(:,SubInfo.TrigChn);
    L = size(Data, 1); nclass = size(triggerdata, 2);   % L:Length of time
    feaLabel=zeros(L,1);
    for class_type=1:nclass
        mid_data=(max(triggerdata(:,class_type))+min(triggerdata(:,class_type)))/2; %(it doesn't matter)the mid value of each trigger colunm
        for time=1:L-1
            if triggerdata(time,class_type)<mid_data && triggerdata(time+1,class_type)>=mid_data
                feaLabel(time)=class_type;  % the positions of trigger(i).
            end
        end
    end
    figure(1);clf;
    plot(feaLabel);
    
%% filter the EMG data
    EMG = Data(:, SubInfo.EmgChn);
    nEMG = size(EMG, 2);
   
%      	Notch IIRCOMB filter
    F0=50;q=30;
    n=round(Fs/F0);
    bw=(F0/(Fs/2))/q;
    [B,A] = iircomb(n, bw, 'notch');  % 50Hz 'notch'
    EMG(:,1:nEMG)=filtfilt(B,A,EMG(:,1:nEMG));
    
%    	Bandpass filter
    w0=[1.5/(Fs/2),150/(Fs/2)];
    [B,A]=butter(4,w0);
    EMG(:,1:nEMG)=filtfilt(B,A,EMG(:,1:nEMG));
        
    EMGDIF=EMG(:,1)-EMG(:,2);
    figure (2);clf;
    plot(EMGDIF);
    title('EMG abstraction');
        
%% select useful channals
    
    figure(3);clf;
    Data = Data(:, SubInfo.UseChn);
    Data = [Data, EMGDIF, feaLabel];
    good_channels = remove_bad_channels(Data(:, 1:end-2), Fs, 10);
    
    goodChns{i} = good_channels;
    Datacell{i}=Data;   
end

good_channels = union(goodChns{1}, goodChns{2});
%% save data file. 
strname = strcat(Folder,'/preprocessingALL_1.mat'); 
save(strname,'Datacell','good_channels','-v7.3');
end