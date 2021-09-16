function gen_extraces(subject)
% this function generates example traces
addpath /Users/kai/toolbox/

%%
    load(['data/' subject '/' subject '_pc_ts.mat'])
    load(['data/' subject '/' subject '_fband_12_20.mat']), clear fband
    load(['data/' subject '/' subject '_fingerflex'],'flex'), d1=flex(:,1); d2=flex(:,2); d3=flex(:,3); d4=flex(:,4); d5=flex(:,5);

    [lnA_r, lnA_p, lnA_m, lnA_s, rhy_r, rhy_p, rhy_m, rhy_s, Zmd_r, Zmd_p, Zmd_m, Zmd_s]=dg_block_stats(lnA_blocks, rhythm_blocks, dz_dist, tr_sc, beh_types, baseline_type);
    
%% 
switch subject
    case 'bp'; xlims = floor(1.0e+04 *[3.7457 5.9313]);
    case 'cc'; xlims = floor(1.0e+05 *[2.1109 2.3550]);
    case 'ht'; xlims = floor(1.0e+04 *[5.3922 7.4934]);
    case 'jc'; xlims = floor(1.0e+05 *[4.9384 5.2051]); 
    case 'jp'; xlims = floor(1.0e+05 *[1.4227 1.6764]);
    case 'mv'; xlims = floor(1.0e+05 *[0.7542 1.0254]); 
    case 'wc'; xlims = floor(1.0e+05 *[3.5210 3.7555]); 
    case 'wm'; xlims = floor(1.0e+05 *[0.7531 1.2220]);  
    case 'zt'; xlims = floor(1.0e+05 *[5.4166 5.7889]);
end

%%
    [tmp, d1chan]=max(lnA_r(:,1)), [tmp, d2chan]=max(lnA_r(:,2)), [tmp, d5chan]=max(lnA_r(:,5)),
    if subject == 'jc', d2chan = 35; end
    if subject == 'ht', d2chan = 47; d5chan = 17; end
%     if subject == 'mv', d1chan = 19; d2chan = 10; d5chan = 6; end
    if subject == 'mv', d1chan = 5; d2chan = 10; d5chan = 19; end
    d1dt=exp(pc_clean(lnA(:,d1chan))); d2dt=exp(pc_clean(lnA(:,d2chan))); d5dt=exp(pc_clean(lnA(:,d5chan)));

%%
    xlims=xlims(1):xlims(2);
    clf
    % plot finger position
    hold on, plot(zscore(double(d1(xlims)))-5,'color','b','linewidth',.75)
    hold on, plot(zscore(double(d2(xlims))),'color','g','linewidth',.75)
    hold on, plot(zscore(double(d5(xlims)))+5,'color',[.5 .4 1],'linewidth',.75)
    
    % plot cortical activity
    hold on, plot(zscore(d1dt(xlims))-7,'color',[.85 .4 .6 ],'linewidth',.75), 
    hold on, plot(zscore(d2dt(xlims))-2,'color',[.9  .4 .6 ],'linewidth',.75), 
    hold on, plot(zscore(d5dt(xlims))+3,'color',[.95 .4 .6 ],'linewidth',.75)
    
    get(gca,'xlim'), set(gca,'ytick',[],'Clipping','off'), 
    set(gca,'YColor',[.99 .99 .99])
    box off, axis tight
    
    title(['d1 - ' num2str(d1chan) ', d2 - ' num2str(d2chan) ', d5 - ' num2str(d5chan)])
    %     legend('d1','d2','d5',num2str(d1chan),num2str(d2chan),num2str(d5chan))
    exportfig(gcf, ['figs/' subject '/' subject '_somatotraces'], 'format', 'png', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 12, 'Height', 4);

    
    