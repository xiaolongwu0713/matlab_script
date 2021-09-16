function call_subs_figs
% executes the entire signal processing, etc for each motor subject

%% add path
    addpath dc_files 
    addpath fig_functions

%% define subject and rhythm frequency range ("bands")
    subjects=['bp';'cc';'ht';'jc';'jp';'mv';'wc';'wm';'zt'];

    bands=[[4 8];[8 12];[12 20]];


%% cycle through subjects
for q=1%:size(subjects,1)
    subject=subjects(q,:);
    disp(subject)     

    %% viewing angle
    switch subject 
        case 'bp'; vth=250; vph=15;
        case 'cc'; vth=80; vph=40;
        case 'ht'; vth=270; vph=0;
        case 'jc'; vth=270; vph=15;
        case 'jp'; vth=270; vph=30; 
        case 'mv'; vth=250; vph=10; 
        case 'wc'; vth=285; vph=20; 
        case 'wm'; vth=100; vph=25;
        case 'zt'; vth=260; vph=15;    
    end

    %% Figures for each band
    for k=1:size(bands,1)
        band=bands(k,:);
        disp(num2str(band))
       
        %% somatotopy figure
            make_somato_fig(subject, band, vth, vph)
            get_somato_stats(subject, band)

        %% bar figures 
            load(['data/' subject '/' subject '_' num2str(band(1)) '_' num2str(band(2)) '_OLstats'])
            gcf,barh(-OL_pct','LineStyle','none'),set(gca,'xlim',[-1.05 .505],'ytick',[],'xtick',[-1:.25:.5],'xticklabel',{'-1'; ' ';'-.5';' '; '0'; ' '; '.5'},'Clipping','off'), box off
            set(gca,'YColor',[.99 .99 .99])
            exportfig(gcf, ['figs/' subject '/' subject '_somatobars'], 'format', 'png', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 2, 'Height', 4);
            disp(num2str(p_val))
        
        %% example traces
        gen_extraces(subject)
        
        % make plots of brains and rotate
        load(['data/' subject '/' subject '_fingerflex'],'brain','locs')
        clf, rb_dot_surf_view(brain,[locs; [0 0 0]],[.055+zeros(size(locs,1),1);1],vth,vph)
        exportfig(gcf,['figs/' subject '/' subject '_locs'], 'format', 'png', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 6.5, 'Height', 5.5);  
        clf, ctmr_gauss_plot(brain,[0 0 0],0), label_add(locs),loc_view(vth,vph)
        exportfig(gcf,['figs/' subject '/' subject '_labels'], 'format', 'png', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 4.5, 'Height', 3.5);  
        
    %% figures of whole brains
    for dtype=1:2 % thumb / index independently
        %
        % Broadband shift, rhythm shift, PAC shift, PAC during rest
        make_indsub_rhy_fig(subject,band,dtype,vth,vph)
        %
        % rhythm phase coherence, BB cross-correlation, rhythm amplitude cross-correlation, total in one fig and trial-by-trial in another fig
        make_indsub_coh_corr_fig(subject,band,dtype,vth,vph)
        %
    end    
    
    end
    
    %% statistics in individual channels
    for dtype=1:2 % thumb / index independently
        % get stats to find dg_chan - primary electrode to use
        load(['data/' subject '/' subject '_fband_' num2str(band(1)) '_' num2str(band(2))],'pts','*block*','*type*','dz_*','tr_sc'), % load rhythm - which band is irrelevant - only need lnA
        [lnA_r, lnA_p, lnA_m, lnA_s, rhy_r, rhy_p, rhy_m, rhy_s, Zmd_r, Zmd_p, Zmd_m, Zmd_s]=dg_block_stats(lnA_blocks, rhythm_blocks, dz_dist, tr_sc, beh_types, baseline_type);
        [tmp dg_chan]=max(abs(lnA_r(:,dtype))); clear *_s *_m *_r *_p tmp *_blocks *_type* tr_sc dz_dist

        % M1 figure triplet: ERP, ERBB, spectrogram in thumb & index specific site, spectra w/ decoupling, palette, shift insets
        clf,make_elec_fig(subject, dg_chan,dtype) % make figure here
    end
    
    %% generate shift bars    
    [Zmd0_r,  lnA0_r,  rhy0_r, Zmdrest_m] = gen_shift_bars(subject);

end



