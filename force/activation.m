function rsq=activation(session,type,band)
% type: seeg/power1/power2/test....
% return rsq(channels,trials)
% fs=1000;
global processed_data;
if strcmp(type,'epoch')
    filename=strcat(processed_data,'SEEG_Data/','PF6_F_',num2str(session),'_EPOCH','.mat');
    % uncomment below to do the test
    %filename=strcat(processed_data,'SEEG_Data/','PF6_F_',num2str(session),'_EPOCH_test','.mat');
    tmp=load(filename);
    data=tmp.epoch; clear tmp;
%elseif strcmp(type,'move1')
elseif startsWith(type,'move')
    if strcmp(band,'low')
        filename=strcat(processed_data,'/SEEG_Data/',type,'_epochLowAmp.mat');
    elseif strcmp(band,'high')
        filename=strcat(processed_data,'/SEEG_Data/',type,'_epochHighAmp.mat');
    end
    tmp=load(filename);
    data=tmp.data; clear tmp;
    rsq=rsqMove(data,type);
    return
elseif strcmp(type,'power1')
    filename=strcat(processed_data,'/SEEG_Data/','PF6_F_',num2str(session),'_Power1.mat');
    tmp=load(filename);
    data=tmp.power; clear tmp;
elseif strcmp(type,'power2')
    1==1;
elseif strcmp(type,'testPowerActivation')
    filename=strcat(processed_data,'/SEEG_Data/','PF6_F_',num2str(session),'_testPower.mat');
    tmp=load(filename);
    data=tmp.power; clear tmp;
elseif strcmp(type,'testLowAmp')
    filename=strcat(processed_data,'/SEEG_Data/','testLowAmp.mat');
    tmp=load(filename);
    data=tmp.data; clear tmp;
elseif strcmp(type,'test')
    filename=strcat(processed_data,'/SEEG_Data/','testEpoch.mat');
    tmp=load(filename);
    data=tmp.data; clear tmp;
end
infofile=strcat(processed_data,'SEEG_Data/','PF6_F_',num2str(session),'_Info','.mat');
load(infofile); % load Info

task_duration=Info.task_duration; 
trial_duration=Info.trial_duration; % all 15 s

% seeg(channel, time, trial)
channels=size(data,1);
trials=size(data,3);
len=size(data,2);
rsq=zeros(trials,channels);
for trial=[1:trials]
    tstart=2*1000;
    tend=task_duration(trial)*1000;
    task=data(:,tstart:tend,trial);
    baseline1=data(:,1:tstart-1,trial);
    baseline2=data(:,tend+1:len,trial);
    baseline=[baseline1,baseline2];
    for chn=[1:channels]
        rsq(trial,chn)=rsqu(task(chn,:),baseline(chn,:));
    end
end
rsq=rsq';
end

% test
%session=1;
%data=ones(109,15000,40);
%task_duration=Info.task_duration; 
%trial=5;chan=3;
%task_duration(5) %7.5s
%data(3,(2000:9500),5)=2;
%filename=strcat(processed_data,'SEEG_Data/','testEpoch.mat');
%save(filename,'data');
% act=activation(1)
% surface(act)

function rsq=rsqMove(data,type)
channels=size(data,1);
trials=size(data,3);
len=size(data,2);
rsq=zeros(trials,channels);
if strcmp(type,'move1')
    ascendEnd=5;
elseif strcmp(type,'move2')
    ascendEnd=11;
elseif strcmp(type,'move3')
    ascendEnd=3;
elseif strcmp(type,'move4')
    ascendEnd=5;
end

for trial=[1:trials]
    tstart=2*1000;
    %tend=13.5*1000;
    tend=ascendEnd*1000; % looking at ascending stage
    task=data(:,tstart:tend,trial);
    baseline1=data(:,1:tstart-1,trial);
    baseline2=data(:,tend+1:len,trial);
    baseline=[baseline1,baseline2];
    for chn=[1:channels]
        rsq(trial,chn)=rsqu(task(chn,:),baseline1(chn,:));
    end
end
rsq=rsq';
end
