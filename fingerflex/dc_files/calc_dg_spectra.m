function [spectra]=calc_dg_spectra(data,pts);
%this function calculates the the spectra at time points in pts(:,2)
%kjm 12/07

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%parameters
samplefreq=1000;  %sampling frequency
bsize=1000;  %window size for spectral calculation
wt=hann(bsize);  %1-.5*cos window  -- use a hann window % wt=hamming(bsize);  %use a hamming wind
%load data
load ns_1k_1_300_filt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate spectra
disp('calculating power spectra')
spectra=zeros(300,size(data,2),size(pts,1));
for k=1:size(pts,1)
    if (mod(k, 100) == 0), fprintf(1, '%03d ', k); if (mod(k, 500) == 0), fprintf(1, '* /%d\r', size(pts,1)); end, end
    for m=1:size(data,2)
        [ts,f] = psd(data((pts(k,2)-floor(bsize/2)+1):(pts(k,2)+ceil(bsize/2)),m),bsize,samplefreq);
%         ts=(abs(fft(wt.*data((pts(k,2)-floor(bsize/2)+1):(pts(k,2)+ceil(bsize/2)),m)))).^2;
        spectra(:,m,k)=ts(2:301)./(nsfilt.^2)';
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
