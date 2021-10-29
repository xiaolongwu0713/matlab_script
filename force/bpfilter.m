function fsignal = bpfilter(signal,order,lcfreq,hcfreq,fs)
signal=permute(signal,[2,1,3]); % filter along the first dimmension
Fs = fs;  % Sampling Frequency
N   = order;   % Order
Fc1 = lcfreq;   % First Cutoff Frequency
Fc2 = hcfreq;  % Second Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hd = design(h,'butter');
[b, a] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
fsignal = filtfilt(b,a,double(signal));
fsignal=permute(fsignal,[2,1,3]); % resume original order
return