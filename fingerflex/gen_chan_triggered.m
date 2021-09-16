function gen_chan_triggered(subject,dg_chan,dtype,band)
% generates event-triggered responses


%% settings
    sf=.0298; %scalefactor from amp units to microvolts
%     band = [12 20]; % use beta to get average
    win = [-1000 2000]; % window for STAs


%% get rhythm and broadband
    load(['data/' subject '/' subject '_fband_' num2str(band(1)) '_' num2str(band(2))],'fband','pts','*block*','*type*','dz_*','tr_sc'), % load rhythm
    load(['data/' subject '/' subject '_pc_ts'],'lnA') % loads lnA (broadband)

%% select only data relevant for dg_chan
    % rhythm and broadband
    fband=fband(:,dg_chan);          
    lnA=lnA(:,dg_chan);            
    % raw data
    load(['data/' subject '/' subject '_fingerflex'],'data'), data=car(data);
    data=sf*data(:,dg_chan);
    % pallette
%     load(['data/' subject '/' subject '_pac_all']), pac_matrix=squeeze(pac_matrix(:,:,dg_chan));
    %
    lnA_blocks=lnA_blocks(:,dg_chan);     
    rhythm_blocks=rhythm_blocks(:,dg_chan);
    mod_blocks=mod_blocks(:,dg_chan);
    dz_dist=dz_dist(:,dg_chan);

%% generate time-frequency traces
    kpts=pts(find(pts(:,3)==dtype),1);
    kpts=[kpts(1) kpts(find(diff(kpts)>2000)+1)'];
    tf=dg_tf_sta_pwr(data,kpts,win);

%% generate STAs for different signals
    lnA_sta=dg_sta(pc_clean(zscore(lnA)),kpts,win);
    %
    m0=mean(abs(fband));s0=std(abs(fband));
    fband_sta=dg_sta(abs(fband).^.5,kpts,win);fband_sta=((fband_sta.^2)-m0)/s0; clear m0 s0 %put in z-score units
    %
    data_sta=dg_sta(data,kpts,win);

    
%% decoupled stuff, spectra
    load(['data/' subject '/' subject '_decoupled'],'f','spectra','nspectra','pc_vecs')
    mm=squeeze(pc_vecs(:,dg_chan,:))'; clear pc_vecs %mixing matrix
    spectra=(sf^2)*squeeze(spectra(f,dg_chan,:));
    nspectra=squeeze(nspectra(f,dg_chan,:));    

%% save data    
    save(['data/' subject '/' subject '_chan_' num2str(dg_chan) '_triggered_d' num2str(dtype)])


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function sta=dg_sta(dt,events,win)

sta=zeros(length(win(1):win(2)),1);

for k = 1:length(events)
    sta=sta+dt(events(k)+[win(1):win(2)]);
end
sta=sta/k;


    



