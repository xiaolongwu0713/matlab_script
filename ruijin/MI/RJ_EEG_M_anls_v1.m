% function RJ_EEG_M_anls_v1
clear all;clc;

pn=2;

Folder=strcat('/Volumes/Samsung_T5/data/ruijin/MI/RJ_MI_preprocessing_data/P',num2str(pn),'/anls/');
if ~exist(Folder,'dir')
    mkdir(Folder);
end


strname = strcat('/Volumes/Samsung_T5/data/ruijin/MI/RJ_MI_preprocessing_data/P',num2str(pn),'/preprocessing/preprocessingAll_v2.mat');
load(strname);

channelNum = size(data, 2);

trigger = find(ftrLabel(:, 1) > 0 );
trialNum = length(trigger);
segDuration = 7.5*Fs;

session = cell(trialNum, 1);
for trial = 1:trialNum
    
    segData = data( trigger(trial, 1):trigger(trial, 1)+segDuration-1, :);
    label = ones( size(segData, 1), 1) * ftrLabel(trigger(trial, 1));
    session{trial, 1} = [segData, label];
end

fig=figure('visible','off');
for chn = 1:channelNum
   
    ct_MI = 0;ct_ME = 0;
    for trial = 1:trialNum
        label = session{trial, 1}(1, end);
        x = session{trial, 1}(:, chn);
        
        [tf,freqs,times,itcvals]=timefreq(x,Fs,'freqs',[0.5,245],'tlimits',[1,segDuration],'winsize',1024);
        tf=abs(tf);
        baseVal = mean(tf(:,1:53), 2);   % column vector  
                                         % 取前 2.5s 即 rest 部分.
        
                                         
        for b=1:length(times);tf(:,b)=tf(:,b)-baseVal;end
        for a=1:length(freqs)
            s=std(tf(a,1:floor(length(times)/3))); % timefreq 得到的 times 与实际时序对应已经混乱，但是 rest 部分是 2.5s, 占了整个 trial 的 1/3, 故 /3 即可.
            tf(a,:)=tf(a,:)./s;
        end
        
        if label < 3
            ct_ME = ct_ME + 1;
            if ct_ME == 1
                TF_ME = tf;
            else
                TF_ME = TF_ME + tf;
            end
        else
            ct_MI = ct_MI + 1;
             if ct_MI == 1
                TF_MI = tf;
            else
                TF_MI = TF_MI + tf;
            end
        end       
    end
    
    TF_ME = TF_ME/ct_ME;
    TF_MI = TF_MI/ct_MI;
    
    %figure(chn);
    
    subplot 211;
    imagesc(TF_ME);
    ax = gca;
    %     ax.XTick = 0:1:segDuration/Fs; % set x-axis's tick.
    ax.YDir = 'normal';   %set y-axis's direction.
    hold on;
    xx = ones(1, length(freqs)) * 5*Fs;
    plot(xx,freqs,'--w','LineWidth',2.5);
    title(['T-F spectrum of channel-',num2str(chn)]);
    xlabel('Time/s');ylabel('FrequEncy/Hz');
    
     colormap jet
    
    subplot 212;
    imagesc(TF_MI);
    ax = gca;
    %     ax.XTick = 0:1:segDuration/Fs; % set x-axis's tick.
    ax.YDir = 'normal';   %set y-axis's direction.
    hold on;
    xx = ones(1, length(freqs)) * 5*Fs;
    plot(xx,freqs,'--w','LineWidth',2.5);
    title(['T-F spectrum of channel-',num2str(chn)]);
    xlabel('Time/s');ylabel('FrequEncy/Hz');
    
    colormap jet
    save_file=strcat(Folder,num2str(chn),'_tf.pdf');
    saveas(fig,save_file);
    clf;
end
set(fig, 'Visible', 'on');
