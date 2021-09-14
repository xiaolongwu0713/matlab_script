function [f p] = location_identification_Marker(DatName,Fs,CHN,fstr)

load(DatName);
% load(strcat('../2_Data_Alignment_Resize/',DatName));
CHN=size(Power_Data,3)-3;
task=zeros(Fs,size(Power_Data,2),CHN);

% for kk=1:size(Power_Data,2)
% EMG_Marker=Power_Data(:,kk,CHN+2);
% EMG_ind(kk)=find(EMG_Marker~=0);
% % number_of_samples = (700 * sampling_rate) / 1000; % calculates the number of samples corresponding to the 700 ms of stimulus presentation
% task(:,kk,1:CHN) = Power_Data(EMG_ind(kk)-100+(1:Fs),kk, 1:CHN);
% end
% we first define our baseline and task samples:
task=Power_Data(2*Fs+1:4*Fs,:,1:CHN);
baseline = Power_Data([1:Fs],:,1:CHN);



%% permutation test

% This tests if the samples from two conditions given by x (e.g., our baseline samples)
% and y (e.g., our task samples) come from one or two distinct distributions. To do so, it first
% calculates the correlation 'r_obs' between a vector containing the averaged brain
% signals samples from x and y, and a vector of condition labels z (e.g., -1 for baseline
% and +1 for task). It is thereby testing if there is a relationship between samples and labels.
% We assume that there will only be such a relationship for locations that
% responded to the task, i.e., that had an increase of broadband gamma
% power during the task commpared to baseline.
%
% We then need to assess the significance of r_obs, i.e., determining if r_obs 
% could be observed by chance, as opposed to truly indicate that there was a correlation
% between brain signals and labels. To do so, we will generate
% a distribution 'r_pdf' of correlation values that we observe by chance, to which we can
% compare r_obs. To do so, we will randomize the order of the brain signal samples
% and recalculate the correlation with the same vector of condition labels.
% This operation is repeated a large number of times and results in the gaussian distribution 'r_pdf' of
% correlation coefficients. This distribution should be centered around 0
% and is assumed to be normal. This distribution is representing the range
% of correlation values that we should observe by chance. 
%
% The p-value associated with the null hypothesis that r_obs is coming from
% the r_pdf distribution can be calculated with two different methods (we
% will use Method 1 by default):
%
% Method 1: returns an approximated two-tailed p-value based on the
% normal cumulative distribution function of mean and standard deviation 
% given by r_pdf. This gives us the probability that r_obs was observed by chance. 
%
% Method 2: returns a two-tailed p-value based on the proportion of values 
% from r_pdf larger than the absolute value of r_obs.

number_of_repetitions = 2500; % number of times that we repeat the permutation process
reverseStr = '';

number_of_locations = CHN;
segm=1000;% 100ms segmentation to get more samples and make the identification more sensative.
size_base=size(baseline,1);
size_task=size(task,1);
for channel = 1:number_of_locations
    
    % displaying message
    msg = sprintf('\n Processing channel %d/%d', channel, number_of_locations);
    fprintf([reverseStr, msg]);
%   reverseStr = repmat(sprintf('\b'), 1, length(msg));
    
    % calculating distributions x (mean of each baseline epoch) and y (mean of each task epoch)
%     for segx=1:floor(size_base/segm)
%         xt(segx,:) = mean(baseline((segx-1)*segm+(1:segm), :, channel), 1);
%     end
%     
%     for segy=1:floor(size_task/segm)
%         yt(segy,:) = mean(task((segy-1)*segm+(1:segm), :, channel), 1);
%     end
%     
%     x=reshape(xt,1,size(xt,1)*size(xt,2));
%     y=reshape(yt,1,size(yt,1)*size(yt,2));
    x=median(baseline(:,:,channel),1);
    y=median(task(:,:,channel),1);
    N = length(x);
    M = length(y);
    
    labels = [ones(1,N)*-1, ones(1,M)]; % creates a vector of labels (-1 for baseline, +1 for task)
    r_obs(channel) = corr([x y]', labels', 'type','spearman'); % computes r_obs
    
    % Note1: we use Spearman's correlation instead of the default
    % 'Pearson's correlation'. Spearman's correlation does not assume a linear
    % relationship between the two variables and is robust to outliers.  
    
    % Note2: it is not recommended to shuffle the data sample-by-sample.
    % This would destroy the autocorrelation and non-stationarities of the signal, 
    % which results in skewed r_pdf distributions and false-positive in the 
    % resulting selected locations. 
    
    % calculating the distribution r_pdf
    tmp = [x y];
    for i = 1:number_of_repetitions
        w = tmp(randperm(size(tmp, 2))); % permutating the means of baseline and task epochs
        r_pdf(i, channel) = corr(w', labels', 'type','spearman'); % computing correlation coefficient (i.e., one sample of the distribution r_pdf)
        
    end
    
    % Method 1:
    
    % Note: if is always advisable to manually check for the normality of r_pdf, for
    % example using a Chi-square goodness-of-fit test (chi2gof(r_pdf)). 
    
    p_value(channel) = 2*normcdf(-abs(r_obs(channel)), mean(r_pdf(:, channel), 1), std(r_pdf(:, channel), 0, 1));
    chiver(channel)=chi2gof(r_pdf(:,channel)); % reture value=0 means the data match the normality, otherwise, doesn't match the normality.
    
    % Method 2:

    % p_value(channel) = min(2*(length(find(r_pdf>abs(r_obs)))/norep), 1);

end

% saving p-values
if ~exist(strcat(fstr,'\Ele_Identify'),'dir')
    mkdir(strcat(fstr,'\Ele_Identify'));
end
indt=findstr(DatName(2:end),'B');
namesav=DatName(indt+2:end);
save(strcat(fstr,'\Ele_Identify\p_value_', namesav),'p_value','chiver');
% save('Ele_Identify\WITHOUTCAR.txt','');
%% selecting locations with p-values smaller than 0.05 after Bonferroni-correcting for the number of tests (i.e., number of locations)

reactive_locations = find(p_value < 0.01/(number_of_locations)); % to do Bonferroni correction, we divide 0.05 (significance level) by the number of locations
% class_num is all counted as variables
bad_channels=setdiff([1:CHN],goodchs);
% remove potential bad channels from this selection
reactive_locations = setdiff(reactive_locations, bad_channels); % return channels without bad_channels
f=reactive_locations;
p=p_value(reactive_locations);
% save selection
save(strcat(fstr,'\Ele_Identify\reactive_locations_',namesav), 'reactive_locations');

%% plots r_pdf and r_obs for one reactive location and one non-reactive location
if ~isempty(reactive_locations)
figure
histogram(r_pdf(:, reactive_locations(1))),
hold on
x1 = r_obs(reactive_locations(1));
y1=get(gca,'ylim');
plot([x1 x1],y1, 'r')
title('Distribution of correlation coefficients observed by chance (r pdf, in blue) versus actual observed coefficient (r obs, red line) for a reactive location')

non_reactive_locations = setdiff(1:number_of_locations, reactive_locations); % determining non-reactive locations
if ~isempty(non_reactive_locations)
figure
histogram(r_pdf(:, non_reactive_locations(1))),
hold on
x1 = r_obs(non_reactive_locations(1));
y1=get(gca,'ylim');
plot([x1 x1],y1, 'r')
title('Distribution of correlation coefficients observed by chance (r pdf, in blue) versus actual observed coefficient (r obs, red line) for a non-reactive location')
end
% figure
% stem(chiver(reactive_locations));
% title('normality check for reactive locations');
end
end