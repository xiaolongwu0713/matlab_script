function  [channelnum]=Load_Resize_Standard_V7(pn,class,session,trigger_chn,emg_chn,UseChn,bandf,para,Fs,carind)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used to load and resize the useful raw data (useful data)
%updated @2016.09.05, update contents, add fea_label into the data matrix
%and show the useful EMG channels to be referenced.
% class is the movement mode, finger only (2)or entire hand(1).
% pn is the subject order.
% written by liguangye (liguangye.hust@gmail.com) @sjtu @2016.04.27
% updated by Liguangye (liguangye.hust@gmail.com) @USA @2017.04.10
% UseChn is the picked EEG channels to be extracted 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mode=cell(2,1);
str=cell(3,1);
address=pwd;
channelnum=0;
if length(bandf)~=2
    error('Frequency Band shall be a 1*2 array, check the last varaible in this function. \n');
end

j=class % movement mode 1,2 % class
    mode{j}=num2str(j);
    for i=session % session num
        str{i}=num2str(i);
        strname=strcat('C:\Files\Raw_Data\P',num2str(pn),'\1_Raw_Data_Transfer\','P',num2str(pn),'_H',mode{j},'_',str{i},'_Raw.mat');
        load(strname);
        Data=Data';% Fs=1000Hz          
        %%%%%%%%%%%%%%%%%%%%%%This part is different for different subject%
        %%%%%%%%%%%%%%%%%%%%%% check the raw data first %%%%%%%%%%%%%%%%%%%
%         figure()
%         plot(EMG);
%         hold on;
% %          EMG2=Filter_EMG_Chn(Data(:,emg_chn),1000,[5,40]);
% %          plot(EMG2)
% %          hold on;
%         plot(1000*fea_label);
%         
        fprintf('Please check the EMG signal! If everything is good, press enter to continue,\n');
        fprintf('or ctrl+c and then go to modify the parameter in this function \n');
%       input('');
        fprintf('Program Starts~');
        %%% EMG signal has already filtered and doesn't need to filter again in the following steps
        % some channels are useless and neeed to be removed,	     
            
 
%         figure();
%         spectopo(Data(30001:40000,1)',0,1000);
        % extract another dataset here (to check the temporal information)         
		% pick up good channels
	
%         Ele_Sle=[88:-1:79]; % L3-L12
%         Ele_Sle_l=[88:-1:79]-1; % L3-L12
%         nData=Data(:,Ele_Sle)-Data(:,Ele_Sle_l);
%        save(strcat('bipolar_test_',num2str(i),'.mat'),'nData');
         Fs=2000;
        fea_label=Getmarker(resample(double(Data(:,trigger_chn)),1,2),5,10);% trigger data
        EMG=Filter_EMG_Chn(Data(:,emg_chn),Fs,bandf);%% useful EMG channels
        EMG_org=Filter_EMG_Chn(Data(:,emg_chn),Fs,[0.5,400]);
        Data= Data(:,UseChn); % H10 has some problem for P3
        goodchs=remove_bad_channels(Data, Fs, para); 
        Data=double(Data);
        Data=cFilterD_EEG(Data,size(Data,2),Fs,2,[0.5,400]);% %with 50Hz Notch filter


       if carind~=0  % carind==0 no car
           switch carind
               case 1
                   Data=cAr_EEG(Data,goodchs,i); %CAR
                   if ~exist('WITHCAR','dir')
                       mkdir('WITHCAR');
                   end
                   strname1=strcat('WITHCAR\P',num2str(pn),'_H',mode{j},'_',str{i},'_Marker_Selected.mat');
               case 2
                   Data=cAr_EEG_CW(Data,goodchs,pn); %CAR
                   if ~exist('WITHCAR_CW_GROUPED','dir')
                       mkdir('WITHCAR_CW_GROUPED');
                   end
                   strname1=strcat('WITHCAR_CW_GROUPED\P',num2str(pn),'_H',mode{j},'_',str{i},'_Marker_Selected.mat');
               case 3
                   Data=cAr_EEG_Local(Data,goodchs,pn); % local reference laplacian
                   if ~exist('LOCALREF','dir')
                       mkdir('LOCALREF');
                   end
                   strname1=strcat('LOCALREF\P',num2str(pn),'_H',mode{j},'_',str{i},'_Marker_Selected.mat');
                   strname2=strcat('LOCALREF\P',num2str(pn),'_H',mode{j},'_',str{i},'_Marker_Selected_EMG.mat');
               case 4
                   Data=cAr_EEG_Median(Data,goodchs); % CMR
                   if ~exist('WITHCAR_Median','dir')
                       mkdir('WITHCAR_Median');
                   end
                   strname1=strcat('WITHCAR_Median\P',num2str(pn),'_H',mode{j},'_',str{i},'_Marker_Selected.mat');
               case 5
               Data=cAr_EEG_Chn_Spec(Data,goodchs); % Chn_Specific
               if ~exist('WITHCAR_Chn_Spec','dir')
                   mkdir('WITHCAR_Chn_Spec');
               end
               strname1=strcat('WITHCAR_Chn_Spec\P',num2str(pn),'_H',mode{j},'_',str{i},'_Marker_Selected.mat');
               case 6
               Data=cAr_EEG_Ele_Spec(Data,goodchs,pn); % Ele_Specific
               if ~exist('WITHCAR_Ele_Spec','dir')
                   mkdir('WITHCAR_Ele_Spec');
               end
               strname1=strcat('WITHCAR_Ele_Spec\P',num2str(pn),'_H',mode{j},'_',str{i},'_Marker_Selected.mat');
               case 7 
               [Data,goodchs_bip]=cAr_EEG_Bipolar(Data,goodchs,pn); % Ele_Specific
               if ~exist('BiPolar','dir')
                   mkdir('BiPolar');
               end
               strname1=strcat('BiPolar\P',num2str(pn),'_H',mode{j},'_',str{i},'_Marker_Selected.mat');
           end
       else
        if ~exist('WITHOUTCAR','dir')
            mkdir('WITHOUTCAR');
        end
        strname1=strcat('WITHOUTCAR\P',num2str(pn),'_H',mode{j},'_',str{i},'_Marker_Selected.mat');     
       end
	    Data=resample(Data,1,2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Ele_Sle=[154:-1:145]; % E
%         Ele_Sle_l=Ele_Sle-1; % E
%         nData=Data(:,Ele_Sle)-Data(:,Ele_Sle_l);
%         save(strcat('bipolar_test_',num2str(i),'.mat'),'nData');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        EMG=resample(EMG,1,2);
        EMG_org=resample(EMG_org,1,2);
        NchnName=ChnName(UseChn); 
        save('Electrode_Name_SEEG.mat','NchnName');
        channelnum=size(Data,2);
        Data=[Data,EMG,fea_label];
        channelL=size(Data,2);
        
        NchnName(channelL-1,1).labels='EMG';
        NchnName(channelL,1).labels='Fea_labels'; 	
        EMG_marker=Cal_Latency_EMG_V3(Data(:,end-1),fea_label,1000);
%         figure()
%         plot(smooth(abs(EMG),0.025*1000));
%         hold on
%         plot(100*fea_label);
%         hold on
%         plot(10*EMG_marker,'r.','markersize',10);
%          histogram(find(EMG_marker==1)-find(fea_label~=0));
        if carind==7
        goodchs=goodchs_bip;    
        save(strname1,'Data','goodchs','EMG_marker');%useful channels
        else
        save(strname1,'Data','NchnName','goodchs','EMG_marker');%useful channels
        if carind==3
            save (strname2,'EMG_org','goodchs','EMG_marker','fea_label');
        end
        end
		fprintf('Please check the signal noise here!\n');
		fprintf('Adjust the threshold if it is necessary!\n');
		fprintf('Restart');
		% Resize the data based on the verification of both trigger and EMG labels.
%         Data=ResizeData_Stanard_V6(Data,1000,5,i);       
%         strname2=strcat('P',num2str(pn),'_H',mode{j},'_',str{i},'_EMG_Selected.mat');
%         save(strname2,'Data','NchnName','goodchs');%useful channels
    end
% end

end