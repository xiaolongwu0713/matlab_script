function make_indsub_rhy_fig(subject, band, dtype, vth, vph)


% multcompcorr = 'y';
multcompcorr = 'n';


%%
    addpath /Users/kai/toolbox/
    addpath /Users/kai/toolbox/ctmr

%%
    load(['data/' subject '/' subject '_fband_' num2str(band(1)) '_' num2str(band(2))],'*block*','pts','*type*','dz_*','tr_sc'), 
    load(['data/' subject '/' subject '_fingerflex'],'brain','locs')
    [lnA_r, lnA_p, lnA_m, lnA_s, rhy_r, rhy_p, rhy_m, rhy_s, Zmd_r, Zmd_p, Zmd_m, Zmd_s]=dg_block_stats(lnA_blocks, rhythm_blocks, dz_dist, tr_sc, beh_types, baseline_type);
    num_chans=size(Zmd_r,1);

%% make brain plots with dots


% text position
% tx=max(brain.vert(:,1)); ty=max(brain.vert(:,2)); tz=.95*max(brain.vert(:,3));

ty=0; tz=min(brain.vert(:,3))-10; if vth<180, tx=max(brain.vert(:,1)); else tx=min(brain.vert(:,1)); end

% correct for multiple comparisons?
if multcompcorr == 'y'
    bfcorrect = .05/num_chans;
else
    bfcorrect = 1;
end

figure, % note that they are thresholded by bonferron sign.
    % abs val of coupling (during rest)
    subplot('position',[.5  0 .48 .48]), 
    Zmodrest=mean(mod_blocks(find(tr_sc==0),:),1).';
    ph_dot_surf_view(brain,locs,Zmodrest.*(Zmd_p(:,find(beh_types==0))<bfcorrect),vth,vph);
    text(tx,ty,tz,['RestPac_m ' num2str(max(abs(Zmd_m(:,6))))])

    % shift in coupling
    subplot('position',[.5 .5 .48 .48]), rb_dot_surf_view(brain,locs,Zmd_r(:,dtype).*(Zmd_p(:,dtype)<bfcorrect),vth,vph);
    text(tx,ty,tz,['Zmd_r ' num2str(max(abs(Zmd_r(:,dtype))))])

    % broadband shift with activity
    subplot('position',[ 0 .5 .48 .48]), rb_dot_surf_view(brain,locs,lnA_r(:,dtype).*(lnA_p(:,dtype)<bfcorrect),vth,vph);
    text(tx,ty,tz,['lnA_r ' num2str(max(abs(lnA_r(:,dtype))))])

    % shift in rhythm amplitude
    subplot('position',[ 0  0 .48 .48]), rb_dot_surf_view(brain,locs,rhy_r(:,dtype).*(rhy_p(:,dtype)<bfcorrect),vth,vph);
    text(tx,ty,tz,['rhy_r ' num2str(max(abs(rhy_r(:,dtype))))]) 
    
    dg_figfix
    
    exportfig(gcf,['figs/' subject '/' subject '_' num2str(band(1)) '_' num2str(band(2)) '_d' num2str(dtype) '_indrhy'], 'format', 'png', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 12, 'Height', 9);    
    