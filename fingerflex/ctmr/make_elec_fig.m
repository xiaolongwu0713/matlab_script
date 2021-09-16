function make_elec_fig(subject, dg_chan,dtype)

load(['data/' subject '/' subject '_chan_' num2str(dg_chan) '_triggered_d' num2str(dtype)])


%% load generals, add paths, etc
    load dg_colormap

%% defaults
    samplerate=1000;
    fmax=50; num_bins=24;
    bands=[[4 8];[8 12];[12 20]];
    bcol=[[0 0 .5]; [0 .5 0]; [.5 1 .5]; [0 .5 .5];  [.5 .5 1];[.3 .3 .3]]; % colors for different classes
    sf=.0298; %scalefactor from amp units to microvolts
    bin_edges=[-pi:(2*pi/(num_bins)):(pi)]; bin_centers=bin_edges(1:(num_bins))+pi/num_bins;

%% find isi and visual stim indices
    dg_ind=find(pts(:,3)==dtype); % middle of stimulus presentation
    rest_ind=find(pts(:,3)==0); % middle of isi period

%% make dynamic spectrum (time-freq, tf) mesh plot
    subplot('position',[.07 .7 .63 .2])
%     kjm_imagesc(win(1):win(2),0:50:200,tf)
    imagesc(win(1):win(2),0:50:200,tf(:,200:-1:1).')
    a=get(gca,'yticklabel'); set(gca,'yticklabel',a(end:-1:1,:))
    colormap(cm)

    if mean(std(tf,1))>.15
        set(gca,'clim',[0 2]),
        text(win(2)-500,20,'0 to 200%','FontSize',8)
        %title([subject ' , electrode' num2str(chan) ', colorscale - 0 to 200%'])
    else 
        set(gca,'clim',[.5 1.5]), 
        text(win(2)-500,20,'50 to 150%','FontSize',8)
    %     title([subject ' , electrode' num2str(chan) ', colorscale - 50 to 150%'])    
    end
    % xlabel('Time from stimulus onset (ms)')
    ylabel('Frequency (Hz)')

    set(gca,'ytick',[ 50 100 150 200]), set(gca,'yticklabel',[150 100 50 0])
    set(gca,'xtick',[])

    box off, dg_figfix


%% stimulus-triggered average potential
%     subplot('position',[.07 .6 .63 .1])
%     hold on, plot([win(1):win(2)],data_sta,'color',bcol(dtype,:))
%     axis tight
%     a=get(gca,'ylim');
%     set(gca,'ylim', [min([0 1.1*a(1)]) max([a(2) 1.1*a(2)])])
%     set(gca,'ytick',10*[ceil(.8*a(1)/10) floor(.8*a(2)/10)])
%     ylabel('\mu V')
%     text(win(2)-500,.8*a(2),'E.R.P.','FontSize',8)
%     set(gca,'xtick',1000*[ 0 1 2])
%     xlabel('Time from stimulus onset (ms)')
%     dg_figfix

%% stimulus-triggered average beta
    subplot('position',[.07 .6 .63 .1])
    hold on, plot(win,[0 0],'-','color',[.7 .7 .7])
    hold on, plot([win(1):win(2)],fband_sta,'color',bcol(dtype,:))
    axis tight
    a=get(gca,'ylim');
    set(gca,'ylim', [min([0 1.1*a(1)]) max([a(2) 1.1*a(2)])])
%     set(gca,'ytick',10*[ceil(.8*a(1)/10) floor(.8*a(2)/10)])
    ylabel('N.U.')
    text(win(2)-500,.8*a(2),'E.R. \beta','FontSize',8)
    set(gca,'xtick',1000*[ 0 1 2])
    xlabel('Time from stimulus onset (ms)')
    dg_figfix

%% stimulus triggered average broadband
    subplot('position',[.07 .9 .63 .1])
    hold on, plot([win(1):win(2)],exp(lnA_sta),'color',bcol(dtype,:))
    axis tight
    a=get(gca,'ylim');
    set(gca,'ylim', [min([0 1.1*a(1)]) max([a(2) 1.1*a(2)])])
    set(gca,'xtick',[])
    set(gca,'ytick',[min([ceil(a(1)) floor(.8*a(2))-1]) floor(.8*a(2))])
    ylabel('N.U.')
    text(win(2)-500,.8*a(2),'E.R.BB.','FontSize',8)
    text(win(1)+200,.8*a(2),['d' num2str(dtype) ' movement onset'],'FontSize',8)
    dg_figfix

%% phase-amp pallette
    % load pallettes
    load(['data/' subject '/' subject '_pac_all'])    
    subplot('position',[.78 .6 .2 .33])
    imagesc(bin_centers,0:10:50,pac_matrix(end:-1:1,:,dg_chan))
    cscale=max(max(abs(squeeze(pac_matrix(50:-1:5,:)))));
    set(gca,'clim', cscale*[-1 1]),
    colormap(cm), 
    loc_view(0,90)
    set(gca,'ytick',[0:10:40])
    box off
    set(gca,'xtick',max(bin_centers)*[-1:1]),set(gca,'xticklabel',{'- pi','0','pi'}), box off
    axis tight
    xlabel('Phase of rhythm')
    ylabel('Frequency of rhythm')
    title([subject ' chan ' num2str(dg_chan) ', max=' num2str(cscale)])

    dg_figfix

%% spectra, native and decoupled
    pk=[2:4];

    % dc matrix    
    imm=pinv(mm); %inverse mixing matrix
    imm_pl=imm; imm_pl(pk,:)=0;
    imm_rh=imm; imm_rh(setdiff(1:size(imm,2),pk),:)=0;
    
    
    meanspectra = mean(spectra,2);      
    restspectra=mean(spectra(:,rest_ind),2);
    movespectra=mean(spectra(:,dg_ind),2); 

    % reconstructed
    spectra_rest_pl=exp(mean(squeeze(nspectra(:,rest_ind))'*mm*imm_pl,1))'.* meanspectra;
    spectra_dg_pl=exp(mean(squeeze(nspectra(:,dg_ind))'*mm*imm_pl,1))'.*meanspectra;

    spectra_rest_rh=exp(mean(nspectra(:,rest_ind)'*mm*imm_rh,1))'.*meanspectra;
    spectra_dg_rh=exp(mean(nspectra(:,dg_ind)'*mm*imm_rh,1))'.*meanspectra;

    subplot('position',[.08 .34 .25 .13]), 
    semilogy(f,restspectra,'k'), 
    hold on, semilogy(f,movespectra,'r'), 
    axis tight, set(gca,'xtick',[])
    text(100, mean(get(gca,'ylim'))/4,'raw spectra','FontSize',8)
    title(['dg' num2str(dtype) ' move (red) vs. rest (black) Power Spectra'])
    dg_figfix, box off
    %
    subplot('position',[.08 .21 .25 .13]), semilogy(f,spectra_rest_pl,'k'), hold on, semilogy(f,spectra_dg_pl,'r'), axis tight, set(gca,'xtick',[])
    text(100, mean(get(gca,'ylim'))/4,'no rhythms','FontSize',8)
    ylabel('\mu V')
    dg_figfix, box off
    %
    subplot('position',[.08 .08 .25 .13]), semilogy(f,spectra_rest_rh,'k'), hold on, semilogy(f,spectra_dg_rh,'r'), axis tight
    text(100, mean(get(gca,'ylim'))/4,'rhythms only','FontSize',8)
    xlabel('Frequency')
    dg_figfix, box off
    clear *spectra

%% sample distributions with errorbars, etc.


 
for k=1:3
    band=bands(k,:);
    load(['data/' subject '/' subject '_fband_' num2str(band(1)) '_' num2str(band(2))],'pts','*block*','*type*','dz_*','tr_sc'), % load rhythm       
    [lnA_r, lnA_p, lnA_m, lnA_s, rhy_r, rhy_p, rhy_m, rhy_s, Zmd_r, Zmd_p, Zmd_m, Zmd_s]=dg_block_stats(lnA_blocks, rhythm_blocks, dz_dist, tr_sc, beh_types, baseline_type);
    %
    subplot('position',[.64 .48-.13*k .12 .12])
    kjm_errbar(1:6,rhy_m(dg_chan,:),rhy_s(dg_chan,:),rhy_s(dg_chan,:),bcol);
    set(gca,'xtick',1:6), set(gca,'xticklabel',{'d1','d2','d3','d4','d5','rest'})
    ylabel('\mu V')
    a=min(rhy_m(dg_chan,:)-rhy_s(dg_chan,:));
    b=max(rhy_m(dg_chan,:)+rhy_s(dg_chan,:));
    set(gca,'ylim',[a-.2*(b-a) b+.2*(b-a)])
    set(gca,'xlim',[0 7])
    if k==1, title('Rhythm amplitude'), ylabel({'4-8 Hz';'\mu V'}), elseif k==2, ylabel({'8-12 Hz';'\mu V'}), elseif k==3, ylabel({'12-20 Hz';'\mu V'}),end
    dg_figfix
    %
    subplot('position',[.82 .48-.13*k .12 .12])        
    kjm_errbar(1:6,Zmd_m(dg_chan,:),Zmd_s(dg_chan,:),Zmd_s(dg_chan,:),bcol);
    set(gca,'xtick',1:6), set(gca,'xticklabel',{'d1','d2','d3','d4','d5','rest'})
    ylabel('Z_{mod}')
    a=min(Zmd_m(dg_chan,:)-Zmd_s(dg_chan,:));
    b=max(Zmd_m(dg_chan,:)+Zmd_s(dg_chan,:));
    set(gca,'ylim',[a-.2*(b-a) b+.2*(b-a)])
    set(gca,'xlim',[0 7])
    if k==1, title('Phase-Amp Modulation'), end
    dg_figfix
    clear rhy_m rhy_s Zmd_m Zmd_s
end

    %
    subplot('position',[.42 .09 .12 .2])
    kjm_errbar(1:6,lnA_m(dg_chan,:),lnA_s(dg_chan,:),lnA_s(dg_chan,:),bcol);
    set(gca,'xtick',1:6), set(gca,'xticklabel',{'d1','d2','d3','d4','d5','rest'})
%     ylabel('Log Broadband, Z-score units')
    set(gca,'ylim',1.1*[min(lnA_m(dg_chan,:)-lnA_s(dg_chan,:)) max(lnA_m(dg_chan,:)+lnA_s(dg_chan,:))])
    set(gca,'xlim',[0 7])
    title('Broadband Amplitude'), ylabel('lnA')
    dg_figfix
%% legend
subplot('position',[.38 .5 .01 .01])
for k=1:6, hold on, plot(1,1,'-','color',bcol(k,:),'LineWidth',1),end, plot(1,1,'w-', 'LineWidth',2)
legend('d1','d2','d3','d4','d5','rest','Location', 'NorthEastOutside'), axis off

%% print figure

kjm_printfig(['figs/' subject '/' subject '_d' num2str(dtype) '_chan_' num2str(dg_chan) '_elec_fig'],[12 9])
