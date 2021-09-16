function [Zmd0_r,  lnA0_r,  rhy0_r, Zmdrest_m] = gen_shift_bars(subject)


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

%% load data
    band = [12 20];
    %
    load(['data/' subject '/' subject '_fingerflex'],'brain','locs','elec_regions') % load brain
    load dg_colormap
    load(['data/' subject '/' subject '_fband_' num2str(band(1)) '_' num2str(band(2))],'pts','*block*','*type*','dz_*','tr_sc'), % load rhythm       
    [lnA_r, lnA_p, lnA_m, lnA_s, rhy_r, rhy_p, rhy_m, rhy_s, Zmd_r, Zmd_p, Zmd_m, Zmd_s]=dg_block_stats(lnA_blocks, rhythm_blocks, dz_dist, tr_sc, beh_types, baseline_type);
    %
    
%% identify cortical regions
    % csites={'hand','front','occ','temp','pari'};
    % csites={'M1d','S1d','MSv','front','occ','temp','pari'};
    % csites={'M1d','S1d','hand','MSv','front','temp','pari'};
    csites={'M1d','S1d','MSv','front','temp','pari'};
    numsites=length(csites);

    hand_code=find(or(elec_regions==1, elec_regions==3));
    % hand_code=find(elec_regions==1);
    M1d_code=find(elec_regions==1);
    S1d_code=find(elec_regions==3);
    MSv_code=find(elec_regions==4);
    front_code=find(elec_regions==6);
    occ_code=find(elec_regions==9);
    temp_code=find(elec_regions==8);
    pari_code=find(elec_regions==7);

%%
figure

meas_types={'lnA','rhy','Zmd','Zmdrest'};
for q=1:3
    for k = 1:numsites
        % find region
        el2use=eval([csites{k} '_code']);

        % find measurement parameters        
        if isempty(el2use)~=1
            eval(['tmp_r=' meas_types{q} '_r(el2use,2);'])
            [tmp,m_ind] = max(abs(tmp_r));
            eval([meas_types{q} '0_r(k)=tmp_r(m_ind);'])
        else
            eval([meas_types{q} '0_r(k)=NaN;'])
        end
    end
    
%     subplot(1,5,q), 
subplot('position',[.05+(q-1)*.2  0.1 .15 .8]), 
    plt=eval([meas_types{q} '0_r']);
    hold on, plot((length(csites)+.9)+[0 0],.01*[-1 1],'w.')        
        kjm_errbar(1:numsites,plt,NaN*[1:numsites],NaN*[1:numsites],...
        [1-[1:numsites]'/numsites 0*[1:numsites]' [1:numsites]'/numsites],...
        [1 0 0]),
    for k=1:numsites
        hold on, plot(k,plt(k),'k.','Markersize',25)
        hold on, plot(k,plt(k),'.','Color', [1-k/numsites 0 k/numsites],'Markersize',22)
    end
    box off
    hold on, plot([0 (length(csites)+1)],[0 0],'k-')
    set(gca,'xlim',[0 (length(csites)+1)],'xtick',[],'XColor',[.99 .99 .99])
    title(meas_types{q})
end


% for Zmod rest
for k = 1:numsites
    % find region
    el2use=eval([csites{k} '_code']);

    if isempty(el2use)~=1    
        % find measurement parameters
        tmp_m=Zmd_m(el2use,6);
        tmp_s=Zmd_s(el2use,6);    
        [tmp,m_ind] = max(abs(tmp_m));
        Zmdrest_m(k)=tmp_m(m_ind);
        Zmdrest_s(k)=tmp_s(m_ind);
    else
        Zmdrest_m(k)=NaN;
        Zmdrest_s(k)=NaN;        
    end
end

% subplot(1,5,4), 
subplot('position',[.65  0.1 .15 .8]), 
    plt=Zmdrest_m;
    hold on, plot((length(csites)+.9)+[0 0],.01*[-1 1],'w.')
        kjm_errbar(1:numsites,Zmdrest_m,Zmdrest_s,Zmdrest_s,...
        [1-[1:numsites]'/numsites 0*[1:numsites]' [1:numsites]'/numsites],...
        [0 1 0]),  
    for k=1:numsites
        hold on, plot(k,plt(k),'k.','Markersize',25)
        hold on, plot(k,plt(k),'.','Color', [1-k/numsites 0 k/numsites],'Markersize',22)
    end
    box off
    hold on, plot([0 (length(csites)+1)],[0 0],'k-')
    set(gca,'xlim',[0 (length(csites)+1)],'xtick',[],'XColor',[.99 .99 .99])
    title(meas_types{4})


% % legend(csites,'Location','NorthWest')
% % anatomic classification
% msize=20;
% % subplot(1,5,5),     
% subplot('position',[.8  0.02 .19 .95]), 
%     ctmr_gauss_plot(brain,[0 0 0],0)
%     el_add_popout(locs(elec_regions==0,:),.85*[1 1 1],msize,vth,vph) % undetermined
%     el_add_popout(locs(elec_regions==1,:),'b',msize,vth,vph) % M1
%     el_add_popout(locs(elec_regions==2,:),.85*[1 1 1],msize,vth,vph) % M/S
%     el_add_popout(locs(elec_regions==3,:),'g',msize,vth,vph) % S1
%     el_add_popout(locs(elec_regions==4,:),'y',msize,vth,vph) % ventral M/S
%     el_add_popout(locs(elec_regions==5,:),.85*[1 1 1],msize,vth,vph) % foot
%     el_add_popout(locs(elec_regions==6,:),'r',msize,vth,vph) % frontal
%     el_add_popout(locs(elec_regions==7,:),'m',msize,vth,vph) % parietal
%     el_add_popout(locs(elec_regions==8,:),'k',msize,vth,vph) % temporal
%     el_add_popout(locs(elec_regions==9,:),.85*[1 1 1],msize,vth,vph) % occipital   
%     loc_view(vth,vph)    
%     title('areas')
    
% %%    
 exportfig(gcf,['figs/' subject '/' subject '_shift_bars'], 'format', 'png', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 12, 'Height', 1.6); 
   