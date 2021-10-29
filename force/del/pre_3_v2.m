function pre_3_v2(subj, fs, inx)

% delta [0.5, 4]; theta [4, 8]; alpha [8, 13]; beta [13, 30]; gamma [30, 60];
% highgamma [60, 100].

% Using [1, 30] and [60, 195] to do Hilbert transform, and then using 1-3, 
% 4-6s to do the permutation test, and then the intersection of the most 
% relevant 10 channels of the two bands is taken to get the result.
% paras: win_length = 0.5 s, slide_length = 0.25 s.

    fprintf('\n subj %d: pre_3_v2', subj);
    
Inx = inx;
switch Inx
    case 1
    tampStr =  '_Local';
        case 2
    tampStr =  '_Bipolar';
        case 3
    tampStr =  '_mean';
        case 4
    tampStr =  '_median';
        case 5
    tampStr =  '_CW';
end


pn = subj;
Fs = fs;
sessionNum = 2;
addr = strcat('D:/lsj/preprocessing_data/P',num2str(pn)); 
cd(addr);
Folder = strcat('preprocessing3');
if ~exist(Folder,'dir')
    mkdir(Folder);
end
strname = strcat('preprocessing2/preprocessingALL_2',tampStr,'.mat');
load(strname, 'Datacell', 'channelNum');

  fprintf('\n channel selection.');
[usefulChannel, ~] = channel_selection( Datacell, channelNum, Fs);

for i=1:sessionNum
    % 	cut into task segment
    
    EMG_trigger = Datacell{i}(:,end);
    trigger = find(EMG_trigger~=0);
    trialNum = length(trigger);
    segDuration = 8*Fs;
    for trial=1:trialNum
        segData=Datacell{i}(trigger(trial)+0.25*Fs- segDuration/2:trigger(trial)+0.25*Fs+ segDuration/2-1, 1:end-1);
        
        ftrLabel(1:segDuration, 1)=EMG_trigger(trigger(trial));  % size(~, 1) row, (~, 2) column
        session{trial,i}=[segData,ftrLabel];
    end
end

% prepared for 10-fold cross validation.
 fprintf('\n prepared for 10-fold cross validation.');
ftrInx=zeros(5, trialNum / 5, 2);
for i=1:sessionNum
    for trial=1:trialNum
        ftrLabel=session{trial,i}(2,end);
        ftrInx(ftrLabel,find(ftrInx(ftrLabel,:,i)==0, 1), i) = trial;
    end
end

ftrInx ([1, 4],:,:) = [];
ftrInx(:, :, 2) = ftrInx(:, :, 2) + trialNum;

ftrInx = reshape(ftrInx, 3, []);


fold = 10;
% optimal channel number selection.


testAccuracy = zeros(1, fold+1);


n = 1;

winLength=0.5*Fs;
stride = 0.25*Fs;
freqInterval = {[1,4],[4,8],[8,13],[13,30],[60,75],[75,95],[105,125],[125,145],[155,195]};

MeanPsd5Baseline = zeros(length(freqInterval), length(usefulChannel));
tampct = 0;
for i=1:sessionNum
    for trial=1:trialNum
        tampct = tampct + 1;
        baselineData = session{trial, i}(1:3*Fs,usefulChannel);
        Psd5Baseline=pburg(baselineData,40,Fs,'onesided');
        
        for c=1:length(freqInterval)
            MeanPsd5Baseline(c,:) = MeanPsd5Baseline(c,:) + mean(Psd5Baseline(freqInterval{c}(1):freqInterval{c}(2),:),1);
        end
    end
end
MeanPsd5Baseline = MeanPsd5Baseline / tampct;
% size(fre_interval, 2)*j就是特征向量的组成.
ftrMatrix = zeros(sessionNum*trialNum*ceil(1+(segDuration/2-winLength)/stride), size(freqInterval, 2)*length(usefulChannel) + 2);

% get the feature matrix.
for i=1:sessionNum
    for trial=1:trialNum
      
        for c=1:length(freqInterval)
             tmp = n;
            % window slide and psd process
            
            for strideInx=1:floor(1+(segDuration/2-winLength)/stride)
                
                task_data=session{trial,i}(segDuration/2+1+(strideInx-1)*stride:segDuration/2+(strideInx-1)*stride+winLength,usefulChannel);
                psd_t=pburg(task_data,40,Fs,'onesided');
                
                % each frequency bin was normalized to the trial and time-averaged amplitude value of
                % this frequency bin during a baseline period (i.e. subtract the mean value of each bin
                % from 4s to 0.25s before movement onset).
                MeanPsd5Task = mean(psd_t(freqInterval{c}(1):freqInterval{c}(2),:),1) - MeanPsd5Baseline(c,:);  % mean(A,2) 是包含每一行均值的列向量。
                ftrMatrix(tmp, (c-1)*length(usefulChannel)+1:c*length(usefulChannel) ) =  MeanPsd5Task;
                
                if c == 1
                    ftrMatrix(tmp, end-1:end) = [session{trial,i}(2,end), (i - 1)*trialNum + trial];
                end
                tmp=tmp+1;
            end
        end
        n = tmp;
        
    end
end

if (n-1) ~= size(ftrMatrix,1)
    fprintf('Error: the number of samples does not match the preset value!');
end

% 归一化.
[NrmftrMatrix, ~] = mapminmax(ftrMatrix(:, 1:end-2));
ftrMatrix = [NrmftrMatrix, ftrMatrix(:,end-1:end)];

% classification
% remove class 1 and 4.
ftrMatrix((ftrMatrix(:,end-1)==1|ftrMatrix(:,end-1)==4),:) = [];
ftrMatrix(:, end-1) = mod(ftrMatrix(:, end-1), 4);


t = crossvalind('Kfold', 20 ,fold);

for k = 1:fold
    test = (t == k); train = ~(t == k);
    test_trials = reshape(ftrInx(:, test), 1, []);
    train_trials = reshape(ftrInx(:, train), 1, []);
    
    
    test_ftr = [];
    for r = 1:size(ftrMatrix, 1)
        if isempty(find(train_trials == ftrMatrix(r,end),1))
            test_ftr = cat(1,test_ftr,r);
        end
    end
    train_ftr = ftrMatrix(setdiff(1:size(ftrMatrix, 1), test_ftr), :);
    test_ftr = ftrMatrix(test_ftr, :);
    
    
    ftr_train= train_ftr(:,1:end-2);
    label_train =  train_ftr(:,end-1);
    ftr_test =  test_ftr(:,1:end-2);
    label_test =  test_ftr(:, end-1);
    
    SVMModel_rbf = svmtrain(label_train, ftr_train, ' -t 0 -b 1');
    [~, accuracy, ~] = svmpredict(label_test,...
        ftr_test, SVMModel_rbf);
    
    testAccuracy(1, k) = accuracy(1);
end
testAccuracy(1, end) = sum(testAccuracy(1,1:end-1))/fold;
fprintf(" \n %d channels selected, test-set's accuracy: %f  ",length(usefulChannel), testAccuracy(1,end));

    
% save data file.
strname=strcat('preprocessing3/preprocessingALL_3_0.5_v2',tampStr,'.mat');
save(strname,'usefulChannel','testAccuracy','ftrMatrix','strideInx','-v7.3');