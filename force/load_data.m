function data=load_data(session,movetype) 
% load(1,seeg/epoch/move1/2/3/4/test/emg/force/trigger)
fprintf('\nLoading. \n');
useChannels=[1:15,17:29,38:119];
global processed_data root_path;
% session 1 (seeg, trigger, force, emg)
if strcmp(movetype,'seeg')
    path='/Users/long/Documents/BCI/matlab_scripts/data/grasp_data/PF6_SYF_2018_08_09_Simply/SEEG_Data/';
    % SEEG data
    filename=strcat('PF6_F_',num2str(session),'.mat');
    load(strcat(path,filename));
    data.seeg=Data(useChannels,:); % seeg data(110,1296162)
    data.channels=ChnName(useChannels,:)'; % channel data
    data.trigger_channel=Data(30,:);
    data.fs=Fs;
elseif strcmp(movetype,'epoch')
    path=strcat(processed_data,'/SEEG_Data/');
    filename=strcat(path,'move',num2str(session),'.mat');
    data=load(filename);
elseif strcmp(movetype,'move1') || strcmp(movetype,'move2') || strcmp(movetype,'move3') || strcmp(movetype,'move4')
    path='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/';
    tmp=str2double(movetype(end));
    filename=strcat(path,'move',num2str(tmp),'.mat');
    tmp=load(filename);
    data=tmp.data;
%elseif strcmp(movetype,'delta4') || strcmp(movetype,'theta4') || strcmp(movetype,'alpha4') || strcmp(movetype,'beta4') || strcmp(movetype,'gamma4')
elseif contains(movetype,'delta') ||  contains(movetype,'theta') ||  contains(movetype,'alpha') ||  contains(movetype,'beta') ||  contains(movetype,'gamma')
path='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/';
    filename=strcat(path,'powerOf',movetype,'.mat');
    tmp=load(filename);
    data=tmp.power;
elseif strcmp(movetype,'info')
    path='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/';
    filename=strcat(path,'Info.mat');
    tmp=load(filename);
    data=tmp.Info;

elseif strcmp(movetype,'plsmove1') || strcmp(movetype,'plsmove2') || strcmp(movetype,'plsmove3') || strcmp(movetype,'plsmove4')
    filename=strcat(root_path,'pls/',movetype,'.mat');
    data=load(filename).sol;
elseif contains(movetype,'TrainData')
    type=movetype(5);
    filename=strcat(root_path,'pls/move',num2str(type),'TrainData.mat');
    data.trainset=load(filename).train;
    filename=strcat(root_path,'pls/move',num2str(type),'TestData.mat');
    data.testset=load(filename).test;

elseif strcmp(movetype,'test')
    path='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/';
    filename=strcat(path,'testEpoch.mat');
    data=load(filename);
elseif strcmp(movetype,'testHilbert')
    path='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/';
    filename=strcat(path,'testHilbert.mat');
    data=load(filename);
elseif strcmp(movetype,'testLowAmp')
    path='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/';
    filename=strcat(path,'testLowAmp.mat');
    data=load(filename);
elseif strcmp(movetype,'force')
    % force data
    path='/Users/long/Documents/BCI/matlab_scripts/data/grasp_data/PF6_SYF_2018_08_09_Simply/Force_Data/';
    filename=strcat('SYF-',num2str(session),'-',num2str(session+1),'.daq'); %filename='SYF-1-2.daq';
    f = fopen(fullfile(path,filename));
    data = fread(f,'double'); %(6039000,1)
elseif strcmp(movetype,'force1') || strcmp(movetype,'force2') || strcmp(movetype,'force3') || strcmp(movetype,'force4')
    % 1D force data, easy to plot force and trigger
    filename=strcat(processed_data,'Force_Data/allForce.mat');
    tmp=load(filename);allforce=tmp.allforce;
    session=str2double(movetype(end));
    tmp1=allforce(session); %first movement
    tmpforce=tmp1{1,1}(1); tmptrigger=tmp1{1,1}(2);
    force=tmpforce{1,1}; trigger=tmptrigger{1,1};
    data.force=force;
    data.trigger=trigger;
elseif strcmp(movetype,'force12D') || strcmp(movetype,'force22D') || strcmp(movetype,'force32D') || strcmp(movetype,'force42D')
    % 1D force data, easy to plot force and trigger
    filename=strcat(processed_data,'Force_Data/allForce2D.mat');
    tmp=load(filename);
    allforce=tmp.force;
    session=str2double(movetype(end-2));
    data=allforce{1,session}; %first movement
elseif strcmp(movetype,'trigger')
    % Trigger data
    path='/Users/long/Documents/BCI/matlab_scripts/data/grasp_data/PF6_SYF_2018_08_09_Simply/Trigger_Data/';
    filename=strcat('Trigger_Information_',num2str(session),'.mat'); %load(strcat(path,'Trigger_Information_1.mat'));
    load(strcat(path,filename));
    data.task_time=Info.task_time;
    data.trial_length=Info.trial_length;
    data.yaxis=Info.Yaxis;
    data.xaxis=Info.Xaxis;
    data.Exp_Seq=Info.Exp_Seq;
elseif strcmp(movetype,'emg')
    % emg data 
    path='/Users/long/Documents/BCI/matlab_scripts/data/grasp_data/PF6_SYF_2018_08_09_Simply/HDEMG_Data/';
    filename=strcat('SYF_session',num2str(session),'.mat');%load(strcat(path,'SYF_session1.mat'));
    load(strcat(path,filename));
    data.emg=Sig;
end

end