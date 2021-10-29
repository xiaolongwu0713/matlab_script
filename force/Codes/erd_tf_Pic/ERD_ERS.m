             Fs=2000;
h  = fdesign.lowpass('N,F3dB', 4,4, Fs); % OME为低通截止频率：可取5hz
Hd = design(h, 'butter');
[B A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);

t=(0:29999)*(1/2000);
ch=70;
trial=[1:20,31:40];
protocal=1;
end_of_task=7.5;
ERD=mean(power_of_lowfreq_resized(:,trial,ch,protocal),2);
ERD_basel=mean(ERD((end-4000+1):end));
ERD=(ERD-ERD_basel)./ERD_basel;
ERD=filtfilt(B,A,double(ERD));
ERS=mean(power_of_gamma_resized(:,trial,ch,protocal),2);
ERS_basel=mean(ERS((end-4000+1):end));
ERS=(ERS-ERS_basel)./ERS_basel;
ERS=filtfilt(B,A,double(ERS));
plot(t,ERD*100,'b','linewidth',2)
hold on
plot(t,ERS*100,'r','linewidth',2)
plot([2 2],ylim,'black--','linewidth',1.5)
plot([end_of_task end_of_task],ylim,'black--','linewidth',1.5)
hold off
xlabel('Time(s)','fontsize',12,'fontweight','bold')
ylabel('[%]','fontsize',12,'fontweight','bold')
legend('low frequency: 8~30Hz','gamma: 60~140Hz');
% ylim([0.2 2.7])
% rng default
% Fs = 2000;
% t = 0:1/Fs:15-1/Fs;
% x=ERD;
% for i=1:300
% N = 10;
% xdft = fft(x(1+(i-1)*N:i*N));
% xdft = xdft(1:N/2+1);
% psdx = (1/(Fs*N)) * abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% freq = 8:Fs/10:30;
% a(:,i)=median(10*log10(psdx));
% % figure
% % plot(freq,median(10*log10(psdx)))
% % grid on
% % title('Periodogram Using FFT')
% % xlabel('Frequency (Hz)')
% % ylabel('Power/Frequency (dB/Hz)')
% end
