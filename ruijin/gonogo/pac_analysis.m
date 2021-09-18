pn = 5;
file=strcat('/Volumes/Samsung_T5/data/ruijin/gonogo/preprocessing/P',num2str(pn),'/preprocessing/preprocessingv2.mat');
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
eeglab redraw;

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

% switch dataset to dataset 2 to 4 and plot raw with events
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',4,'study',0);
pop_eegplot( EEG, 1, 1, 1);


EEG = pop_pac(EEG,'Channels',[4 15],[80 150],[1],[1],'method','mvlmi','nboot',200,'alpha',[],'nfreqs1',4,'nfreqs2',20,'freqscale','log','bonfcorr',0);
a=EEG.etc.eegpac.mvlmi.pacval;
imagesc(squeeze(a(1,:,:)));%选取一个phase的frequency画图。
ax = gca;
ax.YDir = 'normal';

load('/Users/long/Documents/BCI/matlab_scripts/common/MyColormaps.mat','mycmap')
colormap(ax,jet)
caxis([-4,4]);
colorbar;
xlabel('Time/s');ylabel('FrequEncy/Hz');
