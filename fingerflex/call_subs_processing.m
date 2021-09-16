% function call_subs_processing
% executes the entire signal processing, etc for each motor subject



%% add path
    addpath dc_files 
    warning('off','signal:psd:PSDisObsolete'); %annoying

%% define subject and rhythm frequency range ("bands")
%subjects=['bp';'cc';'zt';'jp';'ht';'mv';'wc';'wm';'jc';];
subjects=['bp';'cc';'zt';];
%%
 bands=[[4 8];[8 12];[12 20]];
% bands=[12 20];
% bands=[4 8];
% bands=[8 12];

disp('subject, coh-Zm0, k, coh-Zmd, k, coh-rhy, k, rhy-zmd, k, rhy-zm0, k, zm0-zmd, k ') % this is the key for stats given at the end

%% cycle through subjects
for q=1:size(subjects,1)
    subject=subjects(q,:);
%     disp(subject)     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %     Checklist for each dataset:
    % % Steps 1-3 done ahead of time, all variables in file 'data/#subject#_fingerflex.mat
    % % 1 - reject bad channels - "data" variable has this already removed
    % % 2 - get rendering and locations - brain rendering structure is in "brain" variable
    % % 3 - assign electrodes to anatomic clusters - positions are in "locs" variable (channel number x 3), with labels in "elec_regions"
    % %         translation code for "elec_labels":    
            %     1 ? dorsal M1
            %     2 - rolandic
            %     3 ? dorsal S1
            %     4 ? ventral sensorimotor (M1+ S1) 
            %     6 ? frontal (non-rolandic) 
            %     7 ? parietal (non-rolandic)
            %     8 ? temporal 
            %     9 ? occipital

    %% % 4 - identify events
    pts = gen_inv_pts(subject); %note, in paper, these were checked / cleaned manually as well - this is first pass. check if you use
    
    %% % 5 - decoupling to get broadband (lnA), then timecourse
    load(['data/' subject '/' subject '_fingerflex'],'data'), data=car(data);
    [spectra]=calc_dg_spectra(data,pts);
    [nspectra]=calc_nspectra(spectra);
    [pc_weights, pc_vecs, pc_vals, f]=dg_pca_step(subject,nspectra);
    save(['data/' subject '/' subject '_decoupled'],'*spectra','pts','pc_*','f'), 
    clear data *spectra pts pc_* 
    % get timeseries of lnA
    gen_pc_all(subject)


    %% % 6 - generate all pac palettes
    gen_pac_matrix_all(subject)    

    %% % 7 - generate broadband amplitude correlations 
    get_lnAcorr_tot(subject)        
     
    %%  analyses for each band
    for k=1:size(bands,1)
        band=bands(k,:);
        disp(num2str(band))
        
        %% 8 - rhythm extraction and trial by trial rhythm amplitude, broadband amplitude, and pac amplitudes, Zmod corrected
               % note that trial-by-trial data calls "stim"
        get_rhythm_dist(subject, band)
        
        %% 9 - Generate whole run coherence
        get_coh_tot(subject,band)   

        %% 10 - Generate whole run amplitude correlations for each rhythm
        get_rhy_ampcorr_tot(subject,band) 
         
        %% 11 - Generate trial-by-trial coherence and amplitude cross-correlation (as well as broadband cross-correlation) for most significant thumb and forefinger electrodes
        for dtype=1:2
            task_cohere_corr(subject, band, dtype)
        end

    %% 12 statistics in individual channels for 
        for dtype=1:2            
            % get stats to find dg_chan - primary electrode to use
            load(['data/' subject '/' subject '_fband_' num2str(band(1)) '_' num2str(band(2))],'pts','*block*','*type*','dz_*','tr_sc'), % load rhythm - which band is irrelevant - only need lnA
            [lnA_r, lnA_p, lnA_m, lnA_s, rhy_r, rhy_p, rhy_m, rhy_s, Zmd_r, Zmd_p, Zmd_m, Zmd_s]=dg_block_stats(lnA_blocks, rhythm_blocks, dz_dist, tr_sc, beh_types, baseline_type);
            [tmp dg_chan]=max(abs(lnA_r(:,dtype))); clear *_s *_m *_r *_p tmp *_blocks *_type* tr_sc dz_dist
            gen_chan_triggered(subject,dg_chan,dtype,band)
        end
    end   
    
    %% 13 coherence - overlap statistics. Calculate then display.
    coh_overlap_work(subject)
    load(['data/' subject '/' subject '_coh_OL'], 'OL_*','OLM_*','p_val_*', 'rs_kurt_*')
    disp([subject ', ' num2str(OL_pct_coh_Zm0) ', ' num2str(p_val_coh_Zm0) ', ' num2str(OL_pct_coh_zmd) ', ' num2str(p_val_coh_zmd) ', ' num2str(OL_pct_coh_rhy) ', ' num2str(p_val_coh_rhy) ', ' num2str(OL_pct_rhy_zmd) ', ' num2str(p_val_rhy_zmd) ', ' num2str(OL_pct_Zm0_rhy) ', ' num2str(p_val_Zm0_rhy) ', ' num2str(OL_pct_Zm0_zmd) ', ' num2str(p_val_Zm0_zmd)])

end
