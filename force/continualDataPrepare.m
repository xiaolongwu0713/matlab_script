%function [train,test]=dataPrepareRaw(movetype,channels,badtrials)
%% 2D train/test set
% format: (times(30*15000), (114 features+ 1 force target)). 
% bands:[Delta:0.5-4  theta:4-8  alpha:8-12  beta:18-26 gamma: 60-140]

% Input: dataPrepare(1/2/3/4,[1,2,3..],[1,2,3..],7/3);
% output: train(samples * (chnNum*bandNum+1target));
%% step 1
% train/test=*/2, only last two trial will be test set.
trainall=cell(4,1);testall=cell(4,1);
for i=1:4
    badtrials=badtrial{i};
    alltrials=[1:40];
    trials=setdiff(alltrials,badtrials);
    train_trials=trials(1:end-2);
    test_trials=setdiff(trials,train_trials);
    global processed_data root_path;
    seegf=strcat('move',num2str(i));
    seeg=load_data(999,seegf);
    channels=[activeChannels,111,112];
    %force=squeeze(seeg(111,:,:));
    % training and test dataset
    % training data
    seeg_trainTmp=seeg(channels,:,train_trials);
    %force_trainTmp=force(:,train_trials);
    % testing data
    testall{i}=seeg(channels,:,test_trials);
    %force_testTmp=force(:,test_trials);
    % formating along the time dimm
    for j=1:length(train_trials)
        traintmp(((j-1)*15000+1):j*15000,:)=seeg_trainTmp(:,:,j)';
    end
    trainall{i}=traintmp;
end

%% step 2
% one trial of testtmp is for evaluation during training
% another is for test after training
evaluate=cat(2,testall{1}(:,:,1),testall{2}(:,:,1),testall{3}(:,:,1),testall{4}(:,:,1));
finaltest=cat(2,testall{1}(:,:,2),testall{2}(:,:,2),testall{3}(:,:,2),testall{4}(:,:,2));

train=cat(1,trainall{1},trainall{2},trainall{3},trainall{4});

filename='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/train.mat';
save(filename,'train');
filename='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/evaluate.mat';
save(filename,'evaluate');
filename='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/finaletest.mat';
save(filename,'finaltest');


