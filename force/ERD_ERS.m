%% LSJ method on force data: compute the Z-score with Z-transform method
movement=4;
move=strcat('move',num2str(movement));
epoch=load_data(9999,move);
badtrials=badtrial{movement};
alltrials=[1:40];
goodtrials=setdiff(alltrials,badtrials);
epoch=epoch(:,:,goodtrials);
trialNum=size(epoch,3);
fs=1000;
segDuration=15*fs;
set(0,'DefaultFigureVisible','off');
minfreq=0.5;
maxfreq=300;
switch movement
    case 1
        start=2;
        holdstart=5;
        release=7.5;
        baselinestart=166;
        baselineend=200;
    case 2
        start=2;
        holdstart=11;
        release=13.5;
        baselinestart=194;
        baselineend=200;
    case 3
        start=2;
        holdstart=3;
        release=5.5;
        baselinestart=166;
        baselineend=200;
    case 4
        start=2;
        holdstart=5;
        release=7.5;
        baselinestart=166;
        baselineend=200;
end


for chn = [1:110] %activeChannels
    for trial=[1:trialNum]
        trialdata=epoch(chn,:,trial);
        [tf,freqs,times,itcvals]=timefreq(trialdata,fs,'freqs',[minfreq,maxfreq],'tlimits',[1,15000],'winsize',1024);
        %baseline=abs(tf(:,1:15)); 
        baseline=abs(tf(:,baselinestart:baselineend)); %move 1,8-10s baseline
        basevalue=mean(baseline, 2);   % column vector
        tf=abs(tf);
        for b=1:length(times)
            tf(:,b)=tf(:,b)-basevalue;
        end
        for a=1:length(freqs)
            s=std(tf(a,108:137)); %move1
            tf(a,:)=tf(a,:)./s;
        end
        
        if trial == 1
            sumtf = tf;
        else
            sumtf = sumtf + tf;
        end
    end
    avgtf=sumtf/trialNum; subplot(12,1,1:6);
    
    figure(chn);clf;subplot(12,1,1:6);
    imagesc([0,segDuration/fs],[minfreq,maxfreq],avgtf);

    ax = gca;
    ax.XTick = 0:1:segDuration/fs; % set x-axis's tick.
    ax.YDir = 'normal';   %set y-axis's direction.
    hold on;
    %plot([segDuration/(2*Fs),segDuration/(2*Fs)],[0.5,maxfreq],'--w','LineWidth',2.5);
    plot([start,start],[minfreq,maxfreq],'--w','LineWidth',2.5);
    plot([holdstart,holdstart],[minfreq,maxfreq],'--w','LineWidth',2.5);
    plot([release,release],[minfreq,maxfreq],'--w','LineWidth',2.5);
    title(['T-F spectrum of channel-',num2str(chn)]);
    xlabel('Time/s');ylabel('FrequEncy/Hz');

    load('/Users/long/BCI/matlab_scripts/LSJ/MyColormaps.mat','mycmap')
    colormap(ax,mycmap)
    %colorbar;
    caxis([-1.5,4]);
    % 60-300HZ
    low1=60;
    low2=300;
    freq1=find(abs(freqs-low1)==min(abs(freqs-low1)));
    freq2=find(abs(freqs-low2)==min(abs(freqs-low2)));
    HERS=mean(avgtf(freq1:freq2,:),1);
    subplot(12,1,7:9);
    plot(HERS,'r');
    % 8-30HZ
    low1=8;
    low2=30;
    freq1=find(abs(freqs-low1)==min(abs(freqs-low1)));
    freq2=find(abs(freqs-low2)==min(abs(freqs-low2)));
    LERD=mean(avgtf(freq1:freq2,:),1);
    subplot(12,1,10:12);
    plot(LERD,'b');
    
	path='/Users/long/BCI/matlab_scripts/force/plots/';
    filename=strcat(path,strcat('move',num2str(movement),num2str(movement)),'/',move,'_',num2str(chn),'.jpg');
    saveas(gcf,filename);
    clf('reset');
    close all;
    
end
set(0,'DefaultFigureVisible','on');
