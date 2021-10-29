%% band power extraction
% shape: channels30*time15000*trials, no real or target force
% clean all power data to save disk space
movetype=4;
move=strcat('move',num2str(movetype));
epoch=load_data(9999,move);
force=epoch(111,:,:);

epoch=epoch(activeChannels,:,goodtrial{movetype});

%%
delta=[0.5 4];
theta=[4 8];
alpha=[8 12];
beta=[18 26];
gamma=[60 140];
bands{1}=delta;
bands{2}=theta;
bands{3}=alpha;
bands{4}=beta;
bands{5}=gamma;
bandnames={'delta','theta','alpha','beta','gamma'};
%%
for band=[1:5]
fprintf('processing band %d. \n', band);
%bpfilter(signal,order,lcfreq,hcfreq,fs)
N=6;
if band==1 || band==2
    N=4;
end

epochf=bpfilter(epoch,N,bands{band}(1),bands{band}(2),1000); 
%figure();subplot(2,1,1);pspectrum(epoch(110,:,1));subplot(2,1,2);pspectrum(epochl(110,:,1));
tmp= abs(cubeHilbert(single(epochf)));
power= tmp.^2;
%power=cat(1,power,force); force info is in epoch data, no need here.
filename=strcat(processed_data,'SEEG_Data/powerOf',bandnames{band},num2str(movetype),'.mat');
save(filename, 'power');
end