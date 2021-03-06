function RJ_EEG_analysis_v6(subj, sessionNum)
%%
pn=subj;

    fprintf('\n subj %d: RJ_EEG_analysis_v6', pn);

base_dir=strcat('/Volumes/Samsung_T5/data/ruijin/gonogo/preprocessing/P',num2str(pn));
Folder=strcat(base_dir,'/analysis2');

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
TrialNum = size(triStartTrigger,1);


%找到最大的reactTime, segmentLength  = 3s+reactTime+0.5s.
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

for fb = 1:4
    switch fb
        case 1;band = [0.5, 4];
        case 2;band = [4, 8];
        case 3;band = [8, 13];
        case 4;band = [60, 145];
    end
    h=fdesign.bandpass('N,F3dB1,F3dB2', 6,band(1),band(2), Fs);
    Hd=design(h,'butter');
    [B, A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
    signal=filtfilt(B,A,data);
    envelope= abs(hilbert(single(signal)));
    power = envelope.^2;
    
    BASElength = 1;
    base  =zeros( BASElength*Fs, channelNum );
    for j = 1:TrialNum
        tampBase = power(triggerInf(triStartTrigger(i), 1)-BASElength*Fs:triggerInf(triStartTrigger(i), 1)-1, :);
        base = base + tampBase;
    end
    base = mean(base / TrialNum, 2);
    
    
    for i = 1:channelNum
        GorawData = [];
        NoGorawData = [];
        NoGotri_data = [];
        Gotri_data = [];
        reactTime = [];
        for j = 1:TrialNum
            if triggerInf(triStartTrigger(j)+3, 2) == 3
                
                P = power(triggerInf(triStartTrigger(j)+2, 1)+1:triggerInf(triStartTrigger(j)+2, 1)+GosegLength, i)' / base(i);%-mean(base))/std(base) ;
                filterdData  = sgolayfilt(double(P),3,1001);
                filterdData = mapminmax(filterdData, -6, 6);
                %             Zscoreddata = zscore(data);
                GorawData = cat(1, GorawData, P);
                Gotri_data = cat(1,Gotri_data, filterdData);
                reactTime = cat(1, reactTime, triggerInf(triStartTrigger(j)+3, 1)-triggerInf(triStartTrigger(j)+2, 1));
            elseif triggerInf(triStartTrigger(j)+3, 2) == 4
                P = power(triggerInf(triStartTrigger(j)+2, 1)+1:triggerInf(triStartTrigger(j)+2, 1)+GosegLength, i)' / base(i);%-mean(base))/std(base) ;
                filterdData  = sgolayfilt(double(P),3,1001);
                filterdData = mapminmax(filterdData, -6, 6);
                
                NoGorawData = cat(1, NoGorawData, P);
                NoGotri_data = cat(1,NoGotri_data, filterdData);
            end
            
            if triggerInf(triStartTrigger(j)+5, 2) == 5
                P = power(triggerInf(triStartTrigger(j)+4, 1)+1:triggerInf(triStartTrigger(j)+4, 1)+GosegLength, i)' / base(i);
                filterdData  = sgolayfilt(double(P),3,1001);
                filterdData = mapminmax(filterdData, -6, 6);
                
                GorawData = cat(1, GorawData, P);
                Gotri_data = cat(1,Gotri_data, filterdData);
                reactTime = cat(1, reactTime, triggerInf(triStartTrigger(j)+5, 1)-triggerInf(triStartTrigger(j)+4, 1));
            elseif triggerInf(triStartTrigger(j)+5, 2) == 6
                
                P = power(triggerInf(triStartTrigger(j)+4, 1)+1:triggerInf(triStartTrigger(j)+4, 1)+GosegLength, i)' / base(i);
                filterdData  = sgolayfilt(double(P),3,1001);
                filterdData = mapminmax(filterdData, -6, 6);
                
                NoGorawData = cat(1, NoGorawData, P);
                NoGotri_data = cat(1,NoGotri_data, filterdData);
            end
        end
        % % remove bad trial.
        %     bad_trial{i,1} = RJ_EEG_removeBadTrial(tri_data);
        %     tri_data(bad_trial{i,1},:) = [];
        %     reactTime(bad_trial{i,1}) = [];
        [sortedrTime, I] = sort(reactTime);
        Gotri_data = Gotri_data(I', :);
        
        figure(i); 
        subplot(3,4,fb);
        
        imagesc(Gotri_data);
        
        lbl_tline = 3 * Fs * ones(1,length(reactTime));
        hold on;
        y = 1:length(reactTime);
        plot( lbl_tline,y,'--k','LineWidth',1.5);
        
        lbl_tline = (3+rtimeMean) * Fs * ones(1,length(reactTime));
        hold on;
        plot( lbl_tline,y,'--k','LineWidth',1.5);
        
        hold on;
        plot(sortedrTime,y,'*k');
        title([ num2str(band(1)),'-',num2str(band(2)),'Hz,chn-',num2str(i),',Go']);
        xlabel('Time/ms');
        
        ax = gca;
        ax.YDir = 'normal';   %set y-axis's direction.
        ylabel('trial');
        
        yyaxis right
        hold on;
        ax = gca;
        tampMean_Go = sgolayfilt(double(mean(GorawData,1)),3,1001);
        %     NoGotampMean = sgolayfilt(double(mean(NoGorawData,1)),3,1001);
        plot(tampMean_Go,'-k','LineWidth',2);
        %     hold on;
        %     plot(NoGotampMean,'-r','LineWidth',2);
        
        %     tampMedian = sgolayfilt(median(Gotri_data,1),3,1001);
        %     hold on;
        %     plot(tampMedian,'-r','LineWidth',2);
        
        %     ax.YLim = [min([tampMean,NoGotampMean]), min([tampMean,NoGotampMean])+3*(max([tampMean,NoGotampMean])-min([tampMean,NoGotampMean]))];
        ax.YLim = [min(tampMean_Go), min(tampMean_Go)+3*(max(tampMean_Go)-min(tampMean_Go))]; 
        
        subplot(3,4,4+fb);
        imagesc(NoGotri_data);
        
        lbl_tline = 3 * Fs * ones(1,length(reactTime));
        hold on;
        y = 1:length(reactTime);
        plot( lbl_tline,y,'--k','LineWidth',1.5);
        
        lbl_tline = (3+rtimeMean) * Fs * ones(1,length(reactTime));
        hold on;
        plot( lbl_tline,y,'--k','LineWidth',1.5);
        
 
        title([ num2str(band(1)),'-',num2str(band(2)),'Hz,chn-',num2str(i),',NoGo']);
        xlabel('Time/ms');
        
        ax = gca;
        ax.YDir = 'normal';   %set y-axis's direction.
        ylabel('trial');
        
        yyaxis right
        hold on;
        ax = gca;
        tampMean_NoGo = sgolayfilt(double(mean(NoGorawData,1)),3,1001);
        %     NoGotampMean = sgolayfilt(double(mean(NoGorawData,1)),3,1001);
        plot(tampMean_NoGo,'-k','LineWidth',2);
        %     hold on;
        %     plot(NoGotampMean,'-r','LineWidth',2);
        
        %     tampMedian = sgolayfilt(median(Gotri_data,1),3,1001);
        %     hold on;
        %     plot(tampMedian,'-r','LineWidth',2);
        
        %     ax.YLim = [min([tampMean,NoGotampMean]), min([tampMean,NoGotampMean])+3*(max([tampMean,NoGotampMean])-min([tampMean,NoGotampMean]))];
        ax.YLim = [min(tampMean_NoGo), min(tampMean_NoGo)+3*(max(tampMean_NoGo)-min(tampMean_NoGo))]; 
        
        
        subplot(3,4, 8+fb);
        plot(tampMean_Go, 'k', 'Linewidth',2.5);
        hold on;
        plot(tampMean_NoGo, 'r', 'Linewidth',2.5);
        
        Maxx = 1.3*max(max(tampMean_Go), max(tampMean_NoGo));
        Minn = 0.7*min(min(tampMean_Go), min(tampMean_NoGo));
        lbl_tline = 3 * Fs * [1 1];
        hold on;
        y = [Minn Maxx];
        plot( lbl_tline,y,'--k','LineWidth',1.5);
        
        lbl_tline = (3+rtimeMean) * Fs * [1 1];
        hold on;
        plot( lbl_tline,y,'--k','LineWidth',1.5);

        if fb == 4
            set(gcf,'unit','centimeters','position',[10 5 25 15]);
%             savefig(['chn_',num2str(i),'_sglTrial_anls.fig']);
%             saveas(gcf,['chn_',num2str(i),'_sglTrial_anls.pdf']);
            print(gcf,['chn_',num2str(i),'_sglTrial_anls_P',num2str(pn),'_v6'],'-dpdf','-bestfit');
        end
    end
end
