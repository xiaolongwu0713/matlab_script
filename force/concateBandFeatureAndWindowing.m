movetype=4;
movef=strcat('move',num2str(movetype));
deltaf=strcat('delta',num2str(movetype));
thetaf=strcat('theta',num2str(movetype));
alphaf=strcat('alpha',num2str(movetype));
betaf=strcat('beta',num2str(movetype));
gammaf=strcat('gamma',num2str(movetype));

move=load_data(1,movef);
chan=[activeChannels,111,112];
move=move(chan,:,goodtrial{movetype});
delta=load_data(1,deltaf);
theta=load_data(1,thetaf);
alpha=load_data(1,alphaf);
beta=load_data(1,betaf);
gamma=load_data(1,gammaf);


trainset=cat(1,delta,theta,alpha,beta,gamma,move);

%% windowing
Fs=1000;
WinLength=0.1*Fs;
SlideLength=0.05*Fs;
N=size(trainset,2); %15000
WinNum=N/WinLength*2-1;

chnNum=size(trainset,1);
trialNum=size(trainset,3);
train=zeros(chnNum,floor(WinNum),trialNum);
for trial=1:trialNum
    for i=1:WinNum
        starti=(i-1)*SlideLength+1;
        endi=(i-1)*SlideLength+WinLength;
        train(:,i,trial)=median(trainset(:,starti:endi,trial),2);
    end
end

folder='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/';
filename=strcat(folder,'move',num2str(movetype),'TrainData3D.mat');
save(filename,'train');


