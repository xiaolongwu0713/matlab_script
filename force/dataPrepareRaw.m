function [train,test]=dataPrepareRaw(movetype,channels,badtrials)
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
train_trials=trials(1:end-1);
test_trials=setdiff(trials,train_trials);
global processed_data root_path;
%% generate data
seegf=strcat('move',num2str(movetype));

seeg=load_data(999,seegf);
channels=[channels,111,112];
%force=squeeze(seeg(111,:,:));
%% training and test dataset
% training data
seeg_trainTmp=seeg(channels,:,train_trials);
%force_trainTmp=force(:,train_trials);
% testing data
seeg_testTmp=seeg(channels,:,test_trials);
%force_testTmp=force(:,test_trials);
%% formating along the time dimm
for i=1:length(train_trials)
    train(((i-1)*15000+1):i*15000,:)=seeg_trainTmp(:,:,i)';
end
filename=strcat(root_path,'pls/move',num2str(movetype),'TrainRawData.mat');
save(filename,'train');

% format testing dataset
if test_trials > 2
    for i=1:length(test_trials)
        test(((i-1)*15000+1):i*15000,:)=seeg_testTmp(:,:,i)';
    end
end
filename=strcat(root_path,'pls/move',num2str(movetype),'TestRawData.mat');
save(filename,'test');

% call function to make data
%tmptrain=cell(4,1);tmptest=cell(4,1);
%tmptrain=cell(4,1);tmptest=cell(4,1);for i=1:4,[tmptrain{i},tmptest{i}]=dataPrepareRaw(i,activeChannels,badtrial);end
%trainn=cat(1,tmptrain{1},tmptrain{2},tmptrain{3},tmptrain{4});
%testt=cat(1,tmptest{1},tmptest{2},tmptest{3},tmptest{4});

