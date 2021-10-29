clear; clc;
% Data_raw = struct2cell(load('data_resized.mat'));
% Data_raw=struct2cell(data_resized);
% Data = cell2mat(Data_raw(1, 1));
Data_32 = Data(:, :, 32);
Fs = 1000;
filt_n =4;
Wn=[60 100]/(Fs/2);
[filter_b,filter_a]=butter(filt_n,Wn);
for i = 1:size(Data_32, 2)
  Data_32(:, i) = filter(filter_b,filter_a, Data_32(:, i));
end
Data_32_aver = mean(Data_32, 2);
y = zeros(10000, 100);
for i = 1: size(Data_32, 2)
  y(:, i) = (Data_32(:, i) - Data_32_aver).^2;
end
A = 1/99 * sum(y, 2);
start = A(1:1000);
ending = A(9001:10000);
R = 1/1000 * (sum(start));
signal = (A - R) ./ R;
% temp = zeros(31, 800);
% for j = 1:30
%   temp = mTypeTwo{1, j} + temp;
% end
% data_matrix = temp ./ 30;
% data_channel = data_matrix(31, :);

plot(signal)
%specgram(signal(1001: 9000), 128, 1000, 128, 96);
%colorbar();
%caxis([-10, 10])
%spectrogram(data_channel, 32, 200, 32, 24);