function pc1=dg_tf_pwr_rm(data,pcvec1,f0)

fmax=200;
srate=1000;


tf=zeros(length(data),200);
winsize=50000; 


    
for freq=fmax:-1:1;
    if mod(freq,50)==0, disp(['on ' num2str(freq) ' of ' num2str(fmax)]), end
    t=1:floor(5*srate/freq);
    %create wavelet
%     wvlt=exp(i*2*pi*freq*t/srate).*hann(max(t))';  %1-.5*cos envelope
%     wvlt=exp(i*2*pi*freq*t/srate).*hamming(max(t))'; %hamming envelope
    wvlt=exp(1i*2*pi*(freq/srate)*(t-floor(2.5*srate/freq))).*exp(-((t-floor(2.5*srate/freq)).^2)/(2*(srate/freq)^2)); %gaussian
    %calculate convolution
    tconv=conv(wvlt,data);
    tconv([1:(floor(length(wvlt)/2)-1) floor(length(tconv)-length(wvlt)/2+1):length(tconv)])=[]; %eliminate edges 
    tconv=abs(tconv).^2;
    if mean(tconv)==0, error('mean power 0','mean power 0'),end  %if there is some problem
    tconv=tconv/mean(tconv);  %norm step
    tf(:,freq)=tconv;
end


pc1=0*data;

% %Had to break it up b/c of memory
% pc1=log(tf)*pcvec1;
% pc2=log(tf)*pcvec2;
for k=1:floor(length(data)/winsize)
    pc1(((k-1)*winsize+1):(k*winsize))=log(tf(((k-1)*winsize+1):(k*winsize),f0))*pcvec1;
end
pc1(((k)*winsize+1):end)=log(tf(((k)*winsize+1):end,f0))*pcvec1;