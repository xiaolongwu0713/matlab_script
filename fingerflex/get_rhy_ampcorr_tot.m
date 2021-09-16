function get_rhy_ampcorr_tot(subject,band)

%% get amplitude correlation

load(['data/' subject '/' subject '_fband_' num2str(band(1)) '_' num2str(band(2))],'fband'),  
num_chans=size(fband,2);

% transform fband into appropriate distribution (i.e. from Raleigh to Gaussian)
fband=abs(fband).^.5;

ampcorr_tot=zeros(num_chans,num_chans);

    % rhythm coherence
    for k=1:(num_chans-1)
        for q=(k+1):num_chans
         ampcorr_tot(k,q)=mean(zscore(fband(:,k)).*zscore(fband(:,q)));
        end        
    end
        
    ampcorr_tot(num_chans,:)=0;
    ampcorr_tot=ampcorr_tot+ampcorr_tot';
    
save(['data/' subject '/' subject '_ampcorr_tot_' num2str(band(1)) '_' num2str(band(2))], 'ampcorr_tot', 'band')




