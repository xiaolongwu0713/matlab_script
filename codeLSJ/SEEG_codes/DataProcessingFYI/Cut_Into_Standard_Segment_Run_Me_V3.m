%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THis script is used to pre-processing the dataset.
%%%%%This function is used to cut the raw eeg signals into standard
%%%%%segment. 5s rest+5s movement
%%%%%EMG signals were used to mark the start of movement accurately.
%%%%First run Load_Resize_Standard_V5 to cut the raw data 
% Run each section one by one
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Final Update in 2017.04.10¡¡@USA By LI GUANGYE(liguangye.hust@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check and Input the dataset information for further processing
% clc 
% clear all

Configuration_Setup;
%%
% Start extract the SEEG Channels and EMG channels as well as the trigger labels
BAND{1}=[4];
BAND{2}=[4,8];
BAND{3}=[8,12];
BAND{4}=[12,30];
BAND{5}=[30,60];
BAND{6}=[60,140];
BCal=[6];
% T=[0,2,1,6,7,3];
T=[7];
delete_files(T,[5],2,pn);
for carind=T
% carind=0; %%%% carind from 0-7
if ~isempty(SubInfo.UseChn) && ~isempty(SubInfo.EmgChn) && ~isempty(SubInfo.Session_num) && ~isempty(SubInfo.TrigChn)
    [chan]=Load_Resize_Standard_V7(pn,class,SubInfo.Session_num,SubInfo.TrigChn,SubInfo.EmgChn,SubInfo.UseChn,bandf,thre,Fs,carind);
else
    error('Check the input of SubInfo~');
end
if carind==7
save('Chnnum_bip.mat','chan');
else
save('Chnnum.mat','chan');  
end
for bn=BCal
Buse=BAND{bn};

Fs_Res=200;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract the power feature of each band for each trial 
% Marker_Band_Power_V6(class,SubInfo.Session_num,pn,[1:5],Buse,Fs,Fs_Res,carind);
% Marker_Band_Time_Series_V6(class,SubInfo.Session_num,pn,[1:5],Buse,Fs,carind);
end
%%%%%%%%%%%%% Extract the ERP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Marker_ERP_EntireData_V5(class,SubInfo.Session_num,pn,[1:5],Fs);
Marker_TimeSeries_EntireData_V6(class,SubInfo.Session_num,pn,[1:5],Fs,carind);
% Marker_EMG_EntireData_V6(class,SubInfo.Session_num,pn,[1:5],Fs,carind);
% Marker_CAR_EntireData_V6(class,SubInfo.Session_num,pn,[1:5],Fs,1);
switch carind
    case 0    
      delete(strcat('WITHOUTCAR\P',num2str(pn),'_H',num2str(class),'_',num2str(SubInfo.Session_num(1)),'_Marker_Selected.mat'));
      delete(strcat('WITHOUTCAR\P',num2str(pn),'_H',num2str(class),'_',num2str(SubInfo.Session_num(2)),'_Marker_Selected.mat'));
    case 1
        delete(strcat('WITHCAR\P',num2str(pn),'_H',num2str(class),'_',num2str(SubInfo.Session_num(1)),'_Marker_Selected.mat'));
       delete(strcat('WITHCAR\P',num2str(pn),'_H',num2str(class),'_',num2str(SubInfo.Session_num(2)),'_Marker_Selected.mat'));
    case 2
       delete(strcat('WITHCAR_CW_GROUPED\P',num2str(pn),'_H',num2str(class),'_',num2str(SubInfo.Session_num(1)),'_Marker_Selected.mat'));
       delete(strcat('WITHCAR_CW_GROUPED\P',num2str(pn),'_H',num2str(class),'_',num2str(SubInfo.Session_num(2)),'_Marker_Selected.mat'));
    case 3
       delete(strcat('LOCALREF\P',num2str(pn),'_H',num2str(class),'_',num2str(SubInfo.Session_num(1)),'_Marker_Selected.mat'));
      delete(strcat('LOCALREF\P',num2str(pn),'_H',num2str(class),'_',num2str(SubInfo.Session_num(2)),'_Marker_Selected.mat'));
    case 6
      delete(strcat('WITHCAR_Ele_Spec\P',num2str(pn),'_H',num2str(class),'_',num2str(SubInfo.Session_num(1)),'_Marker_Selected.mat'));
      delete(strcat('WITHCAR_Ele_Spec\P',num2str(pn),'_H',num2str(class),'_',num2str(SubInfo.Session_num(2)),'_Marker_Selected.mat'));
    case 7
     delete(strcat('BiPolar\P',num2str(pn),'_H',num2str(class),'_',num2str(SubInfo.Session_num(1)),'_Marker_Selected.mat'));
     delete(strcat('BiPolar\P',num2str(pn),'_H',num2str(class),'_',num2str(SubInfo.Session_num(2)),'_Marker_Selected.mat'));     
end     
end
%% % Select Task-Relevant Channels

% Task_Related_Detection_Configuration;



