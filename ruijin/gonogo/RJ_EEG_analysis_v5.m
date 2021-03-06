function RJ_EEG_analysis_v5(subj, sessionNum)
%%
pn=subj;

    fprintf('\n subj %d: RJ_EEG_analysis_v5', pn);

base_dir=strcat('/Volumes/Samsung_T5/data/ruijin/gonogo/preprocessing/P',num2str(pn));
Folder=strcat(base_dir,'/analysis2');
%Folder=strcat('D:/lsj/RJ_preprocessing_data/P',num2str(pn),'/analysis_210627');
if ~exist(Folder,'dir')
    mkdir(Folder);
end
%cd(Folder);

strname = strcat(base_dir,'/preprocessing/preprocessingv2.mat');
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

% 找到最大的reactTime, segmentLength  = 3s+reactTime+0.5s.
rtimeMax = 0;
rtimeSum = [];
rtimeMean_ = mean([rtime(:,1);rtime(:,2)]);
for i = 1:size(rtime, 1)
    if rtime(i, 1) < 1.5*rtimeMean_ && rtime(i, 1) ~= 3 
        if rtime(i, 1) > rtimeMax
            rtimeMax = rtime(i, 1);
        end
        rtimeSum = [rtimeSum, rtime(i, 1)];
    end
    
    if rtime(i, 2) < 1.5*rtimeMean_ && rtime(i, 2) ~= 3
        if rtime(i, 2) > rtimeMax
            rtimeMax = rtime(i, 2);
        end
        rtimeSum = [rtimeSum, rtime(i, 2)];
    end
end
rtimeMean = mean(rtimeSum);
GosegLength = round((rtimeMax+3)*2)/2*Fs + 0.5*Fs;
NoGosegLength = 6*Fs;

% 找到最大的reactTime, segmentLength  = 3s+reactTime+0.5s.
% Trialtime = [];
% for i = 1:TrialNum
%     if triggerInf(triStartTrigger(i)+3, 2) == 3
%         Trialtime = [Trialtime, triggerInf(triStartTrigger(i)+3, 1)-triggerInf(triStartTrigger(i)+2, 1)];
%     end
%     if triggerInf(triStartTrigger(i)+5, 2) == 5
%         Trialtime = [Trialtime, triggerInf(triStartTrigger(i)+5, 1)-triggerInf(triStartTrigger(i)+4, 1)];
%     end
% end
% TrialtimeMean = ceil(mean(Trialtime)/(Fs/10))*(Fs/10) - 3*Fs;
TrialtimeMean = 3*Fs;                                                                                            %%%%%%%  调整 %%%%%%%
%%  trial平均.
BASElength = 1;                                                                                                %%%%%%%  调整 %%%%%%%
for chn = 1:channelNum
    GoGoct = 0;  GoNoGoct = 0;  NoGoGoct = 0; NoGoNoGoct = 0;Basect = 0;
    for i = 1:TrialNum
        
        TrialData = data(triggerInf(triStartTrigger(i), 1)-BASElength*Fs+1 - 511:triggerInf(triStartTrigger(i)+5, 1) + 513, chn)';
        [tf,freqs,~,~] = timefreq(TrialData,Fs,'freqs',[0.5,195],'tlimits',[0,length(TrialData)],'winsize',1024,'ntimesout', length(TrialData));
        tf = abs(tf);
        BASEtf{i} = tf(:, 1:BASElength*Fs-1);                                                                  %%%%%%%  调整 %%%%%%%
        
        TampTriStartTrigger  =  triggerInf(triStartTrigger(i):triStartTrigger(i)+5, 1) - triggerInf(triStartTrigger(i), 1) + BASElength*Fs;      
        if triggerInf(triStartTrigger(i)+3, 2) == 3 && triggerInf(triStartTrigger(i)+5, 2) == 5
            Interp1 = [];
            for j = 1:length(freqs)
                x = TampTriStartTrigger(3) + 3*Fs:TampTriStartTrigger(5)-1;% first execution reaction duration + 0.3s task interval
                y = tf(j, x);
                xx = linspace(TampTriStartTrigger(3)+ 3*Fs, TampTriStartTrigger(5)-1, TrialtimeMean);
                Interp1(j,:) = interp1(x,y,xx,'linear');
            end
            Interp2 = [];
            for j = 1:length(freqs)
                x = TampTriStartTrigger(5)+ 3*Fs:TampTriStartTrigger(6);% second execution reaction duration
                y = tf(j, x);
                xx = linspace(TampTriStartTrigger(5)+ 3*Fs, TampTriStartTrigger(6), TrialtimeMean);
                Interp2(j,:) = interp1(x,y,xx,'linear');
            end
            GoGoct = GoGoct + 1;
            % [3s task cue + 3s task cue, 3s execution cue 1, execution(Interp1), 3s execution cue 2, execution(Interp2)]
            GoGotf{GoGoct} = [tf(:, 1 :BASElength*Fs-1 + 6*Fs) tf(:, TampTriStartTrigger(3):TampTriStartTrigger(3)+3*Fs-1) Interp1 tf(:, TampTriStartTrigger(5):TampTriStartTrigger(5)+3*Fs-1) Interp2];
            
        elseif triggerInf(triStartTrigger(i)+3, 2) == 3 && triggerInf(triStartTrigger(i)+5, 2) == 6
            Interp1 = [];
            for j = 1:length(freqs)
                x = TampTriStartTrigger(3) + 3*Fs:TampTriStartTrigger(5)-1;
                y = tf(j, x);
                xx = linspace(TampTriStartTrigger(3)+ 3*Fs, TampTriStartTrigger(5)-1, TrialtimeMean);
                Interp1(j,:) = interp1(x,y,xx,'linear');
            end
            GoNoGoct = GoNoGoct + 1; 
            %[3s task cue + 3s task cue, 3s execution cue, execution1(Interp1), no_go(3s execution cue + 3s wait)]
            GoNoGotf{GoNoGoct} = [tf(:, 1 :BASElength*Fs-1 + 6*Fs) tf(:, TampTriStartTrigger(3):TampTriStartTrigger(3)+3*Fs-1) Interp1 tf(:, TampTriStartTrigger(5):TampTriStartTrigger(5)+6*Fs-1)];
%             Basect =  Basect + 1;
%             BASEtf{Basect} = tf(:, TampTriStartTrigger(5) + 4.5*Fs:TampTriStartTrigger(5)+6*Fs-1);
        elseif triggerInf(triStartTrigger(i)+3, 2) == 4 && triggerInf(triStartTrigger(i)+5, 2) == 5
            Interp2 = [];
            for j = 1:length(freqs)
                x = TampTriStartTrigger(5)+ 3*Fs:TampTriStartTrigger(6);
                y = tf(j, x);
                xx = linspace(TampTriStartTrigger(5)+ 3*Fs, TampTriStartTrigger(6), TrialtimeMean);
                Interp2(j,:) = interp1(x,y,xx,'linear');
            end
            
            NoGoGoct = NoGoGoct + 1;
            %[3s task cue + 3s task cue, no_go(3s execution cue + 3s wait), 3s execution cue 2, execution2(Interp2)]
            NoGoGotf{NoGoGoct} = [tf(:, 1 :BASElength*Fs-1 + 6*Fs) tf(:, TampTriStartTrigger(3):TampTriStartTrigger(3)+6*Fs-1) tf(:, TampTriStartTrigger(5):TampTriStartTrigger(5)+3*Fs-1) Interp2];
            
%             Basect =  Basect + 1;
%             BASEtf{Basect} = tf(:, TampTriStartTrigger(3) + 4.5*Fs:TampTriStartTrigger(3)+6*Fs-1);
            
        elseif triggerInf(triStartTrigger(i)+3, 2) == 4 && triggerInf(triStartTrigger(i)+5, 2) == 6
            NoGoNoGoct = NoGoNoGoct + 1;
            %[3s task cue + 3s task cue, no_go(3s execution cue + 3s wait), no_go(3s execution cue + 3s wait)]
            NoGoNoGotf{NoGoNoGoct} = [tf(:, 1 :BASElength*Fs-1 + 6*Fs) tf(:, TampTriStartTrigger(3):TampTriStartTrigger(3)+6*Fs-1) tf(:, TampTriStartTrigger(5):TampTriStartTrigger(5)+6*Fs-1)];
%             
%             Basect =  Basect + 1;
%             BASEtf{Basect} = tf(:, TampTriStartTrigger(3) + 4.5*Fs:TampTriStartTrigger(3)+6*Fs-1);
%             Basect =  Basect + 1;
%             BASEtf{Basect} = tf(:, TampTriStartTrigger(5) + 4.5*Fs:TampTriStartTrigger(5)+6*Fs-1);
        end
        
    end
    
    
    GoGotfSum = zeros(length(freqs), BASElength*Fs-1 + 6*Fs + TrialtimeMean+3*Fs + TrialtimeMean+3*Fs );
    for k = 1:GoGoct; GoGotfSum = GoGotfSum + GoGotf{k}; end
    GoNoGotfSum = zeros(length(freqs), BASElength*Fs-1 + 6*Fs + TrialtimeMean+3*Fs + 6*Fs );
    for k = 1:GoNoGoct; GoNoGotfSum = GoNoGotfSum + GoNoGotf{k}; end
    NoGoGotfSum = zeros(length(freqs), BASElength*Fs-1 + 6*Fs + 6*Fs + TrialtimeMean+3*Fs );
    for k = 1:NoGoGoct; NoGoGotfSum = NoGoGotfSum + NoGoGotf{k}; end
    NoGoNoGotfSum = zeros(length(freqs), BASElength*Fs-1 + 6*Fs + 6*Fs + 6*Fs );
    for k = 1:NoGoNoGoct; NoGoNoGotfSum = NoGoNoGotfSum + NoGoNoGotf{k}; end
 
    
    BASEtfSum = zeros(length(freqs),BASElength*Fs-1);
    for k = 1:TrialNum
        BASEtfSum = BASEtfSum + BASEtf{k};
    end
    
    
    BASEMean = mean(BASEtfSum / TrialNum, 2);
    BASEStd = std(BASEtfSum / TrialNum, 0, 2);

%     BASEtfSum = zeros(length(freqs),BASElength*Fs);
%     for k = 1:Basect
%         BASEtfSum = BASEtfSum + BASEtf{k};
%     end
%     
%     
%     BASEMean = mean(BASEtfSum / Basect, 2);
%     BASEStd = std(BASEtfSum / Basect, 0, 2);
    
%     GoGotfMean = (GoGotfSum / GoGoct - BASEMean) ./ BASEStd;
%     GoNoGotfMean = (GoNoGotfSum / GoNoGoct - BASEMean) ./ BASEStd ; 
%     NoGoGotfMean = (NoGoGotfSum / NoGoGoct - BASEMean) ./ BASEStd;
%     NoGoNoGotfMean = (NoGoNoGotfSum / NoGoNoGoct - BASEMean) ./ BASEStd ;
    
    
    GoGotfMean = GoGotfSum / GoGoct ./ BASEMean; % try median, try ERP
    GoNoGotfMean = GoNoGotfSum / GoNoGoct ./ BASEMean;
    NoGoGotfMean = NoGoGotfSum / NoGoGoct ./ BASEMean;
    NoGoNoGotfMean = NoGoNoGotfSum / NoGoNoGoct ./ BASEMean;
    
 %%  plot. 
    figure(chn);clf;
    subplot(4,1,1);                                                            %%% GoGo %%%
    imagesc([0, size(GoGotfMean,2)/Fs],[0,195],GoGotfMean);
    
    ax = gca;
    colormap jet;
    ax.YDir = 'normal';   %set y-axis's direction.  
    Line = 1 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 4 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 7 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 10 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = (10 + TrialtimeMean/Fs) * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = (13 + TrialtimeMean/Fs) * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);   
    title(['T-F spectrum of channel-',num2str(i),' GoGo']);
    xlabel('Time/s');ylabel('FrequEncy/Hz');
    
    subplot(4,1,2);                                                            %%% GoNoGo %%%
    imagesc([0, size(GoNoGotfMean,2)/Fs],[0,195],GoNoGotfMean);   
    ax = gca;
    colormap jet;
    ax.YDir = 'normal';   %set y-axis's direction. 
    Line = 1 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 4 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 7 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 10 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = (10 + TrialtimeMean/Fs) * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = (13 + TrialtimeMean/Fs) * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    
    title(['T-F spectrum of channel-',num2str(chn),' GoNoGo']);
    xlabel('Time/s');ylabel('FrequEncy/Hz');
    
    subplot(4,1,3);                                                            %%% NoGoGo %%%
    imagesc([0, size(NoGoGotfMean,2)/Fs],[0,195],NoGoGotfMean);   
    ax = gca;
    colormap jet;
    ax.YDir = 'normal';   %set y-axis's direction. 
    Line = 1 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 4 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 7 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 10 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 13 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 16 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    
    title(['T-F spectrum of channel-',num2str(chn),' NoGoGo']);
    xlabel('Time/s');ylabel('FrequEncy/Hz');
    
    subplot(4,1,4);                                                            %%% NoGoNoGo %%%
    imagesc([0, size(NoGoNoGotfMean,2)/Fs],[0,195],NoGoNoGotfMean);   
    ax = gca;
    colormap jet;
    ax.YDir = 'normal';   %set y-axis's direction. 
    Line = 1 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 4 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 7 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 10 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 13 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    Line = 16 * ones(1,length(freqs)); hold on; plot( Line,freqs,'color','k','LineWidth',1.5);
    
    title(['T-F decomposition of channel-',num2str(i),' NoGoNoGo']);
    xlabel('Time/s');ylabel('FrequEncy/Hz');
       
    set(gcf,'unit','centimeters','position',[10 5 25 20]);
%    savefig(['chn_',num2str(chn),'_MeanTrial_anls_P',num2str(pn),'_v5.fig']);
   print(gcf,['chn_',num2str(chn),'_MeanTrial_anls_P',num2str(pn),'_v5'],'-dpdf','-bestfit');
    
end
end
            
          