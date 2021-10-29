function [train,trainForce]=dataPrepare2(movetype,channels,trials)
%% cube features
% output1: 3D cude feature, shape: (trials(30/40), times(15000), chns(19)*bands(6)
% output2: force data, shape:(times(15000),trials(30/40))
% bands=[Delta:0.5-4  theta:4-8  alpha:8-12  beta:18-26 gamma: 60-140]

%% setup
RandIndex = randperm(30); totalTrial=length(trials);
%train_num=ceil(totalTrial*traintestration/(1+traintestration));
train_num=totalTrial;
train_trials=RandIndex(1:train_num);
%test_trials=setdiff(RandIndex,train_trials);
global processed_data root_path;
%% load data
seegf=strcat('move',num2str(movetype));
deltaf=strcat('delta',num2str(movetype));
thetaf=strcat('theta',num2str(movetype));
alphaf=strcat('alpha',num2str(movetype));
betaf=strcat('beta',num2str(movetype));
gammaf=strcat('gamma',num2str(movetype));
forcef=strcat('force',num2str(movetype),'2D');

seeg=load_data(1,seegf);
delta=load_data(1,deltaf);
theta=load_data(1,thetaf);
alpha=load_data(1,alphaf);
beta=load_data(1,betaf);
gamma=load_data(1,gammaf);
force=load_data(9999,forcef);
%% training and test dataset
% training data
delta_trainTmp=delta(channels,:,trials(train_trials));
theta_trainTmp=theta(channels,:,trials(train_trials));
alpha_trainTmp=alpha(channels,:,trials(train_trials));
beta_trainTmp=beta(channels,:,trials(train_trials));
gamma_trainTmp=gamma(channels,:,trials(train_trials));
seeg_trainTmp=seeg(channels,:,trials(train_trials));
force_trainTmp=force(:,trials(train_trials));
clear seeg delta theta alpha beta gamma

%% Concatenate all band cube
lent=size(seeg_trainTmp,2); % time length: 15000
force_train=force_trainTmp(1:lent,:);
trainset=cat(1,delta_trainTmp,theta_trainTmp,alpha_trainTmp,beta_trainTmp,gamma_trainTmp,seeg_trainTmp);

%% windowing
Fs=1000;
WinLength=0.1*Fs;
SlideLength=0.05*Fs;
N=size(trainset,2); %15000
WinNum=N/WinLength*2-1;

train=zeros(19*6,floor(WinNum),train_num);
for trial=1:train_num
    for i=1:WinNum
        starti=(i-1)*SlideLength+1;
        endi=(i-1)*SlideLength+WinLength;
        train(:,i,trial)=median(trainset(:,starti:endi,trial),2);
    end
end

trainForce=zeros(floor(WinNum),train_num);
for i=1:WinNum
    starti=(i-1)*SlideLength+1;
    endi=(i-1)*SlideLength+WinLength;
    trainForce(i,:)=median(force_train(starti:endi,:),1);
end
filename=strcat(root_path,'pls/move',num2str(movetype),'TrainData3D.mat');
save(filename,'train','trainForce');