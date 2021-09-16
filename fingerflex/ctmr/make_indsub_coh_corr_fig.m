function make_indsub_coh_corr_fig(subject, band, dtype,vth,vph)


% multcompcorr = 'y';
multcompcorr = 'n';


%%
    addpath /Users/kai/toolbox/
    addpath /Users/kai/toolbox/ctmr

%% load data


load(['data/' subject '/' subject '_' 'd' num2str(dtype) '_coh_' num2str(band(1)) '_' num2str(band(2))], 'tr_sc','coh_*', 'lnAcorr_*','rhycorr_*','*type*','dg_chan')
load(['data/' subject '/' subject '_lnAcorr_tot'], 'lnAcorr_tot')
load(['data/' subject '/' subject '_coh_tot_' num2str(band(1)) '_' num2str(band(2))], 'coh_tot')
load(['data/' subject '/' subject '_ampcorr_tot_' num2str(band(1)) '_' num2str(band(2))], 'ampcorr_tot')
load(['data/' subject '/' subject '_fingerflex'],'brain','locs')
num_chans=size(coh_r,1);

%% make brain plots with dots


% text position
% tx=max(brain.vert(:,1)); ty=max(brain.vert(:,2)); tz=.95*max(brain.vert(:,3));

ty=0; tz=min(brain.vert(:,3))-10; if vth<180, tx=max(brain.vert(:,1)); else tx=min(brain.vert(:,1)); end

%% trial by trial correct for multiple comparisons?
if multcompcorr == 'y'
    bfcorrect = .05/num_chans;
else
    bfcorrect = 1;
end

figure, % note that they are thresholded by bonferron sign.
    % phase / abs val of coherence (during rest)
    subplot('position',[.5  0 .48 .48]), 
    coh_m(dg_chan,:)=0;
    cohrest=mean(coh_blocks(find(tr_sc==0),:),1)';
    ph_dot_surf_view(brain,locs,cohrest.*(coh_p(:,find(beh_types==0))<bfcorrect),vth,vph,dg_chan);
    text(tx,ty,tz,['RestCoh_m ' num2str(max(abs(coh_m(:,6))))])

    % shift in coherence - display phase of coherence later?
    subplot('position',[.5 .5 .48 .48]), 
    rb_dot_surf_view(brain,locs,coh_r(:,dtype).*(coh_p(:,dtype)<bfcorrect),vth,vph,dg_chan);
    text(tx,ty,tz,['coh_r ' num2str(max(abs(coh_r(:,dtype))))])

    % broadband-correlation shift with activity
    subplot('position',[ 0 .5 .48 .48]), 
    rb_dot_surf_view(brain,locs,lnAcorr_r(:,dtype).*(lnAcorr_p(:,dtype)<bfcorrect),vth,vph,dg_chan);
    text(tx,ty,tz,['lnAcorr_r ' num2str(max(abs(lnAcorr_r(:,dtype))))])

    % shift in rhythm amplitude-correlation with activity
    subplot('position',[ 0  0 .48 .48]), 
    rb_dot_surf_view(brain,locs,rhycorr_r(:,dtype).*(rhycorr_p(:,dtype)<bfcorrect),vth,vph,dg_chan);
    text(tx,ty,tz,['rhycorr_r ' num2str(max(abs(rhycorr_r(:,dtype))))]) 
    
    dg_figfix
       
exportfig(gcf,['figs/' subject '/' subject '_' num2str(band(1)) '_' num2str(band(2)) '_d' num2str(dtype) '_cohcorr_shifts'], 'format', 'png', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 12, 'Height', 9);    
    
%%

figure, % across all sites
    % total coherence
    subplot('position',[.5  0 .48 .48]), 
    ph_dot_surf_view(brain,locs,coh_tot(:,dg_chan),vth,vph,dg_chan);
    text(tx,ty,tz,['RhyCoh_{Tot} ' num2str(max(abs(coh_tot(:,dg_chan))))])

    % total lnAcorr
    subplot('position',[ 0 .5 .48 .48]), 
    rb_dot_surf_view(brain,locs,lnAcorr_tot(:,dg_chan),vth,vph,dg_chan);
    text(tx,ty,tz,['lnAcorr_{Tot} ' num2str(max(abs(lnAcorr_tot(:,dg_chan))))])

    % shift in rhythm amplitude
    subplot('position',[ 0  0 .48 .48]), 
    rb_dot_surf_view(brain,locs,ampcorr_tot(:,dg_chan),vth,vph,dg_chan);
    text(tx,ty,tz,['RhyAmpcorr_{Tot} ' num2str(max(abs(ampcorr_tot(:,dg_chan))))]) 
    
    dg_figfix

exportfig(gcf,['figs/' subject '/' subject '_' num2str(band(1)) '_' num2str(band(2)) '_d' num2str(dtype) '_cohcorr_tot'], 'format', 'png', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 12, 'Height', 9);    


    
    





