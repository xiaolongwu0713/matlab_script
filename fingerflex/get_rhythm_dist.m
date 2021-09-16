function get_rhythm_dist(subject, band)

%% parameters

srate=1000; % sampling rate
num_bins=24; % number of phase bins
rh_window=[-249:250]; % window for calculation of rhythm influence about each event point


%% get rhythm

    load(['data/' subject '/' subject '_fingerflex'],'data'), data=car(data);
    load(['data/' subject '/' subject '_dg_pts'])
    num_chans=size(data,2);
    fband=0*data;
    disp('getting rhythm')
    % CONSIDER REPLACING THIS WITH SOMETHING TAHT IS GAUSSIAN IN THE FREQ. DOMAIN
    [bf_b bf_a] = getButterFilter(band, srate); %band pass
    for k=1:size(data,2) %loop to save
        fband(:,k)=hilbert(filtfilt(bf_b, bf_a, data(:,k))); %band pass
    end
    clear data

%% isolate stimulus periods
    disp('finding behavioral blocks')
    load(['data/' subject '/' subject '_stim'])
    trtemp=1;
    trialnr=0*stim; %initialize
    trialnr(1)=trtemp;
    tr_sc=0;
    for n=2:length(stim)
        if stim(n)~=stim(n-1)
            trtemp=trtemp+1;
            tr_sc=[tr_sc stim(n)];
        end
        trialnr(n)=trtemp;
    end
    clear n trtemp

%% trial by trial mean data - can add in power in freq bands here later  

load(['data/' subject '/' subject '_pc_ts'],'lnA') % loads lnA (broadband)
 for k=1:num_chans, lnA(:,k)=zscore(lnA(:,k)); end % z-score broadband
    
% load(['data/' subject '/' subject '_bbs'],'bbs') % loads bbs (smoothed broadband)

fprintf(1, 'Calculating power and modulation for all trials ...\n');
for cur_trial=1:max(trialnr), 
    %index counter for display
    if (mod(cur_trial+1, 20) == 0), fprintf(1, '%03d ', cur_trial+1); if (mod(cur_trial+1, 100) == 0), fprintf(1, '* /%d\r', max(trialnr)); end, end
    %isolate relevant data 
    tt=find(trialnr == cur_trial);
%     tr_bbs(cur_trial,:)=mean(bbs(tt,:));
    % log power - change here if want to go to A(t) instead of lnA(t)
        lnA_blocks(cur_trial,:)=mean(lnA(tt,:),1);
    % rhythm amplitude - square if want power instead of amplitude
        rhythm_blocks(cur_trial,:)=mean(abs(fband(tt,:)),1); 
    % Z modulation
        for k=1:num_chans
            % get coupling by phase
                [bin_pwr, bin_centers]=phase_power( ...
                    lnA(tt,k), ...  %broadband
                    angle(fband(tt,k)), ...  %phase
                    num_bins);
            % total coupling
                mod_blocks(cur_trial,k)=2*mean((bin_pwr-mean(bin_pwr)).*exp(1i*bin_centers));
        end
        tr_sc(cur_trial)=mean(stim(tt));
        tr_len(cur_trial)=length(tt);
        % fix me later?
%         if length(tt)<srate,tr_sc(cur_trial)=-1; end
end % session


%% eliminate meaningless epochs

    a=find(tr_sc==-1);
    tr_sc(a)=[];tr_len(a)=[];
    mod_blocks(a,:)=[]; 
    rhythm_blocks(a,:)=[]; 
    lnA_blocks(a,:)=[]; 
    % tr_bbs(a,:)=[]; 

    clear a

%% identify unique behavioral vars from 'pts' variable

beh_types=[1 2 3 4 5 0];
baseline_type=0; % rest is zero in this case

%% distributions - bb power and rhythm amp


for chan=1:size(lnA_blocks,2)
    lnA_blocks(:,chan)=lnA_blocks(:,chan)-mean(lnA_blocks(find(tr_sc==baseline_type),chan)); % subtracts off mean of baseline (rest) state
end

%% distributions - coupling

for chan=1:size(mod_blocks,2)
    for k=1:length(beh_types)
        if any(tr_sc==beh_types(k))
            rm=mod_blocks(tr_sc==beh_types(k),chan); 
%             a=find(isnan(abs(rm))); if length(a)>0, disp([subject ' chan - ' chan ' has a NaN']),end
            rm(find(isnan(abs(rm))))=[];
            ma=angle(mean(rm));
            mz=abs(mean(rm));
            dz=abs(rm).*cos(angle(rm)-ma); %projected values
            %
            dz_dist{k,chan}=dz;
        end
    end
end
% 
% error('a','a')

%% save

save(['data/' subject '/' subject '_fband_' num2str(band(1)) '_' num2str(band(2))],'fband','pts', '*_blocks','dz_dist','*type*','tr_sc', 'tr_len','stim')

