function [Pxx,Sxx_unscaled,w,units] = computepsd(Sxx,w,range,nfft,Fs)
%COMPUTEPSD  Compute the one-sided or two-sided psd from the power spectrum
%   Syntax: [Pxx,Sxx,W,UNITS] = COMPUTEPSD(Sxx,W,RANGE,NFFT,Fs) 
%
%   Inputs:
%    Sxx   - Two-sided power spectrum [Power]
%    W     - Frequency vector in rad/sample
%    RANGE - Determines if a 'onesided' or a 'twosided' Pxx and Sxx are returned
%    NFFT  - Number of frequency points
%    Fs    - Sampling Frequency
%
%   Outputs:
%    Pxx   - One-sided or two-sided PSD depending on range [Power/freq]
%    Sxx   - Half or whole power spectrum depending on range [Power] (not scaled by 2)
%    W     - Frequency vector [0, 2*Nyquist) or [0, Nyquist) depending on range,
%            units will be either rad/sample (if Fs is empty) or Hz (otherwise)
%    UNITS - Either 'rad/sample' or 'Hz' 

%   Author(s): R. Losada
%   Copyright 1988-2002 The MathWorks, Inc.
%   $Revision: 1.9 $  $Date: 2002/03/28 17:29:31 $ 

% Create a copy of Sxx because we want to return the unscaled (half or whole) power spectrum
Sxx_unscaled = Sxx(:); % Make sure Sxx_unscale, Sxx and Pxx are all columns
w = w(:); % Make sure we always returns a column vector for frequency

% Generate the one-sided spectrum if so wanted
if strcmp(range,'onesided'),
   if rem(nfft,2), % odd length nfft
      select = 1:(nfft+1)/2;
   else
      select = 1:nfft/2+1;
   end
   Sxx_unscaled = Sxx(select); % Take only [0,pi] or [0,pi)
   w = w(select);
   Sxx = [Sxx_unscaled(1); 2*Sxx_unscaled(2:end-1); Sxx_unscaled(end)]; % This is the one-sided spectrum [Power]
end

% Compute the PSD [Power/freq]
if ~isempty(Fs),
   Pxx = Sxx./Fs; % Scale by the sampling frequency to obtain the psd
   w = w.*Fs./(2.*pi); % Scale the frequency vector from rad/sample to Hz   
   units = 'Hz';  
else
   Pxx = Sxx./(2.*pi); % Scale the power spectrum by 2*pi to obtain the psd
   units = 'rad/sample';    
end

% [EOF] computepsd.m
