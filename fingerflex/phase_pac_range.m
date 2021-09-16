function [pac_matrix, amp_corr, bin_centers]=phase_pac_range(power,raw,srate,num_bins,fmax)
% function [pac_matrix, bin_centers]=phase_pac_range(power,raw,srate,num_bins,fmax)
% this function calculates the mean power in "num_bins" evenly spaced bins
% note that it explicitly normalizes for uneven density
% need to modify to return a reshuffling statistic

bin_edges=[-pi:(2*pi/num_bins):(pi)];
bin_centers=bin_edges(1:(num_bins))+pi/num_bins;

for f=fmax:-1:1;
    if mod(f,10)==0, disp(['on ' num2str(f) ' of ' num2str(fmax)]), end
    
    %create wavelet
    t=1:floor(5*srate/f);
    wvlt=exp(1i*2*pi*f*(t-floor(max(t)/2))/srate).*altgwin(max(t))'; %gaussian envelope
    
    %calculate convolution
    tconv=conv(wvlt,raw);
    tconv([1:(floor(length(wvlt)/2)-1) floor(length(tconv)-length(wvlt)/2+1):length(tconv)])=[]; %eliminate edges 
    
    %calculate pac matrix
    for k=1:num_bins
        t_ind=find(and(angle(tconv)<bin_edges(k+1),angle(tconv)>=bin_edges(k)));
        pac_matrix(f,k)=mean(power(t_ind));
    end
    
    %calculate amplitude correlation
    amp_corr(f)=corr(power,abs(tconv));

end


%
