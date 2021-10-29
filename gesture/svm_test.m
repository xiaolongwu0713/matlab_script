function svm_test(subj, fs, inx, inx5FB)
%%
% 得到 'ftrMatrix', 'labelMatrix'.
% 用通道相关性进行通道筛选.
% 十折交叉验证.
Inx = inx;
switch Inx
    case 1; tampStr =  '_Local';
    case 2; tampStr =  '_Bipolar';
    case 3; tampStr =  '_ESR';
    case 4; tampStr =  '_CAR';
    case 5; tampStr =  '_GWR';
    case 6; tampStr =  '_Raw';
end

switch inx5FB
    case 1; tampStr_ = '_hybrid';    FBs = 1:9;
    case 2; tampStr_ = '_delta';     FBs = 1;
    case 3; tampStr_ = '_theta';     FBs = 2;
    case 4; tampStr_ = '_alpha';     FBs = 3;
    case 5; tampStr_ = '_beta';      FBs = 4;
    case 6; tampStr_ = '_highgamma'; FBs = 5:9;
end  
pn = subj;
Fs = fs;
    fprintf('\n subj %d: pre_3_v2', pn);
    
sessionNum = 2;
addr = strcat('/Volumes/Samsung_T5/data/gesture/LSJ/P',num2str(pn)); 
cd(addr);
Folder = strcat('preprocessing3');
if ~exist(Folder,'dir')
    mkdir(Folder);
end
%%
if inx5FB == 1
    strname = strcat(addr,'/preprocessing2/preprocessingALL_2',tampStr,'.mat');
    load(strname, 'Datacell');
% Cut into task segment.
% Select 3 types of gestures and change the labels.
    ct5Trial = 0;
    for i=1:sessionNum
        EMG_trigger = Datacell{i}(:,end);
        trigger = find(EMG_trigger~=0);
        trialNum = length(trigger);
        segDuration = 8*Fs;
        for trial=1:trialNum
            ct5Trial = ct5Trial + 1;
            segData = Datacell{i}(trigger(trial)+0.25*Fs- segDuration/2:trigger(trial)+0.25*Fs+ segDuration/2-1, 1:end-1);
            ftrLabel(1:segDuration, 1) = EMG_trigger(trigger(trial));
            session{ct5Trial,1}=[segData,ftrLabel];
        end
    end
    
    % Hyperparameters.
    winLength=0.5*Fs;
    stride = 0.25*Fs;
    freqInterval = {[1,4],[4,8],[8,13],[13,30],[60,75],[75,95],[105,125],[125,145],[155,195]};
    channelNum = size(session{1,1}, 2) - 1;
    
    % Establish the feature set.
    MeanPsd5Baseline = zeros(length(freqInterval), channelNum);
    for trial=1:ct5Trial
        baselineData = session{trial, 1}(1:3*Fs,1:end-1);
        Psd5Baseline=pburg(baselineData,40,Fs,'onesided');
        for c=1:length(freqInterval)
            MeanPsd5Baseline(c,:) = MeanPsd5Baseline(c,:) + mean(Psd5Baseline(freqInterval{c}(1):freqInterval{c}(2),:),1);
        end
    end
    MeanPsd5Baseline = MeanPsd5Baseline / ct5Trial;
    
    % input_size of feature_set.
    ftrMatrix = zeros(ct5Trial, floor(1+(segDuration/2-winLength)/stride), size(freqInterval, 2), channelNum);
    labelMatrix = zeros(ct5Trial, floor(1+(segDuration/2-winLength)/stride), 1);
    % get the feature matrix.
    for trial=1:ct5Trial
        for strideInx = 1:floor(1+(segDuration/2-winLength)/stride)
            task_data = session{trial,1}(segDuration/2+1+(strideInx-1)*stride:segDuration/2+(strideInx-1)*stride+winLength,1:end-1);
            psd_t=pburg(task_data,40,Fs,'onesided');
            for c=1:length(freqInterval)
                MeanPsd5Task = mean(psd_t(freqInterval{c}(1):freqInterval{c}(2),:),1) - MeanPsd5Baseline(c,:); 
                ftrMatrix(trial, strideInx, c, :) =  MeanPsd5Task;
            end
            labelMatrix(trial, strideInx, 1) = session{trial,1}(1, end);
        end
    end
else
    strname=strcat('preprocessing3/preprocessingALL_3_0.5_v2',tampStr,'_hybrid1_210314.mat');
    load(strname,'ftrMatrix','labelMatrix','strideInx');                                                           % // 基于迭代中第一个被处理 inx5FB 的数据.
end

%% channel selection based on task_correlation.
[usefulChannel, ~, pVal] = channel_selection( Datacell, Fs, sessionNum, inx5FB);
usefulChannel=[1,2,3,4,5,6,7,8,9];
%%
label = reshape(labelMatrix(:,1,:), [], 1);fold = 10;repeatTs = 10;
tamp_ftrMatrix = reshape(ftrMatrix(:, :, FBs, usefulChannel), size(ftrMatrix, 1),size(ftrMatrix, 2), []);

% k-fold cross_validation.
[tk_train, tk_test]  = Stratified_KFold(label, fold, repeatTs, [1,2,3]);
for k = 1:fold*repeatTs
    % 54trial*15strides*9frequencies*9channel --> ([],9*9)
    ftr_train = reshape(tamp_ftrMatrix(tk_train(k,:),:,:), [], size(tamp_ftrMatrix, 3));% 54trial*15strides*9frequencies*9channel
    label_train = reshape(labelMatrix(tk_train(k,:),:,:),[],size(labelMatrix, 3));
    ftr_test = reshape(tamp_ftrMatrix(tk_test(k,:),:,:), [], size(tamp_ftrMatrix, 3));
    label_test = reshape(labelMatrix(tk_test(k,:),:,:),[],size(labelMatrix, 3));
    
    % 归一化.
    ftr_normalization = [ftr_train;ftr_test];
    [ftr_normalization, ~] = mapminmax(ftr_normalization');
    ftr_normalization = ftr_normalization';
    ftr_train = ftr_normalization(1:size(ftr_train, 1),:);
    ftr_test = ftr_normalization(end-size(ftr_test,1)+1:end,:);
    
    SVMModel_rbf = svmtrain(label_train, ftr_train, ' -t 0 -b 1');
    [~, accuracy, ~] = svmpredict(label_test,ftr_test, SVMModel_rbf);
    
    KfoldAccuracy(1, k) = accuracy(1);
end
KfoldAccuracy = [KfoldAccuracy mean(KfoldAccuracy)];

fprintf('\n ------------------------------------------------------------------------------');
fprintf(" \n %d channels selected, test-set's accuracy: %f  ",length(usefulChannel), KfoldAccuracy(1, end));
fprintf('\n ------------------------------------------------------------------------------');

%% save data file.
strname=strcat('preprocessing3/preprocessingALL_3_v2',tampStr,tampStr_,'.mat');
save(strname,'usefulChannel','KfoldAccuracy','ftrMatrix','labelMatrix','pVal','-v7.3');

end