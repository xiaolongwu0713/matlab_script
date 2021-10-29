function data=testDataHilbert(session,mode)
% mode=1: pure white noise, mode=2: resemble epoch
% 40 trials, 200 chns,15000 time steps
% most active is [chn,trial]:[90,33] [80,32] [70,31] [60,23] [50,22] [40,21] [30,13]
% [20,12] [10,11]
% data: (chn,time,trial):200,15000,40;
global processed_data;
trialNum=40;
chnNum=200;
timeLen=15000;
for trial=[1:trialNum]
    for chn=[1:chnNum]
        data(chn,:,trial)=wgn(15*1000,1,10);
    end
end

chns=[10,20,30,40,50,60,70,80,90];
trials=[11,12,13,21,22,23,31,32,33];
fs=1000;
coef=chns./10;

tmp=load_data(session,'info');
tduration=tmp.Info.task_duration;
if mode==2
    for k=[1:length(chns)]
        trial=trials(k);
        tstart=2000;
        tend=tduration(trial)*1000;
        duration=tend-tstart;
        t = (1:duration)/fs; % Time vector
        task= 20*sin(2*pi*t);
        task=task'.*coef(k);
        data(chns(k),[tstart:tend-1],trial)=task;
    end
end
filename=strcat(processed_data,'SEEG_Data/','testHilbert.mat');
save(filename,'data');

end