
function  [f,m]=fre_check(Ndata,Fs)
N=length(Ndata);
% Ndata=Ndata()-mean(Ndata);
n=0:N-1;
y=fft(Ndata,N);%进行fft变换
y1=fftshift(y); %fftshift 转换
m=abs(y1)*2/N;%求信号的真实幅值
f=n*Fs/N-Fs/2; %进行对应的频率转换
 plot(f,m);%绘出频谱图
end
