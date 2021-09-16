function get_coh_tot(subject,band)

%% get rhythm & overall coherence

load(['data/' subject '/' subject '_fband_' num2str(band(1)) '_' num2str(band(2))],'fband'),  
num_chans=size(fband,2);

coh_tot=zeros(num_chans,num_chans);

    % rhythm coherence
    for k=1:(num_chans-1)
        for q=(k+1):num_chans
         coh_tot(k,q)=mean(exp(1i*(angle(fband(:,k))-angle(fband(:,q)))),1);
        end        
    end
        
    coh_tot(num_chans,:)=0;
    coh_tot=coh_tot+coh_tot';
    
save(['data/' subject '/' subject '_coh_tot_' num2str(band(1)) '_' num2str(band(2))], 'coh_tot', 'band')




