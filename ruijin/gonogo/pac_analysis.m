%%
[a,computer]=system('hostname');
pn = 5;
if strcmp(strip(computer),'longsMac')
    data_dir='/Volumes/Samsung_T5/data/ruijin/gonogo';
elseif strcmp(strip(computer),'workstation')
    data_dir='C:/Users/wuxiaolong/Desktop/BCI/data/ruijin/gonogo';
end

file=strcat(data_dir,'/preprocessing/P',num2str(pn),'/preprocessing/preprocessingv2.mat');

load(file);

data1=DATA{1,1};
data2=DATA{1,2};
trigger1=Trigger{1,1};
trigger2=Trigger{1,2};
trigger2(:,1)=trigger2(:,1)+size(data1,1);

data=cat(1,data1,data2);
trigger=cat(1,trigger1,trigger2); % latency, type, description_code(reaction time)

eeglab;
EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',data','srate',Fs,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname','raw','gui','off');
EEG = pop_importevent( EEG, 'event',trigger,'fields',{'latency','type','duration'},'timeunit',NaN);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
%eeglab redraw;

% dataset 2: epoch11
EEG = pop_epoch( ALLEEG(1), {  '11'  }, [-7  4], 'newname', 'epoch11', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off');
% dataset 3
EEG = pop_epoch( ALLEEG(1), {  '12'  }, [-7  4], 'newname', 'epoch12', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off');
% dataset 4
EEG = pop_epoch( ALLEEG(1), {  '21'  }, [-1  4], 'newname', 'epoch21', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off');
% dataset 5
EEG = pop_epoch( ALLEEG(1), {  '22'  }, [-1  4], 'newname', 'epoch22', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off');
eeglab redraw;

%%
% call pac analysis program on event 22
pac_eegbook1;
%pac_eegbook2;

% low frequency: 4-15, high frequency: 80-150;
%EEG = pop_pac(EEG,'Channels',[4 15],[80 150],[1,1,1,1,1],[1,2,3,4,5],'method','mvlmi','nboot',200,'alpha',[],'nfreqs1',4,'nfreqs2',20,'freqscale','log','bonfcorr',0);


%63**63 is waaaaaaaay too huge data
% for chni = [1:63]
%     chns=[1:63];
%     tmp = pop_pac(EEG,'Channels',[4 15],[80 150],repmat(chni,1,63),[1:63],'method','mvlmi','nboot',200,'alpha',[],'nfreqs1',4,'nfreqs2',20,'freqscale','log','bonfcorr',0);
%     param=tmp.etc.eegpac(1).params;
%     %A{chni}={EEG.etc.eegpac.mvlmi};
%     for ci =[1:63] 
%         field=strcat('c',num2str(chni),'_',num2str(ci));
%         result.(field)=tmp.etc.eegpac(ci).mvlmi.pacval;
%     end
%     if chni == 'ahaha'
%         fprintf('\n Pausing...  Press any key to resume.');
%         pause
%         fprintf('\n Resume running...');
%     end
%     
% end
%save('pac_result','result','param');
%a=EEG.etc.eegpac.mvlmi{1}.pacval;
%[a,b,c,d,e]=EEG.etc.eegpac.mvlmi;

imagesc(result.c2_2_10);%选取一个phase的frequency画图。
ax = gca;
ax.YDir = 'normal';

load('/Users/long/Documents/BCI/matlab_scripts/common/MyColormaps.mat','mycmap')
colormap(ax,jet)
caxis([-4,4]);
colorbar;
xlabel('Time/s');ylabel('FrequEncy/Hz');
