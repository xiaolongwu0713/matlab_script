function RJ_EEG_pre_v2(subj, sessionNum)
%% load and select the raw data.
pn = subj;

    fprintf('\n subj %d: RJ_EEG_pre_v2', pn);
address=strcat('/Volumes/Samsung_T5/data/ruijin/gonogo/preprocessing/P',num2str(pn));
if ~exist(address,'dir')
    mkdir(address);
end
%cd(address);

Folder=strcat(address,'/preprocessing');
if ~exist(Folder,'dir')
    mkdir(Folder);
end


for session = 1:sessionNum
    
    strname=strcat('/Volumes/Samsung_T5/data/ruijin/gonogo/raw/P',num2str(pn),'/H',num2str(session),'.mat');
    load(strname, 'EEG');
    strname=strcat('/Volumes/Samsung_T5/data/ruijin/gonogo/raw/P',num2str(pn),'/inf',num2str(session),'.mat');
    load(strname, 'accuracy', 'rtime');
    
    Fs = EEG.srate;
    data = double(EEG.data); % 64*1098380
    triggerNum = size(EEG.event,2)-1; % 363-1=362, first one is none meaning.
    
    % The first line of information is useless data.
    triggerInf=zeros(triggerNum,3); %create events in format: [offset code duration]
    for i=1:triggerNum
        logicpos=isstrprop(EEG.event(:,i+1).type,'digit'); % type='S100' == > logical array: [0 1 1 1]
        digpos=str2double(EEG.event(:,i+1).type(logicpos));% extract type code:100
        
        triggerInf(i,1:2)=[EEG.event(:,i+1).latency digpos];% [position, code]
    end
      
%% Remove trigger 23 that should not exist. / Solve the problem of trigger missing.   
    
    remv_Tri=find(triggerInf(:,2)==23);
    triggerInf(remv_Tri',:)=[];
    
    if pn == 6 && session == 2
        triggerInf([238,239], :) = [];
    end
    
    TriStartTrigger = find(triggerInf(:,2)==1);
    startTriNum = size(TriStartTrigger,1); % 60 trials/session
    badTrigger = [];
    badTrial = [];
    diff = 0;
    for i = 1:startTriNum
        if i < startTriNum
            if TriStartTrigger(i+1) - TriStartTrigger(i) < 6                   % // 掉 trigger.
                badTrigger = [badTrigger TriStartTrigger(i): TriStartTrigger(i+1)-1];
                 badTrial = [badTrial i+diff];
            elseif TriStartTrigger(i+1) - TriStartTrigger(i) > 6                % // 掉的 trigger 是 1.
                badTrigger = [badTrigger TriStartTrigger(i): TriStartTrigger(i+1)-1];
                diff_ = floor((TriStartTrigger(i+1) - TriStartTrigger(i))/6);
                badTrial = [badTrial i+diff:i+diff+diff_];
                diff = diff + diff_;
            elseif ~accuracy(i+diff, 1) || ~accuracy(i+diff, 2)                 % // 按键错误.
                 badTrigger = [badTrigger TriStartTrigger(i): TriStartTrigger(i+1)-1];% mark all events in this trail as bad
                 badTrial = [badTrial i+diff];
            end
        else
            if size(triggerInf, 1) - TriStartTrigger(i) < 6 
                badTrigger = [badTrigger TriStartTrigger(i): size(triggerInf, 1)-1];
                badTrial = [badTrial i+diff];
            elseif size(triggerInf, 1) - TriStartTrigger(i) > 6
                badTrigger = [badTrigger TriStartTrigger(i): size(triggerInf, 1)-1];
                diff_ = floor((size(triggerInf, 1) - TriStartTrigger(i))/6); 
                badTrial = [badTrial i+diff:i+diff+diff_];
                diff = diff + diff_;
            elseif ~accuracy(i+diff, 1) || ~accuracy(i+diff, 2)                 % // 按键错误.
                badTrigger = [badTrigger TriStartTrigger(i): size(triggerInf, 1)-1];
                badTrial = [badTrial i+diff];
            end
        end
    end
    triggerInf_Modified=triggerInf; rTime_Modified  = rtime;
    triggerInf_Modified(badTrigger,:) = [];
    rTime_Modified(badTrial,:) = [];
    
    BadTrial{session} = badTrial;
%% 检测 trigger 和范式预设时间点的重合度.there are 4 fixed 3s intervals
    TriStartTrigger = find(triggerInf_Modified(:,2)==1);
    startTriNum = size(TriStartTrigger,1);
    
    warningTrigger = [];
    warningTrial = [];
    for i=1:startTriNum % calculate duration between events 
        triggerInf_Modified( [TriStartTrigger(i):TriStartTrigger(i)+1], 3) = round((triggerInf_Modified([TriStartTrigger(i)+1:TriStartTrigger(i)+2], 1) - triggerInf_Modified([TriStartTrigger(i):TriStartTrigger(i)+1], 1))/Fs);
        triggerInf_Modified( [TriStartTrigger(i)+3, TriStartTrigger(i)+5], 3) = rTime_Modified(i,:)';
        triggerInf_Modified( [TriStartTrigger(i)+2, TriStartTrigger(i)+4], 3) = round((triggerInf_Modified([TriStartTrigger(i)+3, TriStartTrigger(i)+5], 1) - triggerInf_Modified([TriStartTrigger(i)+2, TriStartTrigger(i)+4], 1)-rTime_Modified(i,:)'*Fs)/Fs);
        % there are 4 fixed 3s intervals
        if sum(double(triggerInf_Modified( [TriStartTrigger(i):TriStartTrigger(i)+2, TriStartTrigger(i)+4], 3) ~= [3; 3; 3; 3]))
            warning('\n The actual trigger marker time does not match the time preset by the paradigm!\n subj %d, session %d,trial %d.', pn, session, i)
            warningTrigger = [warningTrigger TriStartTrigger(i):TriStartTrigger(i+1)-1];
            warningTrial = [warningTrial i];
        end
    end
    triggerInf_Modified(warningTrigger,:) = [];
    rTime_Modified(warningTrial,:) = [];
    
    WarningTrial{session} = warningTrial;
    Trigger{session} = triggerInf_Modified;
    ReactionTime{session} = rTime_Modified;
    
%% remove bad channels.
    data=data';
    good_channels = remove_bad_channels(data, Fs, 10);
    DATA{session}  = data;
    if session == 1;GoodChns = good_channels;else;GoodChns = intersect(GoodChns, good_channels);end
end   
%% filter the EEG signal.
for session = 1:sessionNum 
    data = DATA{session};
    data = data(:, GoodChns);
    
    % figure (1);clf;
    % subplot(311);plot(data(:,1));
    % title('raw signal');

    channeNum=size(data,2);
    
    OME=[0.5, 400];
    data=cFilterD_EEG(data,channeNum,Fs,2,OME);
    % subplot(312);plot(data(:,1));
    % title('filtered signal');
    
    meanval = mean(data, 2);
    data = data-repmat(meanval,1,size(data,2));
    % subplot(313);plot(data(:,1));
    % title('referenced signal');
    DATA{session} = data;
end
%%
strname = strcat(address,'/preprocessing/preprocessingv2.mat');
save(strname,'DATA','Trigger','Fs', 'ReactionTime', 'GoodChns','BadTrial','WarningTrial', '-v7.3');

end
