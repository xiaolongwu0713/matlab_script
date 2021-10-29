% load preprocessing3/preprocessingALL_3.mat first. 


fprintf('\n Time-frequency analysis');

Fs=1000;
pic=0;
for i=1:nsession
    
    selected_chn = selection_infor.reactive_channels_intersection{i};
    
for chn=selected_chn %selected channels
    x=avg_power.session{1}(:,chn);
    
    [tf,freqs,times,itcvals]=timefreq(x,Fs,'freqs',[0,200],'tlimits',[0,seg_duration],'winsize',1024);
 
    baseline=abs(tf(:,1:length(times)/2.5));
    basevalue=mean(baseline, 2);   % column vector
    tf=abs(tf);
 
    for b=1:length(times);tf(:,b)=tf(:,b)-basevalue;end
    for a=1:length(freqs)
        s=std(tf(a,1:length(times)/2.5));
        tf(a,:)=tf(a,:)./s;
    end 
    
    pic = pic + 1;
    figure(pic);clf;
    imagesc([0,seg_duration/Fs],[0,200],tf);
    
    ax = gca;
    ax.XTick = 0:1:seg_duration/Fs; % set x-axis's tick.
    ax.YDir = 'normal';   %set y-axis's direction.
    hold on;
    plot([seg_duration/(2*Fs),seg_duration/(2*Fs)],[0,200],'--w','LineWidth',2.5);
    title(['T-F spectrum of channel-',num2str(chn)]);
    xlabel('Time/s');ylabel('FrequEncy/Hz');

    load('/Users/liushengjie/Documents/MATLAB/MyColormaps.mat','mycmap')
    colormap(ax,mycmap)
    colorbar;
    caxis([-1.5,4]);
end 
end

%%
% 对不同的 refMeths 做时频分析，看看是否有区别. @210124.
clear all;clc;
    fprintf('\n Time-frequency analysis');

sessionNum = 2;    
Inf = [2, 1000; 3, 1000; 4, 1000; 5, 1000; 7, 1000; 8, 1000; 9, 1000; 10, 2000; % 11, 500; 12, 500;
    13, 2000;  16, 2000; 17, 2000; 18, 2000; 19, 2000; 20, 1000; 21, 1000; 22, 2000; 23, 2000; % 14, 2000;
     29, 2000; 30, 2000; 31, 2000; 32, 2000; 34, 2000; 35, 1000; % 28, 2000; 33,     24, 2000; 25, 2000; 26, 2000;
    36, 2000; 37, 2000;
    ];
godSubj = 18%[1,2,3,8,9,18,22];

for subj = godSubj
    pn = Inf(subj, 1);
    Fs = Inf(subj, 2);
    
    for Inx = [1,2]
        switch Inx
            case 1
                tampStr =  '_Local';
            case 2
                tampStr =  '_mean';
            case 3
                tampStr =  '_median';
            case 4
                tampStr =  '_Ele_Spec';
            case 5
                tampStr =  '_Chn_Spec';
            case 6
                tampStr =  '_CW';
            case 7
                tampStr =  '_Bipolar';
        end
        
        strname = strcat('D:/lsj/preprocessing_data/P',num2str(pn),'/preprocessing2/preprocessingALL_2',tampStr,'.mat');
        load(strname, 'Datacell');
        strname = strcat('D:/lsj/preprocessing_data/P',num2str(pn),'/preprocessing3/preprocessingALL_3_0.5_v2',tampStr,'.mat');
        load(strname, 'usefulChannel');
        Dall{Inx} = Datacell;
        UFCall{Inx} = usefulChannel;
    end
    chnTamp = intersect(UFCall{1},UFCall{2}) ;
    usefulChannel = [setdiff(UFCall{1}, chnTamp), setdiff(UFCall{2}, chnTamp), chnTamp ] ;
    for Inx = [1,2]
        Datacell = Dall{Inx};  
        for i=1:sessionNum
            % 	cut into task segment
            
            EMG_trigger = Datacell{i}(:,end);
            trigger = find(EMG_trigger~=0);
            trialNum = length(trigger);
            segDuration = 8*Fs;
            for trial=1:trialNum
                segData=Datacell{i}(trigger(trial)+0.25*Fs- segDuration/2:trigger(trial)+0.25*Fs+ segDuration/2-1, 1:end-1);
                
                ftrLabel(1:segDuration, 1)=EMG_trigger(trigger(trial));  % size(~, 1) row, (~, 2) column
                session{trial,i}=[segData,ftrLabel];
            end
        end
        ct = 0 ;
        for chn = usefulChannel %selected channels
            ct = ct + 1;
            for i=1:sessionNum
                for trial=1:trialNum
                    label = session{trial, i}(1, end);
                    x = session{trial,i}(:,chn);
                    [tf,freqs,times,itcvals]=timefreq(x,Fs,'freqs',[0.5,245],'tlimits',[1,segDuration],'winsize',1024);
                    
                    baseline=abs(tf(:,1:length(times)/2.5));
                    basevalue=mean(baseline, 2);   % column vector
                    tf=abs(tf);
                    
                    for b=1:length(times);tf(:,b)=tf(:,b)-basevalue;end
                    for a=1:length(freqs)
                        s=std(tf(a,1:length(times)/2.5));
                        tf(a,:)=tf(a,:)./s;
                    end
                    
                    if trial == 1
                        tfSum5Sess = tf;
                    else
                        tfSum5Sess = tfSum5Sess + tf;
                    end
                    
                end
                tfMean5Sess{chn, i} = tfSum5Sess / trialNum ;
            end
            tfMean5chn{Inx, ct}  = (tfMean5Sess{chn, 1} + tfMean5Sess{chn, 2}) / 2 ;
        end
    end
    
    for ii = 1: ct
        figure(ii);clf;
        subplot 211;
        imagesc([0,segDuration/Fs],[0.5,245],tfMean5chn{1, ii});
        
        ax = gca;
        ax.XTick = 0:1:segDuration/Fs; % set x-axis's tick.
        ax.YDir = 'normal';   %set y-axis's direction.
        hold on;
        plot([segDuration/(2*Fs),segDuration/(2*Fs)],[0.5,245],'--w','LineWidth',2.5);
        title(['T-F spectrum of channel-',num2str(usefulChannel(ii))]);
        xlabel('Time/s');ylabel('FrequEncy/Hz');
        
        load('/Users/liushengjie/Documents/MATLAB/MyColormaps.mat','mycmap')
        colormap(ax,mycmap)
        colorbar;
        caxis([-1.5,4]);
        
        subplot 212;
        imagesc([0,segDuration/Fs],[0.5,245],tfMean5chn{2, ii});
        
        ax = gca;
        ax.XTick = 0:1:segDuration/Fs; % set x-axis's tick.
        ax.YDir = 'normal';   %set y-axis's direction.
        hold on;
        plot([segDuration/(2*Fs),segDuration/(2*Fs)],[0.5,245],'--w','LineWidth',2.5);
        title(['T-F spectrum of channel-',num2str(usefulChannel(ii))]);
        xlabel('Time/s');ylabel('FrequEncy/Hz');
        
        load('/Users/liushengjie/Documents/MATLAB/MyColormaps.mat','mycmap')
        colormap(ax,mycmap)
        colorbar;
        caxis([-1.5,4]);
    end
    
end

%%
% 对不同的 refMeths 做时频分析，看看是否有区别. @210124, lsj.
clear all;clc;
    fprintf('\n Time-frequency analysis');

sessionNum = 2;    
Inf = [2, 1000; 3, 1000; 4, 1000; 5, 1000; 7, 1000; 8, 1000; 9, 1000; 10, 2000; % 11, 500; 12, 500;
    13, 2000;  16, 2000; 17, 2000; 18, 2000; 19, 2000; 20, 1000; 21, 1000; 22, 2000; 23, 2000; % 14, 2000;
     29, 2000; 30, 2000; 31, 2000; 32, 2000; 34, 2000; 35, 1000; % 28, 2000; 33,     24, 2000; 25, 2000; 26, 2000;
    36, 2000; 37, 2000;
    ];
godSubj = 9%[1,2,3,8,9,18,22];

for subj = godSubj
    pn = Inf(subj, 1);
    Fs = Inf(subj, 2);
    
    for Inx = [1,2]
        switch Inx
            case 1
                tampStr =  '_Local';
            case 2
                tampStr =  '_mean';
            case 3
                tampStr =  '_median';
            case 4
                tampStr =  '_Ele_Spec';
            case 5
                tampStr =  '_Chn_Spec';
            case 6
                tampStr =  '_CW';
            case 7
                tampStr =  '_Bipolar';
        end
        
        strname = strcat('D:/lsj/preprocessing_data/P',num2str(pn),'/preprocessing2/preprocessingALL_2',tampStr,'.mat');
        load(strname, 'Datacell');
        strname = strcat('D:/lsj/preprocessing_data/P',num2str(pn),'/preprocessing3/preprocessingALL_3_0.5_v2',tampStr,'.mat');
        load(strname, 'usefulChannel');
        Dall{Inx} = Datacell;
        UFCall{Inx} = usefulChannel;
    end
    
    usefulChannel = unique([UFCall{1},UFCall{2}]);
    for Inx = [1,2]
        Datacell = Dall{Inx};  
        for i=1:sessionNum
            % 	cut into task segment
            
            EMG_trigger = Datacell{i}(:,end);
            trigger = find(EMG_trigger~=0);
            trialNum = length(trigger);
            segDuration = 8*Fs;
            for trial=1:trialNum
                segData=Datacell{i}(trigger(trial)+0.25*Fs- segDuration/2:trigger(trial)+0.25*Fs+ segDuration/2-1, 1:end-1);
                
                ftrLabel(1:segDuration, 1)=EMG_trigger(trigger(trial));  % size(~, 1) row, (~, 2) column
                session{trial,i}=[segData,ftrLabel];
            end
        end
        ct = 0;
        for chn = usefulChannel %selected channels
            ct_1 = 0 ; ct_2 = 0 ; ct_3 = 0 ;
            ct = ct + 1;
            for i=1:sessionNum
                for trial=1:trialNum
                    label = session{trial, i}(1, end);
                    x = session{trial,i}(:,chn);
                    [tf,freqs,times,itcvals]=timefreq(x,Fs,'freqs',[0.5,245],'tlimits',[1,segDuration],'winsize',1024);
                    
                    baseline=abs(tf(:,1:length(times)/2.5));
                    basevalue=mean(baseline, 2);   % column vector
                    tf=abs(tf);
                    
                    for b=1:length(times);tf(:,b)=tf(:,b)-basevalue;end
                    for a=1:length(freqs)
                        s=std(tf(a,1:length(times)/2.5));
                        tf(a,:)=tf(a,:)./s;
                    end
                    
                    switch label
                        case 1
                            ct_1 = ct_1 + 1;
                            if ct_1 == 1
                                tfSum5Sess_1 = tf;
                            else
                                tfSum5Sess_1 = tfSum5Sess_1 + tf;
                            end
                        case 2
                            ct_2 = ct_2 + 1;
                            if ct_2 == 1
                                tfSum5Sess_2 = tf;
                            else
                                tfSum5Sess_2 = tfSum5Sess_2 + tf;
                            end
                        case 3
                            ct_3 = ct_3 + 1;
                            if ct_3 == 1
                                tfSum5Sess_3 = tf;
                            else
                                tfSum5Sess_3 = tfSum5Sess_3 + tf;
                            end
                    end
                    
                end
               
            end
            
            tfMean5chn_1{Inx, ct}  = tfSum5Sess_1 / ct_1 ;
            tfMean5chn_2{Inx, ct}  = tfSum5Sess_2 / ct_2 ;
            tfMean5chn_3{Inx, ct}  = tfSum5Sess_3 / ct_3 ;
        end
    end
    
 
    for ii = 1: length(usefulChannel)
        figure(ii);clf;
        subplot 231;
        imagesc([0,segDuration/Fs],[0.5,245],tfMean5chn_1{1, ii});
        
        ax = gca;
        ax.XTick = 0:1:segDuration/Fs; % set x-axis's tick.
        ax.YDir = 'normal';   %set y-axis's direction.
        hold on;
        plot([segDuration/(2*Fs),segDuration/(2*Fs)],[0.5,245],'--w','LineWidth',2.5);
        title(['T-F spectrum of channel-',num2str(usefulChannel(ii))]);
        xlabel('Time/s');ylabel('FrequEncy/Hz');
        
        load('/Users/liushengjie/Documents/MATLAB/MyColormaps.mat','mycmap')
        colormap(ax,mycmap)
        colorbar;
        caxis([-1.5,4]);
        
        subplot 232;
        imagesc([0,segDuration/Fs],[0.5,245],tfMean5chn_2{1, ii});
      
        ax = gca;
        ax.XTick = 0:1:segDuration/Fs; % set x-axis's tick.
        ax.YDir = 'normal';   %set y-axis's direction.
        hold on;
        plot([segDuration/(2*Fs),segDuration/(2*Fs)],[0.5,245],'--w','LineWidth',2.5);
        title(['T-F spectrum of channel-',num2str(usefulChannel(ii))]);
        xlabel('Time/s');ylabel('FrequEncy/Hz');
        
        load('/Users/liushengjie/Documents/MATLAB/MyColormaps.mat','mycmap')
        colormap(ax,mycmap)
        colorbar;
        caxis([-1.5,4]);
        
        subplot 233;
        imagesc([0,segDuration/Fs],[0.5,245],tfMean5chn_3{1, ii});
        
        ax = gca;
        ax.XTick = 0:1:segDuration/Fs; % set x-axis's tick.
        ax.YDir = 'normal';   %set y-axis's direction.
        hold on;
        plot([segDuration/(2*Fs),segDuration/(2*Fs)],[0.5,245],'--w','LineWidth',2.5);
        title(['T-F spectrum of channel-',num2str(usefulChannel(ii))]);
        xlabel('Time/s');ylabel('FrequEncy/Hz');
        
        load('/Users/liushengjie/Documents/MATLAB/MyColormaps.mat','mycmap')
        colormap(ax,mycmap)
        colorbar;
        caxis([-1.5,4]);
        
        subplot 234;
        imagesc([0,segDuration/Fs],[0.5,245],tfMean5chn_1{2, ii});
        
        ax = gca;
        ax.XTick = 0:1:segDuration/Fs; % set x-axis's tick.
        ax.YDir = 'normal';   %set y-axis's direction.
        hold on;
        plot([segDuration/(2*Fs),segDuration/(2*Fs)],[0.5,245],'--w','LineWidth',2.5);
        title(['T-F spectrum of channel-',num2str(usefulChannel(ii))]);
        xlabel('Time/s');ylabel('FrequEncy/Hz');
        
        load('/Users/liushengjie/Documents/MATLAB/MyColormaps.mat','mycmap')
        colormap(ax,mycmap)
        colorbar;
        caxis([-1.5,4]);
        
        subplot 235;
        imagesc([0,segDuration/Fs],[0.5,245],tfMean5chn_2{2, ii});
        
        ax = gca;
        ax.XTick = 0:1:segDuration/Fs; % set x-axis's tick.
        ax.YDir = 'normal';   %set y-axis's direction.
        hold on;
        plot([segDuration/(2*Fs),segDuration/(2*Fs)],[0.5,245],'--w','LineWidth',2.5);
        title(['T-F spectrum of channel-',num2str(usefulChannel(ii))]);
        xlabel('Time/s');ylabel('FrequEncy/Hz');
        
        load('/Users/liushengjie/Documents/MATLAB/MyColormaps.mat','mycmap')
        colormap(ax,mycmap)
        colorbar;
        caxis([-1.5,4]);
        
        subplot 236;
        imagesc([0,segDuration/Fs],[0.5,245],tfMean5chn_3{2, ii});
        
        ax = gca;
        ax.XTick = 0:1:segDuration/Fs; % set x-axis's tick.
        ax.YDir = 'normal';   %set y-axis's direction.
        hold on;
        plot([segDuration/(2*Fs),segDuration/(2*Fs)],[0.5,245],'--w','LineWidth',2.5);
        title(['T-F spectrum of channel-',num2str(usefulChannel(ii))]);
        xlabel('Time/s');ylabel('FrequEncy/Hz');
        
        load('/Users/liushengjie/Documents/MATLAB/MyColormaps.mat','mycmap')
        colormap(ax,mycmap)
        colorbar;
        caxis([-1.5,4]);
        
    end
    
end





















    