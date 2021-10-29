function active_channel = activationUsingCorr(data,movetype)
% active_channel = activationUsingCorr(data,movetype,ploty)
% data:3D: (chn,time,trial); movetype:1/2/3/4; ploty: 1/0 plot/no-plot;

%% permutation test

fs=1000;
if movetype==1
ascendend=5;
elseif movetype==2
ascendend=11;
elseif movetype==3
ascendend=3;
elseif movetype==4
ascendend=5;
end

task=data(:,2*fs:ascendend*fs-1,:);
baseline = data(:,1:2*fs,:);


repetitions = 2500; % number of times that we repeat the permutation process
channels = size(data,1);
r_obs=zeros(1,channels);
segm=1000;% 100ms segmentation to get more samples and make the identification more sensative.

for channel = 1:channels
    channel
    x=median(baseline(channel,:,:),2);
    y=median(task(channel,:,:),2);
    N = length(x);
    M = length(y);
    
    seq=[squeeze(x)',squeeze(y)'];
    labels = [ones(1,N)*(-1), ones(1,M)]; % creates a vector of labels (-1 for baseline, +1 for task)
    r_obs(channel) = corr(seq', labels', 'type','spearman'); % computes r_obs
    
    % Note1: we use Spearman's correlation instead of the default
    % 'Pearson's correlation'. Spearman's correlation does not assume a linear
    % relationship between the two variables and is robust to outliers.  
    
    % Note2: it is not recommended to shuffle the data sample-by-sample.
    % This would destroy the autocorrelation and non-stationarities of the signal, 
    % which results in skewed r_pdf distributions and false-positive in the 
    % resulting selected locations. 
    
    % calculating the distribution r_pdf
    tmp = seq;
    for i = 1:repetitions
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


%% selecting locations with p-values smaller than 0.05 after Bonferroni-correcting for the number of tests (i.e., number of locations)

active_channel = find(p_value < 0.05/(channels)); % to do Bonferroni correction, we divide 0.05 (significance level) by the number of locations

%% plots r_pdf and r_obs for one reactive location and one non-reactive location
if 0==1
    if ~isempty(active_channel)
    figure
    histogram(r_pdf(:, active_channel(1))),
    hold on
    x1 = r_obs(active_channel(1));
    y1=get(gca,'ylim');
    plot([x1 x1],y1, 'r')
    title('Distribution of correlation coefficients observed by chance (r pdf, in blue) versus actual observed coefficient (r obs, red line) for a reactive location')

    non_reactive_locations = setdiff(1:channels, active_channel); % determining non-reactive locations
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
end