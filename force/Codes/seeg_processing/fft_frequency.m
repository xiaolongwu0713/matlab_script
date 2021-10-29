% load('PF6_F_1(1).mat')
% ch1=Data(117,:);
% N=length(ch1); %信号长度
% Fs=2000; %采样频率
% dt=1/Fs; %采样间隔
% t=(0:(N-1))*dt;  % 时间序列
% %滤波
% filter_n=4;
% Wn=[0.5 245]/(Fs/2);
% [b,a]=butter(filter_n,Wn);
% y=filter(b,a,y2);
% % plot(t,ch1) 
% Y1= fft(ch1);
% P2 = abs(Y1/N);
% P1 = P2(1:N/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(N/2))/N;
% figure(1)
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
% figure(2)
% Y2= fft(y);
% p2 = abs(Y2/N);
% p1 = p2(1:N/2+1);
% p1(2:end-1) = 2*p1(2:end-1);
% f = Fs*(0:(N/2))/N;
% plot(f,p1)
% title('Single-Sided Amplitude Spectrum of X(t)(filtered)')
% xlabel('f (Hz)')
% ylabel('|p1(f)|')


% N=length(data_referenced_1(:,21)); %信号长度
N=length(y0);
Fs=2000; %采样频率
dt=1/Fs; %采样间隔
t=(0:(N-1))*dt;  % 时间序列
% plot(t,ch1) 
Y1= fft(y0);
P2 = abs(Y1/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(N/2))/N;
figure
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

