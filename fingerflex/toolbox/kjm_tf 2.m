function tf=kjm_tf(data,srate,freqs)
% function tf=kjm_tf(data,srate,freqss) generate complex time-frequency
%   analysis in range freqs
%
% kjm 3/2015

%%

tf=zeros(length(data),length(freqs));
    
for tmp=1:length(freqs)
    freq=freqs(tmp);

    %create wavelet
    t=1:floor(9*srate/freq); tmid=floor(max(t)/2);
    wvlt=exp(1i*2*pi*(freq/srate)*(t-tmid)).*exp(-((t-tmid).^2)/(2*(srate/freq)^2)); %gaussian

    %calculate convolution
    tconv=conv(wvlt,data);
    tconv([1:(floor(length(wvlt)/2)-1) floor(length(tconv)-length(wvlt)/2+1):length(tconv)])=[]; %eliminate edges 

    tf(:,tmp)=tconv;
end