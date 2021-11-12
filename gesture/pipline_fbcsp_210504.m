clear all;


global raw_dir processing_dir electrode_dir;
[ret, name] = system('hostname');
if strcmp(strip(name),'longsMac')
    raw_dir='/Volumes/Samsung_T5/data/gesture/Raw_Data_All/';
    electrode_dir='/Volumes/Samsung_T5/data/gesture/EleCTX_Files/';
    processing_dir='/Volumes/Samsung_T5/data/gesture/preprocessing/';
    info_dir='/Users/long/Documents/data/gesture/info/';
    common=['/Users/long/Documents/BCI/matlab_scripts/common/'];
    addpath(common);
    fbcsp=['/Users/long/Documents/BCI/matlab_scripts/motorImageryClassification'];
    addpath(genpath(fbcsp));
elseif strcmp(strip(name),'workstation')
    raw_dir='H:/Long/data/gesture/Raw_Data_All/';
    electrode_dir='H:/Long/data/gesture/EleCTX_Files/';
    processing_dir='H:/Long/data/gesture/preprocessing/';
    common=['C:/Users/wuxiaolong/Desktop/BCI/matlab_scripts/common/'];
    addpath(common);
    fbcsp=['C:\Users\wuxiaolong\Desktop\BCI\matlab_scripts\motorImageryClassification'];
    addpath(genpath(fbcsp));
end

%if there is a run time error - add breakpoint
%dbstop if error
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%INITIALIZE CONSTANTS%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%68.48 on
%nFilters = 1
%nBands = 7
%minFreq = 4 
%maxFreq = 34
%order = 4
% 3 to 6 seconds
% with artifact removal
% without channel extension!

nPersons=30
nClasses = 5;
nClassifiers = 3;
%2*m = number of filters, 2*mm = max number of filters
nFilters = 1;
nBands = 9;
freqInterval = {[1,4],[4,8],[8,13],[13,30],[60,75],[75,95],[105,125],[125,145],[155,195]};
order = 6;
fs = 1000;
type = 'butter';



meanMatrix = cell(2,nFilters);
predAll = zeros(1,0);
classesAll = predAll;
OVO = getOVO(nClasses);


%%%%%%%%%%%%%INITIALIZE RES%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataAll = zeros(nPersons,nClassifiers);
%%%%%%%%%%%%%%%%MAKE FILTERS%%%%%%%%%%%%%%%%%%%%%%%%%%%



bandFilters = initializeFilter(nBands,4,200,order,fs,type);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%MAIN LOOP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Inf = [2, 1000; 3, 1000; 4, 1000; 5, 1000; 7, 1000; 8, 1000; 9, 1000; 10, 2000; % 11, 500; 12, 500;
       13, 2000;  16, 2000; 17, 2000; 18, 2000; 19, 2000; 20, 1000; 21, 1000; 22, 2000; 23, 2000; % 14, 2000;
       29, 2000; 30, 2000; 31, 2000; 32, 2000; 34, 2000; 35, 1000; % 28, 2000; 33,    24, 2000; 25, 2000; 26, 2000; 
       36, 2000; 37, 2000; 41,2000;
       ];
Inf = [2, 1000; 3, 1000; 4, 1000; 5, 1000; 7, 1000; 8, 1000; 9, 1000; 10, 2000;  11, 500; 12, 500;
       13, 2000;  16, 2000; 17, 2000; 18, 2000; 19, 2000; 20, 1000; 21, 1000; 22, 2000; 23, 2000;  14, 2000;
       24, 2000; 25, 2000; 26, 2000;
       29, 2000; 30, 2000; 31, 2000; 32, 2000; 34, 2000; 35, 1000; % 28, 2000; 33,     
       41,2000;%36, 2000; 37, 2000; 
       ];

%goodSubj = [1,2,3,8,9,12,16,18,21,22,26];
%Inf = Inf(goodSubj,:);
nPersons = size(Inf,1);

%%
nPersons=1;
pn=5;
for personNumber = 1:nPersons
    
    %pn = Inf(personNumber, 1);
    Fs = 1000;  
    %%%%%%%%%%%
    %LOAD DATA%
    %%%%%%%%%%%
    
    %strname = strcat(processing_dir,'preprocessing_data.test/P',num2str(pn),'/preprocessing2/preprocessingALL_2.mat');
    strname='/Volumes/Samsung_T5/data/gesture/preprocessing_data.test/P5/preprocessing2/preprocessingALL_2.mat'
    load(strname, 'Datacell');
    
    SEEG = [Datacell{1};Datacell{2}];
    data.X = SEEG(:,1:end-1)';
    data.trial = find(SEEG(:,end)~= 0);
    data.classes = SEEG(data.trial,end);
    data.fs = Fs;
    
    %%%%%%%%%%%%%%%
    %%FILTER BANK%%
    %%%%%%%%%%%%%%%
    filteredX = cell(1,nBands);
    for band = 1:nBands
        %band pass filter data  -  using current band
        filterUse = bandFilters.filterVector{band};
        filteredX{band} = transpose(filtfilt(filterUse.b,filterUse.a,transpose(data.X)));
    end
    data.filteredX = filteredX;
    %%%%%%%%%%%
    %%%MODEL%%%
    %%%%%%%%%%%
    % k-fold cross_validation.    
    fold = 10;repeatTs = 1;
    [tk_train, tk_test]  = Stratified_KFold(data.classes, fold, repeatTs, [1,2,3,4,5]);
    
    Accuracy = zeros(nClassifiers,fold*repeatTs);
    nChannels = size(data.X,1);
    lenMISamples = 4*Fs;
    for k = 1:fold*repeatTs
        fprintf('k: %d.', k);
        
        tTrials = data.trial(tk_train(k,:));
        eTrials = data.trial(tk_test(k,:));
        tclasses = data.classes(tk_train(k,:));
        eclasses = data.classes(tk_test(k,:));
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%TRAIN SET%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf('Trainging set');
        ntTrials = length(tTrials);
        
        tfilteredX = cell(1, nBands);
        for band = 1:nBands
            tseegMI = zeros(nChannels,lenMISamples*ntTrials);
            for i = 1:ntTrials
                rowChannelsMI1 = (i-1)*lenMISamples + 1;   rowChannelsMI2 = i*lenMISamples;
                rowChannels1 = tTrials(i) + 1;          rowChannels2 = tTrials(i) + lenMISamples;
                tseegMI(:,rowChannelsMI1:rowChannelsMI2) = data.filteredX{band}(:,rowChannels1:rowChannels2);
            end
            tfilteredX{band} = tseegMI;
        end
        tTrialMI = 1:lenMISamples:size(tseegMI,2);
        
        tMIData = miDataStruct;
        tMIData.miData = tfilteredX;
        tMIData.classes = tclasses;
        tMIData.trials = tTrialMI;
        tMIData.fs = Fs;
        tMIData.nClasses = nClasses;
        tMIData.nTrials = ntTrials;
        tMIData.nChannels = nChannels;
        tMIData.OVO = OVO;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%Test SET%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf('Testing set');
        neTrials = length(eTrials);
        
        efilteredX = cell(1, nBands);
        for band = 1:nBands
            eseegMI = zeros(nChannels,lenMISamples*neTrials);
            for i = 1:neTrials
                rowChannelsMI1 = (i-1)*lenMISamples + 1;   rowChannelsMI2 = i*lenMISamples;
                rowChannels1 = eTrials(i) + 1;          rowChannels2 = eTrials(i) + lenMISamples;
                eseegMI(:,rowChannelsMI1:rowChannelsMI2) = data.filteredX{band}(:,rowChannels1:rowChannels2);
            end
            efilteredX{band} = eseegMI;
        end
        eTrialMI = 1:lenMISamples:size(eseegMI,2);
        
        eMIData = miDataStruct;
        eMIData.miData = efilteredX;
        eMIData.classes = eclasses;
        eMIData.trials = eTrialMI;
        eMIData.fs = Fs;
        eMIData.nClasses = nClasses;
        eMIData.nTrials = neTrials;
        eMIData.nChannels = nChannels;
        eMIData.OVO = OVO;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%% TRAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf('Trainging...');
        
        %Training data - spits out training features and CSP filter (w)
        %fbCspTrainOVO(miData,filterBands, nFilter, extendChannels)
        [tPred,w] = fbCspTrainOVO(tMIData,bandFilters,nFilters);
        
        %Evaluation data takes in previously calculated filter
        ePred = FBCSP(eMIData,bandFilters,w,'OVO');
        
        
        eClasses = eMIData.classes;
        %%%%%
        %LDA%
        %%%%%
        
        eMIData.classifiers = trainOVO(tMIData,tPred,'LDA');
        Accuracy(1,k) = classifyOVO(eMIData,ePred);
        fprintf('subj: %d, k: %d, LDAacc: %d', personNumber,k,Accuracy(1,k));
        %%%%%
        %SVM%
        %%%%%
        eMIData.classifiers = trainOVO(tMIData,tPred,'SVM');
        Accuracy(2,k) = classifyOVO(eMIData,ePred);
        fprintf('subj: %d, k: %d, SVMacc: %d', personNumber,k,Accuracy(2,k));
        %%%%%
        %NB%%
        %%%%%
        eMIData.classifiers = trainOVO(tMIData,tPred,'NAB');
        Accuracy(3,k) = classifyOVO(eMIData,ePred);
        fprintf('subj: %d, k: %d, NABacc: %d', personNumber,k,Accuracy(3,k));
    end
    dataAll(personNumber,:) = mean(Accuracy,2);
    
    %save LDAData.mat LDAData
    %save SVMData.mat SVMData
    %save NABData.mat NABData
end


%%

subVec = 1:9;
bar(subVec,dataAll)
grid on
ylim([0,100])
xlabel('Subject Number')
ylabel('Accuracy [%]')
legend('Linear Discriminant Analysis', 'Support Vector Machine','Naive Bayes')
%print('Plots/FBCSPOVO/barPlot','-depsc')

%plotconfusion(categorical(classesAll'),categorical(predAll'))
