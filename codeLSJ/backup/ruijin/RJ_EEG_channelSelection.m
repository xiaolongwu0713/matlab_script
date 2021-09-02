
clear all;clc;
pn=5;


Folder=strcat('/Volumes/lsj/RJ_preprocessing_data/P',num2str(pn),'/channelSelection');
if ~exist(Folder,'dir')
    mkdir(Folder);
end

strname = strcat('/Volumes/lsj/RJ_preprocessing_data/P',num2str(pn));
cd(strname);
load preprocessing/preprocessingAll_v2.mat;

Fs = 1000;
channel_num=size(data,2);
tri_num=size(start_tri,1);        %trial

band = [0.5, 8];
h=fdesign.bandpass('N,F3dB1,F3dB2', 6,band(1),band(2), Fs);
Hd=design(h,'butter');
[B, A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
signal=filtfilt(B,A,data);
envelope= abs(hilbert(single(signal)));
power = envelope.^2;

rtimeMax = 0;
for i = 1:size(rtime, 1)
    if rtime(i, 1) ~= 3 && rtime(i, 1) > rtimeMax
        rtimeMax = rtime(i, 1);
    end
end
GosegLength = round(rtimeMax+3+0.5)*Fs;
NoGosegLength = 6*Fs;




% permutation test


number_of_repetitions = 1000; % number of times that we repeat the permutation process
reverseStr = '';

for channel = 1:channel_num

    Gotri_power = [];
    NoGotri_power = [];
    for j = 1:tri_num
        if rtime(j,1) ~= 3 && accuracy(j,1) == 1
            
            Gotri_power = cat(1,Gotri_power, power(tri_inf(start_tri(j)+2, 1)+1:tri_inf(start_tri(j)+2, 1)+GosegLength, channel)');
            
        elseif rtime(j,1) == 3 && accuracy(j,1) == 1        
            NoGotri_power = cat(1,NoGotri_power, power(tri_inf(start_tri(j)+2, 1)+1:tri_inf(start_tri(j)+2, 1)+NoGosegLength, channel)');
            
        end
        if rtime(j,2) ~= 3 && accuracy(j,2) == 1
           
            Gotri_power = cat(1,Gotri_power, power(tri_inf(start_tri(j)+4, 1)+1:tri_inf(start_tri(j)+4, 1)+GosegLength, channel)');
            
        elseif rtime(j,2) == 3 && accuracy(j,2) == 1
            NoGotri_power = cat(1,NoGotri_power, power(tri_inf(start_tri(j)+4, 1)+1:tri_inf(start_tri(j)+4, 1)+NoGosegLength, channel)');
            
        end
    end
    
  
    
    GopowerMean = mean(Gotri_power, 1);
    NoGopowerfMean = mean(NoGotri_power, 1);
 
    
    % calculating distributions x (mean of each Gocognitive epoch) and y (mean
    % of each NoGocognitive epoch).
    N = 3*Fs;
    M = 3*Fs;
    labels = [ones(1,N), ones(1,M)*-1]; % creates a vector of labels (-1 for baseline, +1 for task)
    r_obs_cogn(channel) = corr([GopowerMean(1:3*Fs), NoGopowerfMean(1:3*Fs)]',labels', 'type','spearman'); % computes r_obs
    
    
    % calculating the distribution r_pdf
    tmp = [GopowerMean(1:3*Fs), NoGopowerfMean(1:3*Fs)]';
    for i = 1:number_of_repetitions
        
        w = tmp(randperm(size(tmp, 1))); % permutating the means of baseline and task epochs
        r_pdf_cogn(i, channel) = corr(w, labels', 'type','spearman'); % computing correlation coefficient (i.e., one sample of the distribution r_pdf)
        
    end
    
   
    
    p_value_cogn(channel) = 2*normcdf(-abs(r_obs_cogn(channel)), mean(r_pdf_cogn(:, channel), 1), std(r_pdf_cogn(:, channel), 0, 1));
    chiver_cogn(channel)=chi2gof(r_pdf_cogn(:,channel)); % reture value=0 means the data match the normality, otherwise, doesn't match the normality.

    
    
    % calculating distributions x (mean of each Gomotion epoch) and y (mean
    % of each NoGomotion epoch).
    N = GosegLength - 3*Fs;
    M = NoGosegLength - 3*Fs;
    labels = [ones(1,N), ones(1,M)*-1]; % creates a vector of labels (-1 for baseline, +1 for task)
    r_obs_moti(channel) = corr([GopowerMean(3*Fs+1:end), NoGopowerfMean(3*Fs+1:end)]', labels', 'type','spearman'); % computes r_obs
    
    
     tmp = [GopowerMean(3*Fs+1:end), NoGopowerfMean(3*Fs+1:end)]';
    for i = 1:number_of_repetitions
        
        w = tmp(randperm(size(tmp, 1))); % permutating the means of baseline and task epochs
        r_pdf_moti(i, channel) = corr(w, labels', 'type','spearman'); % computing correlation coefficient (i.e., one sample of the distribution r_pdf)
        
    end
    
    p_value_moti(channel) = 2*normcdf(-abs(r_obs_moti(channel)), mean(r_pdf_moti(:, channel), 1), std(r_pdf_moti(:, channel), 0, 1));
    chiver_moti(channel)=chi2gof(r_pdf_moti(:,channel)); % reture value=0 means the data match the normality, otherwise, doesn't match the normality.
    

end

%% selecting locations with p-values smaller than 0.05 after Bonferroni-correcting for the number of tests (i.e., number of locations)

% reactive_locations = find(p_value < 0.05/number_of_locations); % to do Bonferroni correction, we divide 0.05 (significance level) by the number of locations
% 
[~,index_cogn] = sort(p_value_cogn);
[~,index_moti] = sort(p_value_moti);
