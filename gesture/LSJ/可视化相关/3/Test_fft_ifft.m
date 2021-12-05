% clear;clc;
% Fs = 1000;            % Sampling frequency                    
% T = 1/Fs;             % Sampling period       
% L = 500;             % Length of signal
% t = (0:L-1)*T;        % Time vector
% S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
% X = S; %+ 2*randn(size(t));
% figure(1);
% plot(X);
% fft_X = fft(X);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P2 = abs(fft_X/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% figure(2);
% fs = Fs*(0:(L/2))/L;
% plot(fs, P1);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ifft_X = ifft(fft_X);
% figure(1);hold on;
% plot(ifft_X);

%%
%%% 频谱分辨率 = 1 / 时间分辨率.
clear;clc;
Fs = 1000;                
T = 1/Fs;      
L = 500;         
t = (0:L-1)*T;        
S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
X = S; %+ 2*randn(size(t));
figure(1);
plot(X);
fft_X = fft(X);

P2 = abs(fft_X/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
figure(2);
fs = Fs*(0:(L/2))/L;
plot(fs, P1);

Ax = abs(fft_X);
Px = angle(fft_X);
Ax(26) = Ax(26)*1.2;
Ax(476) = Ax(476)*1.2;
fft_X_per =  Ax.*cos(Px) + Ax.*sin(Px)*1i;
ifft_X = ifft(fft_X_per);
figure(1);hold on;
plot(real(ifft_X));









