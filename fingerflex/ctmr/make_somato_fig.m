function make_somato_fig(subject, band, vth, vph)


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
%     tx=max(brain.vert(:,1)); ty=max(brain.vert(:,2)); tz=.95*max(brain.vert(:,3));
ty=0; tz=min(brain.vert(:,3))-10;
if vth<180, tx=max(brain.vert(:,1)); else tx=min(brain.vert(:,1)); end

% correct for multiple comparisons?
if multcompcorr == 'y'
    bfcorrect = .05/num_chans;
else
    bfcorrect = 1;
end

%% make figure

dtypes = [1 2 5];
figure, % note that they are thresholded by bonferron sign.

for k=1:3
    dtype=dtypes(k);

    % broadband shift with activity
    subplot('position',[.32*(k-1)+.01 .5 .31 .49]), 
    rb_dot_surf_view(brain,locs,lnA_r(:,dtype).*(lnA_p(:,dtype)<bfcorrect),vth,vph); axis tight
    text(tx,ty,tz,['lnA_r ' num2str(max(abs(lnA_r(:,dtype))))])
    dg_figfix

    % shift in rhythm amplitude
    subplot('position',[.32*(k-1)+.01  0 .31 .49]), 
    rb_dot_surf_view(brain,locs,rhy_r(:,dtype).*(rhy_p(:,dtype)<bfcorrect),vth,vph); axis tight
    text(tx,ty,tz,['rhy_r ' num2str(max(abs(rhy_r(:,dtype))))]) 
    dg_figfix
end

exportfig(gcf,['figs/' subject '/' subject '_' num2str(band(1)) '_' num2str(band(2)) '_somato'], 'format', 'png', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 15, 'Height', 11.25);    
