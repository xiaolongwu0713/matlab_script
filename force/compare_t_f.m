%% compare different t-f analysis for signal trial of certain channel
% 
t=0:1/1000:15;
data = chirp(t,0,15,250); % chirp show similar result with waveletana and eeglab

epoch=load_data(1,'move1');
data=epoch(110,:,11); % shows very different plot with real seeg data

% method 1: wavelet analysis 
waveletana(data,1000,2,200,100,1);


% method 2 :eeglab
eeglab
EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',data,'srate',fs,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','chirp','gui','off');
eeglab redraw
figure; pop_newtimef(ALLEEG(1),1,1,[0 14999],[3 0.5],'trialbase','full', 'baseline',[500],'freqs',[1 200],'erspmax',[12],'plotitc','off','freqscale','log','plotphase','off','padratio',1);

% method 3: timefreq in EEGLAB
load('/Users/long/Documents/BCI/matlab_scripts/force/data/move1Power.mat');
power=power(activeChannels,:,activeTrials);
avgPower=mean(power,3);
data=avgPower(19,:); % channel 110
[tf,freqs,times,itcvals]=timefreq(data,1000,'freqs',[0,200],'tlimits',[0,15000],'winsize',1024);
baseline=abs(tf(:,1:22));
basevalue=mean(baseline, 2);   % column vector
tf=abs(tf);
for b=1:length(times);tf(:,b)=tf(:,b)-basevalue;end
for a=1:length(freqs)
    s=std(tf(a,1:22));
    tf(a,:)=tf(a,:)./s;
end 
figure
imagesc([0,15000/1000],[0,200],tf);
seg_duration=15000;
Fs=1000;
ax = gca;
ax.XTick = 0:1:15000/1000; % set x-axis's tick.
ax.YDir = 'normal';   %set y-axis's direction.
hold on;
plot([2,2],[0,200],'--w','LineWidth',2.5);
title(['T-F spectrum of channel-',num2str(110)]);
xlabel('Time/s');ylabel('FrequEncy/Hz');

load('/Users/long/Documents/BCI/matlab_scripts/force/colormap','mycmap')
colormap(ax,mycmap)
colorbar;
caxis([-1.5,4]);
    
%% compare different t-f analysis for averaged trial of certain channel 
% conclusion: method 2 ~= method 3, but method 1 very different.
% method 1: using waveleana.m: homemade wavelet decomposition
epoch=load_data(999,'move1');
for chn=activeChannels
    %chn=20;
    data2d=squeeze(epoch(chn,:,:));
    trialNum=size(epoch,3);
    anaval=zeros(trialNum,100,15000);
    for trial=[1:trialNum]
        anaval(trial,:,:)=waveletanalinear(squeeze(data2d(:,trial))',1000,0.5,200,150,0); %anaval(trial,freq,time)
    end

    %average trials
    anamedian=mean(anaval,1);
    figure(chn);clf;
    segDuration=15000; fs=1000;
    imagesc([0,segDuration/fs],[0.5,200],squeeze(anamedian));

    ax = gca;
    ax.XTick = 0:1:segDuration/fs; % set x-axis's tick.
    ax.YDir = 'normal';   %set y-axis's direction.
    hold on;
    %plot([segDuration/(2*Fs),segDuration/(2*Fs)],[0.5,245],'--w','LineWidth',2.5);
    plot([2,2],[0.5,200],'--w','LineWidth',2.5);
    plot([5,5],[0.5,200],'--w','LineWidth',2.5);
    plot([7.5,7.5],[0.5,200],'--w','LineWidth',2.5);
    title(['T-F spectrum of channel-',num2str(chn)]);
    xlabel('Time/s');ylabel('FrequEncy/Hz');

    load('/Users/long/BCI/matlab_scripts/LSJ/MyColormaps.mat','mycmap')
    colormap(ax,mycmap)
    colorbar;
    caxis([-1.5,4]);
end
%anamedian=median(anaval,1);
%figure;surface(squeeze(anamedian));shading interp 
%anamean=mean(anaval,1);
%figure;surface(squeeze(anamean));shading interp 

%% 
% method 2
% using waveleteeglab.m: use eeglab timefreq function to compute tf, then
% ttest2 to compare fluctuation
channel=[8 9 10 18 19 20 21 22 23 24 62 63 69 70 105 107 108 109 110];
data=squeeze(epoch(channel(8),:,[1:20,31:40]));
waveleteeglab(data,3);

% method 3: using eeglab 
channel=[8 9 10 18 19 20 21 22 23 24 62 63 69 70 105 107 108 109 110];
data=squeeze(epoch(channel(19),:,[1:20,31:40]));
EEG.data=data;
eeg = pop_importdata('dataformat','matlab','nbchan',0,'data',data','srate',fs,'pnts',0,'xmin',0);
figure; pop_newtimef(eeg,1,1,[0 14999],[3 0.5],'baseline',[500],'freqs',[1 200],'erspmax',[12],'plotitc','off','freqscale','log','plotphase','off','padratio',1);


%% homemade cwt method on LSJ data. show similar plot as LSJ method on LSJ data, but not as good as his.
load('/Users/long/BCI/matlab_scripts/LSJ/P2/preprocessing2/preprocessingALL_2_Local.mat','Datacell')
data=Datacell{1};
Fs=1000;
sessionNum=2;
usefulChannel=[11 ,   24,    25,     6 ,   79 ,   80    ,12    ,81  ,  83,    84   , 85,    86 ,   87];
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
%data=session(:,1);
for chn=usefulChannel
    for ss=[1,2]
        data=session(:,ss);
        ss
        for trial=[1:50]
            trial
            x=data{trial}(:,chn);
            %[tf,freqs,times,itcvals]=timefreq(x,Fs,'freqs',[0.5,245],'tlimits',[1,segDuration],'winsize',1024);   
            tf=waveletanalinear(x',1000,0.5,200,150,0);
            %baseline=abs(tf(:,1:2000));
            %basevalue=mean(baseline, 2);   % column vector
            %tf=abs(tf);
            %for b=1:length(times);tf(:,b)=tf(:,b)-basevalue;end
            %tf=tf-basevalue;
            %for a=1:size(tf,1)
            %    s=std(tf(a,1:2000));
            %    tf(a,:)=tf(a,:)./s;
            %end

            if trial == 1
                tfsum{ss} = tf;
                
            else
                tfsum{ss} = tfsum{ss} + tf;
            end
        end
        tfsum{ss}=tfsum{ss}/50;
    end
    tfaveg=(tfsum{1}+tfsum{2})/2;
    figure(chn);clf;
    imagesc([0,segDuration/Fs],[0.5,245],tfaveg);

    ax = gca;
    ax.XTick = 0:1:segDuration/Fs; % set x-axis's tick.
    ax.YDir = 'normal';   %set y-axis's direction.
    hold on;
    plot([segDuration/(2*Fs),segDuration/(2*Fs)],[0.5,245],'--w','LineWidth',2.5);
    title(['T-F spectrum of channel-',num2str(chn)]);
    xlabel('Time/s');ylabel('FrequEncy/Hz');
    
    load('/Users/long/BCI/matlab_scripts/LSJ/MyColormaps.mat','mycmap')
    colormap(ax,mycmap)
    colorbar;
    caxis([-1.5,4]);

end

%% LSJ method on LSJ data
load('/Users/long/BCI/matlab_scripts/LSJ/P2/preprocessing2/preprocessingALL_2_Local.mat','Datacell')
data=Datacell{1};
Fs=1000;
sessionNum=2;
usefulChannel=[11 ,   24,    25,     6 ,   79 ,   80    ,12    ,81  ,  83,    84   , 85,    86 ,   87];
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
%data=session(:,1);
for chn=86
    for ss=[1,2]
        data=session(:,ss);
        ss
        for trial=[1:50]
            trial
            x=data{trial}(:,chn);
            [tf,freqs,times,itcvals]=timefreq(x,Fs,'freqs',[0.5,245],'tlimits',[1,segDuration],'winsize',1024);   
            %tf=waveletanalinear(x',1000,0.5,200,150,0);
            baseline=abs(tf(:,1:2000));
            basevalue=mean(baseline, 2);   % column vector
            tf=abs(tf);
            for b=1:length(times);tf(:,b)=tf(:,b)-basevalue;end
            for a=1:size(tf,1)
                s=std(tf(a,1:2000));
                tf(a,:)=tf(a,:)./s;
            end

            if trial == 1
                tfsum{ss} = tf;
                
            else
                tfsum{ss} = tfsum{ss} + tf;
            end
        end
        tfsum{ss}=tfsum{ss}/50;
    end
    tfaveg=(tfsum{1}+tfsum{2})/2;
    figure(chn);clf;
    imagesc([0,segDuration/Fs],[0.5,245],tfaveg);

    ax = gca;
    ax.XTick = 0:1:segDuration/Fs; % set x-axis's tick.
    ax.YDir = 'normal';   %set y-axis's direction.
    hold on;
    plot([segDuration/(2*Fs),segDuration/(2*Fs)],[0.5,245],'--w','LineWidth',2.5);
    title(['T-F spectrum of channel-',num2str(chn)]);
    xlabel('Time/s');ylabel('FrequEncy/Hz');
    
    load('/Users/long/BCI/matlab_scripts/LSJ/MyColormaps.mat','mycmap')
    colormap(ax,mycmap)
    colorbar;
    caxis([-1.5,4]);

end