function RJ_EEG_analysis_v4(subj, sessionNum)
%%
pn=subj;

    fprintf('\n subj %d: RJ_EEG_analysis_v4', pn);
    
Folder=strcat('/Volumes/Samsung_T5/data/ruijin/gonogo/preprocessing/P',num2str(pn));
if ~exist(strcat(Folder,'/analysis'),'dir')
    mkdir(Folder);
end


strname = strcat(Folder,'/preprocessing/preprocessingAll_v2.mat');
load(strname, 'DATA', 'Trigger', 'Fs', 'ReactionTime');

tampGap = 0;
for session = 1:sessionNum
    if session == 1
        data = DATA{session};
        rtime = ReactionTime{session};
        triggerInf = Trigger{session};
    else
        data = [data;DATA{session}];
        rtime = [rtime; ReactionTime{session}];
        Trigger{session}(:,1) = Trigger{session}(:,1) + tampGap;
        triggerInf = [triggerInf; Trigger{session}];
    end
    tampGap = tampGap + size(DATA{session},1);
end


channelNum=size(data,2);
triStartTrigger=find(triggerInf(:,2)==1);
TrialNum=size(triStartTrigger,1);

%reactTime, segmentLength  = 3s+reactTime+0.5s.
Trialtime = []; % from 3/4 to 11/12 or 5/6 to 21/22
for i = 1:TrialNum
    if triggerInf(triStartTrigger(i)+3, 2) == 3
        Trialtime = [Trialtime, triggerInf(triStartTrigger(i)+3, 1)-triggerInf(triStartTrigger(i)+2, 1)];
    end
    if triggerInf(triStartTrigger(i)+5, 2) == 5
        Trialtime = [Trialtime, triggerInf(triStartTrigger(i)+5, 1)-triggerInf(triStartTrigger(i)+4, 1)];
    end
end
TrialtimeMean = ceil(mean(Trialtime)/(Fs/10))*(Fs/10) - 3*Fs; % reaction time?

%%  
BASElength = 0.5;
for chn = 1:channelNum
    GOct = 0; NOGOct = 0;
    for i = 1:TrialNum
        
        TrialData = data(triggerInf(triStartTrigger(i), 1)-BASElength*Fs+1 - 511:triggerInf(triStartTrigger(i)+5, 1) + 513, chn)';% 512
        [tf,freqs,~,~] = timefreq(TrialData,Fs,'freqs',[0.5,195],'tlimits',[0,length(TrialData)],'winsize',1024,'ntimesout', length(TrialData));
        tf = abs(tf); %399       15248
        BASEtf{i} = tf(:, 1:BASElength*Fs-1);% try 0.5s   tf=tf/repmat(mean(BASEtf{i},2),1,size(tf,2))
        tf=tf./repmat(mean(BASEtf{i},2),1,size(tf,2));
        TampTriStartTrigger  =  triggerInf(triStartTrigger(i):triStartTrigger(i)+5, 1) - triggerInf(triStartTrigger(i), 1) + BASElength*Fs;
        if triggerInf(triStartTrigger(i)+3, 2) == 3
            Interp = [];
            for j = 1:length(freqs)
                x = TampTriStartTrigger(3) + 3*Fs:TampTriStartTrigger(4);% reaction interval
                y = tf(j, x);
                xx = linspace(TampTriStartTrigger(3)+ 3*Fs, TampTriStartTrigger(4), TrialtimeMean);
                Interp(j,:) = interp1(x,y,xx,'linear');
            end
            GOct = GOct + 1;
            GOtf{GOct} = [tf(:, TampTriStartTrigger(3):TampTriStartTrigger(3)+3*Fs-1) Interp];% concatenate 3s cue with reaction
        end
        
        if triggerInf(triStartTrigger(i)+5, 2) == 5
            Interp = [];
            for j = 1:length(freqs)
                x = TampTriStartTrigger(5)+ 3*Fs:TampTriStartTrigger(6); % reaction interval
                y = tf(j, x);
                xx = linspace(TampTriStartTrigger(5)+ 3*Fs, TampTriStartTrigger(6), TrialtimeMean);
                Interp(j,:) = interp1(x,y,xx,'linear');
            end
            GOct = GOct + 1;
            GOtf{GOct} = [tf(:, TampTriStartTrigger(5):TampTriStartTrigger(5)+3*Fs-1) Interp];
        end
        
        if triggerInf(triStartTrigger(i)+3, 2) == 4
            NOGOct = NOGOct + 1;
            NOGOtf{NOGOct} = tf(:, TampTriStartTrigger(3):TampTriStartTrigger(3)+6*Fs-1);% wait for 3s without reaction
        end
        
        if triggerInf(triStartTrigger(i)+5, 2) == 6
            NOGOct = NOGOct + 1;
            NOGOtf{NOGOct} = tf(:, TampTriStartTrigger(5):TampTriStartTrigger(5)+6*Fs-1);
        end
        
    end
    
    
    GOtfSum = zeros(length(freqs), TrialtimeMean+3*Fs);
    for k = 1:GOct
        GOtfSum = GOtfSum + GOtf{k};
    end
    
    NOGOtfSum = zeros(length(freqs), 6*Fs);
    for k = 1:NOGOct
        NOGOtfSum = NOGOtfSum + NOGOtf{k};
    end
    
    BASEtfSum = zeros(length(freqs),BASElength*Fs-1);
    for k = 1:TrialNum
        BASEtfSum = BASEtfSum + BASEtf{k};
    end
    
    
    %BASEMean = mean(BASEtfSum / TrialNum, 2);
    %BASEStd = std(BASEtfSum / TrialNum, 0, 2);
    
%     GOtfMean = (GOtfSum / GOct - BASEMean) ./ BASEStd;
%     NOGOtfMean = (NOGOtfSum / NOGOct - BASEMean) ./ BASEStd ; 
    
    GOtfMean = GOtfSum / GOct; %./ BASEMean;
    NOGOtfMean = NOGOtfSum / NOGOct; %./ BASEMean;
    
%%  plot. 
    figure(chn);clf;
    subplot(2,1,1);
    imagesc([0, TrialtimeMean/Fs+3],[0,195],GOtfMean);
    
    ax = gca;
    colormap jet;
    ax.YDir = 'normal';   %set y-axis's direction.
    
    
    Line = 3 * ones(1,length(freqs));
    hold on;
    plot( Line,freqs,'color','k','LineWidth',1.5);

    title(['T-F spectrum of channel-',num2str(i),' go']);
    xlabel('Time/s');ylabel('FrequEncy/Hz');
    
    
    
    subplot(2,1,2);
    imagesc([0, 6],[0,195],NOGOtfMean);
    
    ax = gca;
    colormap jet;
    ax.YDir = 'normal';   %set y-axis's direction.
    
    
    Line = 3 * ones(1,length(freqs));
    hold on;
    plot( Line,freqs,'color','k','LineWidth',1.5);
    
    
    title(['T-F spectrum of channel-',num2str(chn),' nogo']);
    xlabel('Time/s');ylabel('FrequEncy/Hz');
    
    
    savefig(['2_Class_Chn_',num2str(chn),'_v4.fig'])
    
end
end
            
          