function get_lnAcorr_tot(subject)

%% get amplitude correlation

load(['data/' subject '/' subject '_pc_ts'],'lnA'),  
num_chans=size(lnA,2);


ampcorr_tot=zeros(num_chans,num_chans);

    % rhythm coherence
    for k=1:(num_chans-1)
        for q=(k+1):num_chans
         lnAcorr_tot(k,q)=mean(zscore(lnA(:,k)).*zscore(lnA(:,q)));
        end        
    end
        
    lnAcorr_tot(num_chans,:)=0;
    lnAcorr_tot=lnAcorr_tot+lnAcorr_tot';
    
save(['data/' subject '/' subject '_lnAcorr_tot'], 'lnAcorr_tot')




