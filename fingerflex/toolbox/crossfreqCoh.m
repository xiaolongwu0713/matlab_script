function [CRF,freqVec1,freqVec2] = crossfreqCoh(S1,S2,freqVec,Fs,nfft,width);
% function [CRF,freqVec1,freqVec2] = crossfreqCoh(S1,S2,freqVec,Fs,nfft,width);
%
% [CRF,freqVec1,freqVec2] = crossfreqCohHann(Data,Data,2:2:100,1200,2048,6);
% imagesc(freqVec1,freqVec2,CRF);axis xy
% xlim([0 100])
% 
%
% width = 6 or 7
%
% nfft = 512,1024, 2048, 4096, 8192, ... - Choose about 2*Fs

S1 = S1/max(S1);
S2 = S2/max(S2);

freqVec2 = freqVec';
for k=1:length(freqVec)
    fprintf('%d ',freqVec(k))
    
    % 1) E1=amplitude of S1 at freq=freqVec(k)
    %    uses hanning window taper 
    E1 = amplitudevec(freqVec(k),S1,Fs,width);      
    
    % 2) coherence of E1 with S2: Cxy=MSCOHERE(X,Y,WINDOW,NOVERLAP,NFFT,Fs)
    [CRF(k,:),freqVec1] = mscohere(E1,S2,hanning(nfft),nfft/2,nfft,Fs);
end
fprintf('\n');

CRF = CRF(:,1:floor(end/2));
freqVec1 = freqVec1(1:floor(end/2));

function y = amplitudevec(f,s,Fs,Ncycles)
% function y = amplitudevec(f,s,Fs,Ncycles)
%
% Return a vector containing the ampltiude as a
% function of time for frequency f. The energy
% is calculated using dtf and a Hanning taper. 
% s : signal
% Fs: sampling frequency

N = floor(Ncycles*Fs/f);
t = (1:N)/Fs;
Taper = hanning(N)';
 
y = abs(conv(s,Taper.*exp(i*2*pi*f.*(1:N)/Fs))).^2;
y = y(ceil(N/2):length(y)-floor(N/2));



