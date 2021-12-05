%%
clear;clc;

pn = 41;
Fs = 1000;
sessionNum = 2;

strname = strcat('H:/lsj/preprocessing_data/P',num2str(pn),'/preprocessing2/preprocessingALL_2.mat');
load(strname, 'Datacell');

win_length=0.5*Fs;
slide_length=0.25*Fs;
for inx5FB = 1:49
    ct5Trial = 0;
    for i=1:sessionNum
        BCIdata=Datacell{i}(:,1:end-1);
        if inx5FB == 1
            band = [0.5, 4];
        else
            band = [4*(inx5FB-1), 4*inx5FB];
        end
        % extract each frequency band power.
        h = fdesign.bandpass('N,F3dB1,F3dB2', 6,band(1, 1),band(1, 2), Fs);
        Hd=design(h,'butter');
        [B, A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
        signal = filtfilt(B,A,BCIdata);
        envelope = abs(hilbert(single(signal)));
        power5FB = double(envelope.^2);
        
        
        EMG_trigger=Datacell{i}(:, end);
        trigger=find(EMG_trigger~=0);
        trialNum=length(trigger);
        seg_duration=8*Fs;
        
        for trial=1:trialNum
            ct5Trial = ct5Trial + 1;
            tamppower = power5FB(trigger(trial)+0.25*Fs- seg_duration/2:trigger(trial)+0.25*Fs+ seg_duration/2-1, :);
            for slide_index=1:floor(1+(seg_duration/2-win_length)/slide_length)
                power5Seg{(ct5Trial-1)*[floor(1+(seg_duration/2-win_length)/slide_length)]+slide_index, inx5FB}=tamppower(seg_duration/2+(slide_index-1)*slide_length+1:seg_duration/2+(slide_index-1)*slide_length+win_length,:);
            end
        end
    end
end
SAVE_PATH = 'D:/lsj/Modelvari_CNN/power5FB_P41.mat';
save(SAVE_PATH, 'power5Seg' , '-v7.3');


