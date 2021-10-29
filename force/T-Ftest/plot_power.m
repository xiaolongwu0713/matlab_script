% % clear; clc;
% % Data_raw = struct2cell(load('data_resized.mat'));
% % Data_raw=struct2cell(data_resized);
% % Data = cell2mat(Data_raw(1, 1));
% for a=1:110
% Data_32 = data_resized(:, :,2, a);
% Fs = 2000;
% filt_n =4;
% Wn=[90 100]/(Fs/2);
% [filter_b,filter_a]=butter(filt_n,Wn);
% for i = 1:size(Data_32, 2)
%   Data_32(:, i) = filter(filter_b,filter_a, Data_32(:, i));
% end
% Data_32_aver = mean(Data_32, 2);
% y = zeros(30000, 10);
% for i = 1: size(Data_32, 2)
%   y(:, i) = (Data_32(:, i) - Data_32_aver).^2;
% end
% A = 1/9 * sum(y, 2);
% start = A(1:2000);
% % ending = A(9001:10000);
% R = 1/2000 * (sum(start));
% signal = (A - R) ./ R;
% % temp = zeros(31, 800);
% % for j = 1:30
% %   temp = mTypeTwo{1, j} + temp;
% % end
% % data_matrix = temp ./ 30;
% % data_channel = data_matrix(31, :);
% figure
% plot(signal)
% saveas(gcf,['./','tf_mine',num2str(a),'.jpg'])
% end
% %specgram(signal(1001: 9000), 128, 1000, 128, 96);
% %colorbar();
% %caxis([-10, 10])
% %spectrogram(data_channel, 32, 200, 32, 24);

Fs=2000;
h  = fdesign.lowpass('N,F3dB', 4, 10, Fs); % OME为低通截止频率：可取5hz
Hd = design(h, 'butter');
[B A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
broadband_gamma_range = [60 140];
% for i=1:110
% band-pass filtering the signal with a Butterworth filter of order 6
broadband_gamma_signal = prep_bpfilter(double(data_resized(:,[1:20,31:40],69,1)), 6, broadband_gamma_range(1), broadband_gamma_range(2), Fs);

% taking the envelope of the signal using the absolute value of the 
% Hilbert transform
envelope_of_broadband_gamma = abs(hilbert(single(broadband_gamma_signal)));
figure
% plot(envelope_of_broadband_gamma(:,1),'r--','linewidth',1.5);
% hold on
% the square of the envelope gives us the power of the signal
power_of_broadband_gamma = envelope_of_broadband_gamma.^2;
% power_of_broadband_gamma=mean(power_of_broadband_gamma,2);
% power_of_broadband_gamma=filtfilt(B,A,double(power_of_broadband_gamma));
% basel=mean(power_of_broadband_gamma((end-4000+1):end,:),2);
% basel_std=std(basel);
% basel_median=median(basel);
% Fs=2000;
% WindowLength=0.1*Fs;
% SlideLength=0.05*Fs;
% for j=1:299;
%       if j==1
%             power_of_gamma(:,j)=power_of_broadband_gamma(((j-1)*WindowLength+1):(j*WindowLength));
%         else
%             power_of_gamma(:,j)=power_of_broadband_gamma(((j-1)*SlideLength+1):((j-1)*SlideLength+WindowLength));
%       end
%       power_of_gamma_median(j)=median(power_of_gamma(:,j));
%     activation_val(j)=(power_of_gamma_median(j)-basel_median)/basel_std;
% end
% t=0:15/299:(15-1/299);
% plot(t,activation_val,'-');
plot(power_of_broadband_gamma(:,1),'-');
saveas(gcf,['./','high_freq(1)_',num2str(i),'.jpg'])
% end