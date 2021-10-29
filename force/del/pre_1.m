% function pre_1(subj, fs, subInfo)

clear;
clc;

subj = 3;
fs = 1000;

pn = subj;
Fs = fs;
sessionNum = 2;
address=strcat('D:/lsj/preprocessing_data/P',num2str(pn));
if ~exist(address,'dir')
    mkdir(address);
end
cd(address);
Folder=strcat('preprocessing1');
if ~exist(Folder,'dir')
    mkdir(Folder);
end

SubInfo.Session_num=[1,3];
SubInfo.UseChn=[1:19,21:37,44:45,48:189];
SubInfo.EmgChn=[192:193];
SubInfo.TrigChn=[38:42];


% SubInfo.Session_num = subInfo.Session_num;
% SubInfo.UseChn = subInfo.UseChn;
% SubInfo.EmgChn = subInfo.EmgChn;
% SubInfo.TrigChn = subInfo.TrigChn;

strname1=strcat('D:/lsj/EleCTX_Files_2018_10_26/P',num2str(pn),'/electrodes_Final_Anatomy_wm_All');
strname2=strcat('D:/lsj/EleCTX_Files_2018_10_26/P',num2str(pn),'/SignalChanel_Electrode_Registration');  
load(strname1);
load(strname2);
clear strname1 strname2

tem_CHN=CHN;
tem_elec_Info_Final_wm.ana_label_name=elec_Info_Final_wm.ana_label_name;
%        __________________________________________________________________
%        ____________________remove the missing channel____________________

% count=0;
% for i=1:size(elec_Info_Final_wm.name,2)
%     if contains('N1',elec_Info_Final_wm.name{i})
%         count=count+1;
%         marker=i-count+1;
%         tem_CHN(marker)=[];
%         tem_elec_Info_Final_wm.ana_label_name(marker)=[];
%     end
% end
%        __________________________________________________________________

Datacell = cell(1, sessionNum);
for i=1:sessionNum
    fprintf('\n session %d', i);
    
    strname=strcat('D:/lsj/Raw_Data_All/P',num2str(pn),'/1_Raw_Data_Transfer/','P',...
                                            num2str(pn),'_H1_',num2str( SubInfo.Session_num(i)),'_Raw.mat');  
    Fs = fs;  % 数据 .mat 里有Fs, 有些 10e3 影响后面的计算.                                                                     
    load(strname);
    Data = double(Data');        % Fs=1000Hz, Data matrix transposition for the resize use ;
                                 % The data type required by the function_filtfilt.
    clear strname
%        __________________________________________________________________
%        _____________integrate five triggers into one vector______________
    triggerdata=Data(:,SubInfo.TrigChn);
    L = size(Data, 1); nclass = size(triggerdata, 2);   %L:Length of time
    fea_label=zeros(L,1);
    for class_type=1:nclass
        mid_data=(max(triggerdata(:,class_type))+min(triggerdata(:,class_type)))/2; %(it doesn't matter)the mid value of each trigger colunm
        for time=1:L-1
            if triggerdata(time,class_type)<mid_data && triggerdata(time+1,class_type)>=mid_data
                fea_label(time)=class_type;  % the positions of trigger(i)
            end
        end
    end
    figure(1);clf;
    plot(fea_label);
    
%        __________________________________________________________________
%        ______________________filter the EMG data_________________________
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
        
%        __________________________________________________________________
%        _____________________select useful channals_______________________
    
    figure(3);clf;
    Data = Data(:, SubInfo.UseChn);% slect useful data(channels)
    Data = Data(:, tem_CHN');  %align labels and data
    Data = [Data,EMGDIF, fea_label];
    good_channels = remove_bad_channels(Data(:, 1:end-2), Fs, 10);
    bad_channels = setdiff(1:size(Data(:, 1:end-2),2), good_channels);
    
    badchn{i}=bad_channels;
    Datacell{i}=Data;
    
end

bad_channels = intersect(badchn{1}, badchn{2});
good_channels = setdiff(1:size(Data(:, 1:end-2),2), bad_channels);
for i=1:sessionNum; Datacell{i}=Datacell{i}(:,[good_channels,end-1,end]); end
ana_label=tem_elec_Info_Final_wm.ana_label_name(:,good_channels);


NchnName=ChnName(SubInfo.UseChn); %update the useful channels' names
NchnName=NchnName(good_channels);
NchnName(size(NchnName,1)+1,1).labels='EMG';
NchnName(size(NchnName,1)+1,1).labels='Fea_labels';

%        __________________________________________________________________
%        _________________________save data file___________________________
strname = strcat('D:/lsj/preprocessing_data/P',num2str(pn),'/preprocessing1/preprocessingALL_1.mat'); 

save(strname,'Datacell','NchnName','ana_label','-v7.3');