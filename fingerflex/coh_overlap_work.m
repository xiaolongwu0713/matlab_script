function coh_overlap_work(subject)


%%
    band = [12 20];

%%
    load(['data/' subject '/' subject '_fband_' num2str(band(1)) '_' num2str(band(2))],'*block*','pts','*type*','dz_*','tr_sc'), 
    load(['data/' subject '/' subject '_fingerflex'],'brain','locs','elec_regions')
    [lnA_r, lnA_p, lnA_m, lnA_s, rhy_r, rhy_p, rhy_m, rhy_s, Zmd_r, Zmd_p, Zmd_m, Zmd_s]=dg_block_stats(lnA_blocks, rhythm_blocks, dz_dist, tr_sc, beh_types, baseline_type);
    num_chans=size(Zmd_r,1);

%%

    load(['data/' subject '/' subject '_d2_coh_12_20'])    
    hand_code=find(or(elec_regions==1, elec_regions==3));
    %
    a=mean(coh_blocks(tr_sc==0,:));
    b=angle(mean(a(hand_code)));
    dg_coh=abs(a).*cos(angle(a)-b); dg_coh(dg_chan)=[]; dg_coh = dg_coh.*(dg_coh>0);
    %
    a=mean(mod_blocks(tr_sc==0,:));
    b=angle(mean(a(hand_code)));
    dg_Zm0=abs(a).*cos(angle(a)-b); dg_Zm0(dg_chan)=[];    
    %
    dg_zmd=Zmd_r(:,2).'; dg_zmd(dg_chan)=[];
    dg_rhy=rhy_r(:,2).'; dg_rhy(dg_chan)=[];
    locs(dg_chan,:)=[];

%% calculate overlap statistics by reshuffling    
    [OL_pct_coh_zmd, OLM_coh_zmd, p_val_coh_zmd, rs_kurt_coh_zmd]=spat_reshuffle(dg_coh,dg_zmd,'y');
    [OL_pct_coh_rhy, OLM_coh_rhy, p_val_coh_rhy, rs_kurt_coh_rhy]=spat_reshuffle(dg_coh,dg_rhy,'y');
    [OL_pct_rhy_zmd, OLM_rhy_zmd, p_val_rhy_zmd, rs_kurt_rhy_zmd]=spat_reshuffle(dg_rhy,dg_zmd,'y');
    [OL_pct_coh_Zm0, OLM_coh_Zm0, p_val_coh_Zm0, rs_kurt_coh_Zm0]=spat_reshuffle(dg_coh,dg_Zm0,'y');
    [OL_pct_Zm0_rhy, OLM_Zm0_rhy, p_val_Zm0_rhy, rs_kurt_Zm0_rhy]=spat_reshuffle(dg_Zm0,dg_rhy,'y');
    [OL_pct_Zm0_zmd, OLM_Zm0_zmd, p_val_Zm0_zmd, rs_kurt_Zm0_zmd]=spat_reshuffle(dg_Zm0,dg_zmd,'y');
%%
    save(['data/' subject '/' subject '_coh_OL'], 'OL_*','OLM_*','p_val_*', 'rs_kurt_*')
    
    
    
    
    