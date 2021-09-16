
function task_cohere_corr(subject, band, dtype)

%% parameters

srate=1000; % sampling rate
num_bins=24; % number of phase bins
rh_window=[-249:250]; % window for calculation of rhythm influence about each event point


%% get rhythm and broadband

load(['data/' subject '/' subject '_fband_' num2str(band(1)) '_' num2str(band(2))],'fband','*block*','pts','*type*','dz_*','tr_sc'), % load rhythm
load(['data/' subject '/' subject '_pc_ts'],'lnA') % loads lnA (broadband)
num_chans=size(fband,2);


%% get stats to find dg_chan - primary electrode to use for coherence measure
[lnA_r, lnA_p, lnA_m, lnA_s, rhy_r, rhy_p, rhy_m, rhy_s, Zmd_r, Zmd_p, Zmd_m, Zmd_s]=dg_block_stats(lnA_blocks, rhythm_blocks, dz_dist, tr_sc, beh_types, baseline_type);
[tmp dg_chan]=max(abs(lnA_r(:,dtype))); 
clear *_s *_m *_r *_p dz* *_block*



%% isolate stimulus periods
    disp('finding behavioral blocks')
    load(['data/' subject '/' subject '_stim']) % this stim is the behavioral one, rather than the cue one
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
    
%% overall coherence

    % rhythm coherence
    for k=1:num_chans
         coh_tot(k)=mean(exp(1i*(angle(fband(:,k))-angle(fband(:,dg_chan)))),1);
    end
        
    coh_tot(dg_chan) = 0;

%% trial by trial coherence  

fprintf(1, 'Calculating coherence and correlation for all trials ...\n');
coh_blocks=zeros(max(trialnr),num_chans);
rhycorr_blocks=zeros(max(trialnr),num_chans);
lnAcorr_blocks=zeros(max(trialnr),num_chans);

for cur_trial=1:max(trialnr), 
    % index counter for display
        if (mod(cur_trial+1, 20) == 0), fprintf(1, '%03d ', cur_trial+1); if (mod(cur_trial+1, 100) == 0), fprintf(1, '* /%d\r', max(trialnr)); end, end

    % isolate relevant data 
        tt=find(trialnr == cur_trial);

    % rhythm coherence and correlation
        for k=1:num_chans
             coh_blocks(cur_trial,k)=mean(exp(1i*(angle(fband(tt,k))-angle(fband(tt,dg_chan)))),1);
             rhycorr_blocks(cur_trial,k)=mean(zscore(abs(fband(tt,k)).^.5).*zscore(abs(fband(tt,dg_chan)).^.5),1); %sqrt to make gaussian
             lnAcorr_blocks(cur_trial,k)=mean(zscore(lnA(tt,k)).*zscore(lnA(tt,dg_chan)),1); %already in ln units
        end
        
    tr_sc(cur_trial)=mean(stim(tt));
end % session


%% 

a=find(tr_sc==-1);
tr_sc(a)=[];
coh_blocks(a,:)=[]; 
rhycorr_blocks(a,:)=[]; 
lnAcorr_blocks(a,:)=[]; 

%% identify unique behavioral vars from 'pts' variable

beh_types=[1 2 3 4 5 0];
baseline_type=0; % rest is zero in this case

%% distribution projected down onto the mean

for chan=1:size(coh_blocks,2)
    for k=1:length(beh_types)
        if any(tr_sc==beh_types(k))
            rm=coh_blocks(tr_sc==beh_types(k),chan);
            rm(find(isnan(abs(rm))))=[];
            ma=angle(mean(rm));
            mz=abs(mean(rm));
            dz=abs(rm).*cos(angle(rm)-ma); %projected values
            %
            coh_dist{k,chan}=dz;
        end
    end
end


% error('a','a')

%% get statistics - note that there is parallel structure with standard measure, so can take advantage of existing function


[lnAcorr_r, lnAcorr_p, lnAcorr_m, lnAcorr_s, rhycorr_r, rhycorr_p, rhycorr_m, rhycorr_s, coh_r, coh_p, coh_m, coh_s]=dg_block_stats(lnAcorr_blocks, rhycorr_blocks, coh_dist, tr_sc, beh_types, baseline_type);

%% save

save(['data/' subject '/' subject '_' 'd' num2str(dtype) '_coh_' num2str(band(1)) '_' num2str(band(2))], 'pts', 'coh_*', 'lnAcorr_*','rhycorr_*','*type*','tr_sc','dg_chan')

