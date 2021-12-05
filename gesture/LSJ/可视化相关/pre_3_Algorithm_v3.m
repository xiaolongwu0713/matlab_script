function pre_3_Algorithm_v3(subj, fs)
%% preprocess for Algorithm.

    fprintf('\n subj %d: pre_3_Algorithm_v3', subj);
pn = subj;
Fs = fs;
sessionNum = 2;

addr=strcat('/Volumes/Samsung_T5/data/gesture/LSJ/P',num2str(pn),'/');
if ~exist(addr,'dir')
    mkdir(addr);
end

Folder = strcat(addr,'preprocessing3_Algorithm/');
if ~exist(Folder,'dir')
    mkdir(Folder);
end
strname1 = strcat('/Volumes/Samsung_T5/data/gesture/LSJ/P',num2str(pn),'/preprocessing2/preprocessingALL_2.mat');
load(strname1, 'Datacell');


% //
% [selected_Chns, ~, resFinal] = Channel_Exclusion_For_Algorithm(pn, 0.0001);

clear ftrLabel session;
ct5Trial = 0;
for i=1:sessionNum
    EMG_trigger = Datacell{i}(:,end);
    trigger = find(EMG_trigger~=0);
    trialNum = length(trigger);
    segDuration = 8*Fs;
    for trial=1:trialNum
        ct5Trial = ct5Trial + 1;
        segData=Datacell{i}(trigger(trial)+0.25*Fs- segDuration/2:trigger(trial)+0.25*Fs+ segDuration/2-1, 1:end-1);
        ftrLabel(1:segDuration, 1) = EMG_trigger(trigger(trial));
        session{ct5Trial,1}=[segData,ftrLabel];
    end
end


win_length=0.5*Fs;
slide_length=0.25*Fs;
ct5subtrial = floor(1+(segDuration/2-win_length)/slide_length);
preData = zeros(ct5Trial, ct5subtrial, 1, size(session{1,1},2)-1, win_length);
preLabel = zeros(ct5Trial, ct5subtrial, 1);
for trial=1:ct5Trial
    C = session{trial,1}(1,end);
    for slide_index=1:floor(1+(segDuration/2-win_length)/slide_length)
        segment=session{trial,1}(segDuration/2+(slide_index-1)*slide_length+1:segDuration/2+(slide_index-1)*slide_length+win_length,1:end-1);
        preData(trial, slide_index, 1, :, :) = segment';
        preLabel(trial, slide_index, 1) = C;
    end
end

strname=strcat(Folder,'preprocessingALL_3_Algorithm_v3.mat');
save(strname,'preData','preLabel','-v7.3');


end
