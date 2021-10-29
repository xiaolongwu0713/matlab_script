Fs=1000;
h  = fdesign.lowpass('N,F3dB', 6,4, Fs); %N=6 order, F3dB at 4hz point.
Hd = design(h, 'butter');
[B A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);

t=(0:14999)*(1/1000);
ch=70;
trial=[1:20,31:40];
end_of_task=7.5;
epoch=load_data(1,'move2');
bandl=[8 30];bandh=[60 140];
%bpfilter(signal,order,lcfreq,hcfreq,fs)
epochl=bpfilter(epoch,10,bandl(1),bandl(2),1000); 
figure();subplot(2,1,1);pspectrum(epoch(110,:,1));subplot(2,1,2);pspectrum(epochl(110,:,1));
tmp= abs(cubeHilbert(single(epochl)));
powerl= tmp.^2;
ERD=mean(powerl(ch,:,:),3);
ERD_basel=mean(ERD((end-4000+1):end));
ERD=(ERD-ERD_basel)./ERD_basel;
ERD=filtfilt(B,A,double(ERD));

epochh=bpfilter(epoch,10,bandh(1),bandh(2),1000); 
figure();subplot(2,1,1);pspectrum(epoch(110,:,1));subplot(2,1,2);pspectrum(epochh(110,:,1));
tmp= abs(cubeHilbert(single(epochh)));
powerh= tmp.^2;
ERS=mean(powerh(ch,:,:),3);
ERS_basel=mean(ERS((end-4000+1):end));
ERS=(ERS-ERS_basel)./ERS_basel;
ERS=filtfilt(B,A,double(ERS));

figure()
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
