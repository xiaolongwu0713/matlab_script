function [train,test]=dataPrepare(movetype,channels,badtrials)
%% 2D train/test set
% format: (times(30*15000), (114 features+ 1 force target)). 
% bands:[Delta:0.5-4  theta:4-8  alpha:8-12  beta:18-26 gamma: 60-140]

% Input: dataPrepare(1/2/3/4,[1,2,3..],[1,2,3..],7/3);
% output: train(samples * (chnNum*bandNum+1target));

% train/test=*/2, only last two trial will be test set.
%% setup
badtrial=badtrials{movetype};
alltrials=[1:40];
trials=setdiff(alltrials,badtrial);
train_trials=trials(1:end-2);
test_trials=setdiff(trials,train_trials);
global processed_data root_path;
%% generate data
seegf=strcat('move',num2str(movetype));
deltaf=strcat('delta',num2str(movetype));
thetaf=strcat('theta',num2str(movetype));
alphaf=strcat('alpha',num2str(movetype));
betaf=strcat('beta',num2str(movetype));
gammaf=strcat('gamma',num2str(movetype));


seeg=load_data(999,seegf);
delta=load_data(999,deltaf);
theta=load_data(999,thetaf);
alpha=load_data(999,alphaf);
beta=load_data(999,betaf);
gamma=load_data(999,gammaf);
force=squeeze(seeg(111,:,:));
%% training and test dataset
% training data
delta_trainTmp=delta(channels,:,train_trials);
theta_trainTmp=theta(channels,:,train_trials);
alpha_trainTmp=alpha(channels,:,train_trials);
beta_trainTmp=beta(channels,:,train_trials);
gamma_trainTmp=gamma(channels,:,train_trials);
seeg_trainTmp=seeg(channels,:,train_trials);
force_trainTmp=force(:,train_trials);
% testing data
delta_testTmp=delta(channels,:,test_trials);
theta_testTmp=theta(channels,:,test_trials);
alpha_testTmp=alpha(channels,:,test_trials);
beta_testTmp=beta(channels,:,test_trials);
gamma_testTmp=gamma(channels,:,test_trials);
seeg_testTmp=seeg(channels,:,test_trials);
force_testTmp=force(:,test_trials);
clear seeg delta theta alpha beta gamma
%% formating along the time dimm
for i=1:length(train_trials)
    deltaTrain(((i-1)*15000+1):i*15000,:)=delta_trainTmp(:,:,i)';
    thetaTrain(((i-1)*15000+1):i*15000,:)=theta_trainTmp(:,:,i)';
    alphaTrain(((i-1)*15000+1):i*15000,:)=alpha_trainTmp(:,:,i)';
    betaTrain(((i-1)*15000+1):i*15000,:)=beta_trainTmp(:,:,i)';
    gammaTrain(((i-1)*15000+1):i*15000,:)=gamma_trainTmp(:,:,i)';
    seegTrain(((i-1)*15000+1):i*15000,:)=seeg_trainTmp(:,:,i)';
end

% formating force along the time dimm
for i=1:length(train_trials)
    forceTrain(((i-1)*15000+1):i*15000)=force_trainTmp(:,i);
end
clear delta_trainTmp theta_trainTmp alpha_trainTmp beta_trainTmp gamma_trainTmp seeg_trainTmp force_trainTmp
trainset=zeros(15000*length(train_trials),19*6);
trainset(:,1:19)=deltaTrain;
trainset(:,20:38)=thetaTrain;
trainset(:,39:57)=alphaTrain;
trainset(:,58:76)=betaTrain;
trainset(:,77:95)=gammaTrain;
trainset(:,96:114)=seegTrain;
trainset(:,115)=forceTrain;
clear deltaTrain thetaTrain alphaTrain betaTrain gammaTrain seegTrain
%filename=strcat(processed_data,'trainset.mat');
%save(filename,'trainset');


% format testing dataset
for i=1:length(test_trials)
    deltaTest(((i-1)*15000+1):i*15000,:)=delta_testTmp(:,:,i)';
    thetaTest(((i-1)*15000+1):i*15000,:)=theta_testTmp(:,:,i)';
    alphaTest(((i-1)*15000+1):i*15000,:)=alpha_testTmp(:,:,i)';
    betaTest(((i-1)*15000+1):i*15000,:)=beta_testTmp(:,:,i)';
    gammaTest(((i-1)*15000+1):i*15000,:)=gamma_testTmp(:,:,i)';
    seegTest(((i-1)*15000+1):i*15000,:)=seeg_testTmp(:,:,i)';
end

% formating force along the time dimm
for i=1:length(test_trials)
    forceTest(((i-1)*15000+1):i*15000)=force_testTmp(:,i);
end
clear delta_testTmp theta_testTmp alpha_testTmp beta_testTmp gamma_testTmp seeg_testTmp
testset=zeros(15000*length(test_trials),19*6);
testset(:,1:19)=deltaTest;
testset(:,20:38)=thetaTest;
testset(:,39:57)=alphaTest;
testset(:,58:76)=betaTest;
testset(:,77:95)=gammaTest;
testset(:,96:114)=seegTest;
testset(:,115)=forceTest;
clear deltaTest thetaTest alphaTest betaTest gammaTest seegTest
%filename=strcat(processed_data,'testset.mat');
%save(filename,'testset');
%% windowing. One move lasts for T=300 after the window, fs=20. 15s * 20Hz=300 poinsts;
Fs=1000; 
WinLength=0.1*Fs;
SlideLength=0.05*Fs;
N=size(trainset,1);
WinNum=N/WinLength*2-1;

train=zeros(floor(WinNum),19*6+1);
for i=1:WinNum
    starti=(i-1)*SlideLength+1;
    endi=(i-1)*SlideLength+WinLength;
    train(i,:)=median(trainset(starti:endi,:),1);
end
filename=strcat(root_path,'pls/move',num2str(movetype),'TrainData.mat');
save(filename,'train');

N=size(testset,1);
WinNumt=N/WinLength*2-1;
test=zeros(floor(WinNumt),19*6+1);
for i=1:WinNumt
    starti=(i-1)*SlideLength+1;
    endi=(i-1)*SlideLength+WinLength;
    test(i,:)=median(testset(starti:endi,:),1);
end
filename=strcat(root_path,'pls/move',num2str(movetype),'TestData.mat');
save(filename,'test');
