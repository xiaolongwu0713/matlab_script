
function  [f,m]=fre_check(Ndata,Fs)
N=length(Ndata);
% Ndata=Ndata()-mean(Ndata);
n=0:N-1;
y=fft(Ndata,N);%����fft�任
y1=fftshift(y); %fftshift ת��
m=abs(y1)*2/N;%���źŵ���ʵ��ֵ
f=n*Fs/N-Fs/2; %���ж�Ӧ��Ƶ��ת��
 plot(f,m);%���Ƶ��ͼ
end
