%       __________________________________________________________________
%       ********************load and select the raw data******************
clear all;clc;
pn=4;

address=strcat('/Volumes/lsj/RJ_preprocessing_data/P',num2str(pn)); %mac
if ~exist(address,'dir')
    mkdir(address);
end
cd(address);
Fs=1000;
Folder=strcat('/Volumes/lsj/RJ_preprocessing_data/P',num2str(pn),'/preprocessing');
if ~exist(Folder,'dir')
    mkdir(Folder);
end




strname=strcat('/Volumes/lsj/RJ_Raw_Data/P',num2str(pn),'/H1.mat');
load(strname);
strname=strcat('/Volumes/lsj/RJ_Raw_Data/P',num2str(pn),'/inf1.mat');
load(strname);


data=double(EEG.data);

tri_num=size(EEG.event,2);
tri_inf=zeros(tri_num-1,2);      %数据第一行不是.
for i=1:tri_num-1
    
    logicpos=isstrprop(EEG.event(:,i+1).type,'digit');
    digpos=str2double(EEG.event(:,i+1).type(logicpos));
    
    tri_inf(i,1:2)=[EEG.event(:,i+1).latency digpos];
    
end

%       __________________________________________________________________
%       **********************remove useless trials***********************

remv_tri=find(tri_inf(:,2)==23);
tri_inf(remv_tri',:)=[];

start_tri=find(tri_inf(:,2)==1);
start_tri_num=size(start_tri,1);
tri_inf_selct=tri_inf;
for i=1:start_tri_num
    if i<start_tri_num
        trial_tri=tri_inf_selct(start_tri(i):start_tri(i+1)-1,2);
        if isempty(find(trial_tri==3|trial_tri==4,1))||isempty(find(trial_tri==5|trial_tri==6,1))
            tri_inf(start_tri(i):start_tri(i+1)-1,:)=[];
            accuracy(i,:) = [];
            rtime(i,:) = [];
        end
    else
        trial_tri=tri_inf_selct(start_tri(i):end-1,2);
        if isempty(find(trial_tri==3|trial_tri==4,1))||isempty(find(trial_tri==5|trial_tri==6,1))
            tri_inf(start_tri(i):end-1,:)=[];
            accuracy(i,:) = [];
            rtime(i,:) = [];
        end
    end
end

%      ___________________________________________________________________
%      **********************filter the EEG signal************************

data=data';
channel_num=size(data,2);

% figure (1);clf;
% subplot(211);plot(data(:,1));
% title('raw signal');

OME=[0.5, 240];
data=cFilterD_EEG(data,channel_num,Fs,2,OME);
% subplot(212);plot(data(:,1));
% title('filtered signal');

%      ___________________________________________________________________
%      *************************cut into segment**************************

start_tri=find(tri_inf(:,2)==1);  %trigger
tri_num=size(start_tri,1);        %trial

[gg_t, gng_t, ngg_t, ngng_t] = deal(cell(1,channel_num), cell(1,channel_num), cell(1,channel_num), cell(1,channel_num));
[gg_ct, gng_ct, ngg_ct, ngng_ct] = deal(0, 0, 0, 0);
[gg_seg, gng_seg, ngg_seg, ngng_seg] = deal(16, 18, 18, 20);
[gg_mrk, gng_mrk, ngg_mrk, ngng_mrk] = deal(zeros(6, 1), zeros(6, 1), zeros(6, 1), zeros(6, 1)); %initialization.

for j=1:tri_num
    %     for i=1:channel_num
    
    %         if j<tri_num
    %             tri_data=data( tri_inf(start_tri(j),1)-0.5*Fs: tri_inf(start_tri(j+1)-1,1) + 1*Fs ,i);
    %         else
    %             tri_data=data(tri_inf(start_tri(j),1):tri_inf(find(tri_inf(:,2)==255)-1,1),i);
    %         end
    %
    %
    %         [s,f,t]=spectrogram(tri_data,256,250,256,Fs);
    %         imagesc(t,f,20*log10(abs(s(:,1:50)))), axis xy, colormap(jet);
    %         [tf,freqs,times,~]=timefreq(tri_data,Fs,'freqs',[0,30],'tlimits',[0,length(tri_data)],'winsize',1024);
    %         t=abs(tf);
    
    if rtime(j,1) ~= 3 && rtime(j,2) ~= 3 && accuracy(j,1) == 1 && accuracy(j,2) == 1
        
        for i=1:channel_num
            tri_data=data( tri_inf(start_tri(j),1)-1*Fs+1: min(tri_inf(start_tri(j),1) + (gg_seg-1)*Fs, tri_inf(find(tri_inf(:,2)==255)-1,1)) ,i);
            [tf,freqs,times,~]=timefreq(tri_data,Fs,'freqs',[0,15],'tlimits',[0,length(tri_data)],'winsize',1024,'ntimesout',200);
            t=abs(tf);
            if ~gg_ct
                gg_t{i} = t; 
                gg_times = times;
            else
                gg_t{i} = gg_t{i} + t;              
            end
        end
        gg_mrk = gg_mrk + ( tri_inf( start_tri(j): start_tri(j)+5,1)- (tri_inf( start_tri(j),1))+1*Fs)/Fs;
        gg_ct = gg_ct + 1;
        
    elseif rtime(j,1) == 3 && rtime(j,2) == 3 && accuracy(j,1) == 1 && accuracy(j,2) == 1
        for i=1:channel_num
            tri_data=data( tri_inf(start_tri(j),1)-1*Fs+1: min(tri_inf(start_tri(j),1) + (ngng_seg-1)*Fs, tri_inf(find(tri_inf(:,2)==255)-1,1)) ,i);
            [tf,freqs,times,~]=timefreq(tri_data,Fs,'freqs',[0,15],'tlimits',[0,length(tri_data)],'winsize',1024,'ntimesout',200);
            t=abs(tf);
            if ~ngng_ct                
                ngng_t{i} = t;  
                ngng_times = times;
            else
                ngng_t{i} = ngng_t{i} + t;
            end
        end
        ngng_mrk = ngng_mrk + ( tri_inf( start_tri(j): start_tri(j)+5,1)- (tri_inf( start_tri(j),1))+1*Fs)/Fs;
        ngng_ct = ngng_ct + 1;
        
    elseif rtime(j,1) == 3 && accuracy(j,1) == 1 && accuracy(j,2) == 1
        for i=1:channel_num
            tri_data=data( tri_inf(start_tri(j),1)-1*Fs+1: min(tri_inf(start_tri(j),1) + (ngg_seg-1)*Fs, tri_inf(find(tri_inf(:,2)==255)-1,1)) ,i);
            [tf,freqs,times,~]=timefreq(tri_data,Fs,'freqs',[0,15],'tlimits',[0,length(tri_data)],'winsize',1024,'ntimesout',200);
            t=abs(tf);
            if ~ngg_ct               
                ngg_t{i} = t;
                ngg_times = times;
            else
                ngg_t{i} = ngg_t{i} + t;               
            end
        end
        ngg_mrk = ngg_mrk + ( tri_inf( start_tri(j): start_tri(j)+5,1)- (tri_inf( start_tri(j),1))+1*Fs)/Fs;
        ngg_ct = ngg_ct + 1;
        
    elseif rtime(j,2) == 3 && accuracy(j,1) == 1 && accuracy(j,2) == 1
        for i=1:channel_num
            tri_data=data( tri_inf(start_tri(j),1)-1*Fs+1: min(tri_inf(start_tri(j),1) + (gng_seg-1)*Fs, tri_inf(find(tri_inf(:,2)==255)-1,1)) ,i);
            [tf,freqs,times,~]=timefreq(tri_data,Fs,'freqs',[0,15],'tlimits',[0,length(tri_data)],'winsize',1024,'ntimesout',200);
            t=abs(tf);
            if ~gng_ct
                
                gng_t{i} = t;
                gng_times = times;
            else
                gng_t{i} = gng_t{i} + t;
            end
        end
        gng_mrk = gng_mrk + ( tri_inf( start_tri(j): start_tri(j)+5,1)- (tri_inf( start_tri(j),1))+1*Fs)/Fs;
        gng_ct = gng_ct + 1;
    end
    
    
end

gg_mrk = gg_mrk/gg_ct;
gng_mrk = gng_mrk/gng_ct;
ngg_mrk = ngg_mrk/ngg_ct;
ngng_mrk = ngng_mrk/ngng_ct;


for i = 1:channel_num
    

        gg_t{i} = gg_t{i}/gg_ct;
        gng_t{i} = gng_t{i}/gng_ct;
        ngg_t{i} = ngg_t{i}/ngg_ct;
        ngng_t{i} = ngng_t{i}/ngng_ct;
        
%         thres = find(gg_times(1,:)>1*Fs)-1;
%         baseline=gg_t{i}(:,1:thres);
%         basevalue=mean(baseline, 2);   % column vector
%        
%         [m, n] = size(gg_t{i});
%         for b=1:n; gg_t{i}(:,b) = gg_t{i}(:,b) - basevalue;end
%         
%         for a=1:m
%             s=std(tf(a,1:thres));
%             gg_t{i}(a,:)=gg_t{i}(a,:)./s;
%         end
%         
%         thres = find(gng_times(1,:)>1*Fs)-1;
%         baseline=gng_t{i}(:,1:thres);
%         basevalue=mean(baseline, 2);   % column vector
%        
%         [m, n] = size(gng_t{i});
%         for b=1:n; gng_t{i}(:,b) = gng_t{i}(:,b) - basevalue;end
%         
%         for a=1:m
%             s=std(tf(a,1:thres));
%             gng_t{i}(a,:)=gng_t{i}(a,:)./s;
%         end
%         
%         
%         thres = find(ngg_times(1,:)>1*Fs)-1;
%         baseline=ngg_t{i}(:,1:thres);
%         basevalue=mean(baseline, 2);   % column vector
%        
%         [m, n] = size(ngg_t{i});
%         for b=1:n; ngg_t{i}(:,b) = ngg_t{i}(:,b) - basevalue;end
%         
%         for a=1:m
%             s=std(tf(a,1:thres));
%             ngg_t{i}(a,:)=ngg_t{i}(a,:)./s;
%         end
%         
%         
%         thres = find(ngng_times(1,:)>1*Fs)-1;
%         baseline=ngng_t{i}(:,1:thres);
%         basevalue=mean(baseline, 2);   % column vector
%        
%         [m, n] = size(ngng_t{i});
%         for b=1:n; ngng_t{i}(:,b) = ngng_t{i}(:,b) - basevalue;end
%         
%         for a=1:m
%             s=std(tf(a,1:thres));
%             ngng_t{i}(a,:)=ngng_t{i}(a,:)./s;
%         end
        
        
        
        figure(ceil(i/4));
        
        subplot(4,4,i-(ceil(i/4)-1)*4);
        imagesc([0,gg_seg],[0,15],gg_t{i});
               
        ax = gca;
        ax.XTick = 0:1:gg_seg; % set x-axis's tick.
        ax.YDir = 'normal';   %set y-axis's direction.
        
%         y=freqs;
%         lbl_tline=( tri_inf( start_tri(j): start_tri(j)+5,1)- tri_inf( start_tri(j))+1)*ones(1,size(y,2))/Fs;  %label=lbl
        lbl_tline = gg_mrk * ones(1,length(freqs));
        hold on;
        plot( lbl_tline(1,:),freqs,lbl_tline(2,:),freqs,lbl_tline(3,:),freqs,lbl_tline(3,:)+3,freqs,lbl_tline(5,:),freqs,lbl_tline(5,:)+3,freqs,'color','k','LineWidth',1.5);
        
        title(['T-F spectrum of channel-',num2str(i),'    go/go']);
        xlabel('Time/s');ylabel('FrequEncy/Hz');
        
%         load('/Volumes/lsj/lsj/Documents/MATLAB/MyColormaps.mat','mycmap')
%         colormap(ax,mycmap)
%         colorbar;
%         caxis([-1.5,4]);
%         
      
        
        subplot(4,4,4+i-(ceil(i/4)-1)*4);
        imagesc([0,gng_seg],[0,15],gng_t{i});
               
        ax = gca;
        ax.XTick = 0:1:gng_seg; % set x-axis's tick.
        ax.YDir = 'normal';   %set y-axis's direction.
        
        lbl_tline = gng_mrk * ones(1,length(freqs));
        hold on;
        plot( lbl_tline(1,:),freqs,lbl_tline(2,:),freqs,lbl_tline(3,:),freqs,lbl_tline(3,:)+3,freqs,lbl_tline(5,:),freqs,lbl_tline(5,:)+3,freqs,'color','k','LineWidth',1.5);
        
        title(['T-F spectrum of channel-',num2str(i),'    go/nogo']);
        xlabel('Time/s');ylabel('FrequEncy/Hz');
        
      
        
        subplot(4,4,8+i-(ceil(i/4)-1)*4);
        imagesc([0,ngg_seg],[0,15],ngg_t{i});
               
        ax = gca;
        ax.XTick = 0:1:ngg_seg; % set x-axis's tick.
        ax.YDir = 'normal';   %set y-axis's direction.
        
        lbl_tline = ngg_mrk * ones(1,length(freqs));
        hold on;
        plot( lbl_tline(1,:),freqs,lbl_tline(2,:),freqs,lbl_tline(3,:),freqs,lbl_tline(3,:)+3,freqs,lbl_tline(5,:),freqs,lbl_tline(5,:)+3,freqs,'color','k','LineWidth',1.5);
        
        title(['T-F spectrum of channel-',num2str(i),'    nogo/go']);
        xlabel('Time/s');ylabel('FrequEncy/Hz');
        
      
         
        subplot(4,4,12+i-(ceil(i/4)-1)*4);
        imagesc([0,ngng_seg],[0,15],ngng_t{i});
               
        ax = gca;
        ax.XTick = 0:1:ngng_seg; % set x-axis's tick.
        ax.YDir = 'normal';   %set y-axis's direction.
        
        lbl_tline = ngng_mrk * ones(1,length(freqs));
        hold on;
        plot( lbl_tline(1,:),freqs,lbl_tline(2,:),freqs,lbl_tline(3,:),freqs,lbl_tline(3,:)+3,freqs,lbl_tline(5,:),freqs,lbl_tline(5,:)+3,freqs,'color','k','LineWidth',1.5);
        
        title(['T-F spectrum of channel-',num2str(i),'    nogo/nogo']);
        xlabel('Time/s');ylabel('FrequEncy/Hz');
        
      
end
  


EEGdata = cell(1,channel_num);
for i = 1:channel_num
    EEGdata{i} = {[], [], [], []};
end

for i = 1:channel_num
    for j = 1:tri_num-1 % 最后一个trial长度达不到预设值.
        
        if rtime(j,1) ~= 3 && rtime(j,2) ~= 3 && accuracy(j,1) == 1 && accuracy(j,2) == 1
            tri_data=data( tri_inf(start_tri(j),1)-1*Fs+1: min(tri_inf(start_tri(j),1) + (gg_seg-1)*Fs, tri_inf(find(tri_inf(:,2)==255)-1,1)) ,i);
            EEGdata{i}{1, 1} = [EEGdata{i}{1, 1},tri_data];
        elseif rtime(j,1) == 3 && rtime(j,2) == 3 && accuracy(j,1) == 1 && accuracy(j,2) == 1
            tri_data=data( tri_inf(start_tri(j),1)-1*Fs+1: min(tri_inf(start_tri(j),1) + (ngng_seg-1)*Fs, tri_inf(find(tri_inf(:,2)==255)-1,1)) ,i);
            EEGdata{i}{1, 2} = [EEGdata{i}{1, 2},tri_data];
        elseif rtime(j,1) == 3 && accuracy(j,1) == 1 && accuracy(j,2) == 1
            tri_data=data( tri_inf(start_tri(j),1)-1*Fs+1: min(tri_inf(start_tri(j),1) + (ngg_seg-1)*Fs, tri_inf(find(tri_inf(:,2)==255)-1,1)) ,i);
            EEGdata{i}{1, 3} = [EEGdata{i}{1, 3},tri_data];
        elseif rtime(j,2) == 3 && accuracy(j,1) == 1 && accuracy(j,2) == 1
            tri_data=data( tri_inf(start_tri(j),1)-1*Fs+1: min(tri_inf(start_tri(j),1) + (gng_seg-1)*Fs, tri_inf(find(tri_inf(:,2)==255)-1,1)) ,i);
            EEGdata{i}{1, 4} = [EEGdata{i}{1, 4},tri_data];   
        end
    end
        
end


strname = strcat('/Volumes/lsj/RJ_preprocessing_data/P',num2str(pn),'/preprocessing/preprocessingAll.mat');
save(strname,'EEGdata','gg_mrk', 'gng_mrk', 'ngg_mrk', 'ngng_mrk');



