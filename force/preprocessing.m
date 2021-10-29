%%
preall;
%% load raw seeg, resample, [0.5,400]banpass it, format trigger, attach trigger, force and target to seeg.
for session=[1:sessions]
    msg=strcat('Processing session ', num2str(session));
    fprintf(msg);
    % Load SEEG
    Info(session).session=session;
    data=load_data(session,'seeg'); %data=load_data(2,'force'); load_data will filter channel by useChannles. 
    seeg=data.seeg;
    trigger_channel=resample(data.trigger_channel,fs,Fs);
    seeg=resample(seeg',fs,Fs)';

    % Band-pass filter
    k=2;
    bandf=[0.5 400];Info(session).passband=bandf;
    % K=0:low pass filter; K=1:bandpass; K=2:bandpass + notch filter
    seeg_filtered=cFilterD_EEG(seeg',size(seeg,1),fs,k,bandf); 
    seeg=seeg_filtered';%

    % Detect bad channels, keep the noisy channel for now
    both=split_good_bad_channels(seeg',session,fs,8); 
    Info(session).goodChannel=both.goodChannel;
    Info(session).badChannel=both.badChannel;
    %seeg=seeg(both.goodChannel,:);
    
    % Laplatian Re-reference
    %seegRef=cAr_EEG_Local(seeg,1:size(seeg,1));
    %seeg=seegRef; % TODO: check without reference
    
    % attach trigger and Extract event marker to eeglab
    fprintf('save trigger');
    if session==1
    trigger=get_trigger(trigger_channel);
    else
    trigger=get_trigger_norm(trigger_channel);
    end
    % remove last trigger
    index=find(trigger,1,'last');
    trigger(index)=0;
    % get movement type info
    schemadata=load_data(session,'trigger');
    movement=schemadata.Exp_Seq; % movement=1,2,3,4
    index=find(trigger==1);
    trigger(index)=movement;
    export_to_eeglab_event(trigger,session);
    %seeg=cat(1,seeg,trigger);
    
    % attach real force
    forceraw=load_data(session,'force');
    x = 2:2:length(forceraw);
    force = forceraw(x);
    time = forceraw(x-1);
    force = force-min(force);
    ffs=double(length(time)/time(end)); %5000
    force=resample(force,fs,5000);
    firstone=find(trigger,1); % 28207
    lastone=find(trigger,1, 'last'); %617125
    padbefore=zeros(1,(firstone-1));
    force=cat(2,padbefore, force');
    force(end:length(trigger))=0; % padding force to 648081
    seeg=cat(1,seeg,force); %seeg: 111 
    
    % attach target force, generate every target force at trigger postion
    schemadata=load_data(session,'trigger');
    Info(session).movement=schemadata.Exp_Seq;
    moveseq=schemadata.Exp_Seq;
    aNum=0.05;
    targetForce=ones(1,length(trigger))*aNum;
    idx=find(trigger>0.5);
    for seq=[1:length(moveseq)]
        switch moveseq(seq)
            case 1
                flevel=0.4;prep=2000;ascendDuration=3000;holding=2500;
                y1=ones(1,prep)*aNum;
                y2=(flevel-aNum)/ascendDuration*[1:ascendDuration]+aNum;
                y3=flevel*ones(1,holding);
                y4=ones(1,(15000-prep-ascendDuration-holding))*aNum;
                target=cat(2,y1,y2,y3,y4);
                
            case 2
                flevel=1.0;prep=2000;ascendDuration=9000;holding=2500;
                y1=ones(1,prep)*aNum;
                y2=(flevel-aNum)/ascendDuration*[1:ascendDuration]+aNum;
                y3=flevel*ones(1,holding);
                y4=ones(1,(15000-prep-ascendDuration-holding))*aNum;
                target=cat(2,y1,y2,y3,y4);
            case 3
                flevel=0.4;prep=2000;ascendDuration=1000;holding=2500;
                y1=ones(1,prep)*aNum;
                y2=(flevel-aNum)/ascendDuration*[1:ascendDuration]+aNum;
                y3=flevel*ones(1,holding);
                y4=ones(1,(15000-prep-ascendDuration-holding))*aNum;
                target=cat(2,y1,y2,y3,y4);
            case 4
                flevel=1.0;prep=2000;ascendDuration=3000;holding=2500;
                y1=ones(1,prep)*aNum;
                y2=(flevel-aNum)/ascendDuration*[1:ascendDuration]+aNum;
                y3=flevel*ones(1,holding);
                y4=ones(1,(15000-prep-ascendDuration-holding))*aNum;
                target=cat(2,y1,y2,y3,y4);
        end
        targetForce(idx(seq):(idx(seq)+15000-1))=target;
    end
    seeg=cat(1,seeg,targetForce);          
    
    seegfile=strcat(processed_data,'/SEEG_Data/','SEEG_',num2str(session),'.mat');
    save(seegfile, 'seeg');
    
    % save force and trigger to info
    Info(session).force=force;
    Info(session).trigger=trigger;
    % load schema
    
    Info(session).task_duration=schemadata.task_time;
    Info(session).trial_duration=schemadata.trial_length;
    Info(session).xaxis=schemadata.xaxis; % 40 cells containing 5 points each
    Info(session).yaxis=schemadata.yaxis;
     
    
    % visual inspect bad trials
    clf;
    plot(seeg(111,:));hold on; plot(seeg(112,:));
    xticks(find(seeg(111,:)>0));
    xticklabels([1:41]);
    %pause; % inspect trial, press any key to continue;
end
%% save Info 
bad1=Info(1).badChannel;
bad2=Info(2).badChannel;
bad3=Info(3).badChannel;
bad4=Info(4).badChannel;
badChannels=intersect(intersect(bad1,bad2),intersect(bad3,bad4));
allChannels=(1:size(useChannels,2));
goodChannels=setdiff(allChannels,badChannels);
Info(1).commonGoodChannels=goodChannels;
Info(1).commonBadChannels=badChannels;
infofile=strcat(processed_data,'SEEG_Data/','Info','.mat');
save(infofile,'Info');

%% EPOCH option 1: epoch each session

seegfile=strcat(processed_data,'/SEEG_Data/','SEEG_',num2str(session),'.mat');
load(seegfile);% load seeg
seeg=seeg(goodChannels,:);
% Laplatian Re-reference
seegRef=cAr_EEG_Local(seeg,1:size(seeg,1));
seeg=seegRef;

eeglab;

EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',seeg,'srate',fs,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','seeg','gui','off');
%eeglab redraw;

eventfile=strcat(processed_data,'eeglab/',num2str(session),'_eventtable.txt');
EEG = pop_importevent( EEG, 'event',eventfile,'fields',{'type','latency','duration'},'timeunit',0.001);
eeglab redraw;

epoch = pop_epoch( EEG, {  1 2 3 4 }, [0 15]);
epoch=epoch.data;
filename=strcat(processed_data,'SEEG_Data/','PF6_F_',num2str(session),'_EPOCH','.mat');
save(filename, 'epoch');


%% EPOCH option 2: epoch each move
eeglab;
% option 2: save each movementy type
chnNum=110;
move1=zeros(chnNum+2,15000,40);
move2=zeros(chnNum+2,15000,40);
move3=zeros(chnNum+2,15000,40);
move4=zeros(chnNum+2,15000,40);
for session=[1:sessions]
    fprintf('Processing %d \n', session);
    seegfile=strcat(processed_data,'/SEEG_Data/','SEEG_',num2str(session),'.mat');
    load(seegfile);% load seeg
    %seeg=seeg(goodChannels,:);
    % Laplatian Re-reference
    %seegRef=cAr_EEG_Local(seeg(1:110,:),1:size(seeg,1)-2);
    %seeg=seegRef;
    EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',seeg,'srate',fs,'pnts',0,'xmin',0);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','seeg','gui','off');
    %eeglab redraw;
    eventfile=strcat(processed_data,'eeglab/',num2str(session),'_eventtable.txt');
    EEG = pop_importevent( EEG, 'event',eventfile,'fields',{'type','latency','duration'},'timeunit',0.001);

    trialStart=(session-1)*10 +1;
    trialEnd=session*10;
    
    tmp = pop_epoch( EEG, {  '1' }, [0 15]);
    move1(:,:,trialStart:trialEnd)=tmp.data;
    tmp = pop_epoch( EEG, {  '2' }, [0 15]);
    move2(:,:,trialStart:trialEnd)=tmp.data;
    tmp = pop_epoch( EEG, {  '3' }, [0 15]);
    move3(:,:,trialStart:trialEnd)=tmp.data;
    tmp = pop_epoch( EEG, {  '4' }, [0 15]);
    move4(:,:,trialStart:trialEnd)=tmp.data;
    EEG = pop_delset( EEG, [1] ); % clear memory
    ALLEEG=[]; % clear memory
end
fprintf('Saving epochs. \n');
filename=strcat(processed_data,'SEEG_Data/','move1.mat');
move{1}=move1;
data=move1;
save(filename,'data');
filename=strcat(processed_data,'SEEG_Data/','move2.mat');
move{2}=move2;
data=move2;
save(filename,'data');
filename=strcat(processed_data,'SEEG_Data/','move3.mat');
move{3}=move3;
data=move3;
save(filename,'data');
filename=strcat(processed_data,'SEEG_Data/','move4.mat');
move{4}=move4;
data=move4;
fprintf('Saving last epochs');
save(filename,'data');

%% inspect the bad trials

for session =[1:sessions]
    filename=strcat(processed_data,'SEEG_Data/','move1.mat');
    clf;
    tmpmove=load(filename);
    forcetmp=tmpmove(112,:,:);
    forcetmp=reshape(forcetmp,[],1);
    plot(forcetmp)
    tmptrigger=zeros(1,size(forcetmp,1));
    tmptrigger(15000*[1:40])=1;
    hold on;
    plot(tmptrigger);
    points=find(tmptrigger==1);
    xticks(points);
    xticklabels([1:length(points)]);
    
    path='/Users/long/BCI/matlab_scripts/force/plots/trialInspect';
    filename=strcat(path,'/move',num2str(session),'.jpg');
    saveas(gcf,filename);
    pause;
end

