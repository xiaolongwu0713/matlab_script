% remove wrong trials of MI.
%
% Input:
%   data - the signal you wish to analyze
%   Fs - the sampling rate of the signal
%   Start - MI/ME 's start time in the trial
%   End - MI/ME 's end time in the trial
%
% Output:
%   wrong_trials - a list of the wrong trials
% 
% Example:
%   wrong_trials = remove_wrong_trials(EMGdata, 1000, 3, 5 )
function wrong_trials = remove_wrong_trials(data, Fs, Start, End )

EMGdata = data(:, end-1);
ftrLabel = data(:, end);
EMG_trigger = find( ftrLabel~=0);
pureftrLabel = data(EMG_trigger, end);

% EMGdata_smooth = smooth(abs(EMGdata), 0.025*Fs);
meanval_MI = []; meanval_ME = [];
for trial = 1:length(EMG_trigger) 
        EMGsegment = EMGdata( EMG_trigger(trial)+Start*Fs : EMG_trigger(trial)+End*Fs ); 
        if pureftrLabel == 1 || pureftrLabel == 2 || pureftrLabel == 3
            meanval_ME = [ meanval_ME; mean(EMGsegment), trial ];
        else
            meanval_MI = [ meanval_MI, mean(EMGsegment), trial ];
        end
end
meanAllTrial_ME = mean(meanval_ME(:, 1));
meanAllTrial_MI = mean(meanval_MI(:, 1));

Inx_ME = (meanval_MI < 0.5*meanAllTrial_ME);
Inx_MI = (meanval_MI > 1.5*meanAllTrial_MI);

wrong_trials = [ meanval_ME(Inx_ME, 2); meanval_MI(Inx_MI, 2) ];
wrong_trials = sort(wrong_trials);


