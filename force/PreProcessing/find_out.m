% h  = fdesign.bandpass('N,F3dB1,F3dB2', 6, 0.5,400, Fs);
%     Hd = design(h,'butter');
%     [B, A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
% subplot(4,1,2)
% a=filtfilt(B,A,mean(data_resized_1(:,[1:20,31:40],69,3),2));
% plot(a)
% title('去掉0.5')
% subplot(4,1,3)
% b=cFilterD_EEG(mean(data_resized_1(:,[1:20,31:40],69,3),2),1,Fs,2,[0.5 400]);
% plot(b)
% title('去掉0.5并去工频')
% subplot(4,1,4)
% plot(mean(data_resized(:,[1:20,31:40],69,3),2));
% title('一开始就滤波了')
% subplot(4,1,1)
% plot(mean(data_resized_1(:,[1:20,31:40],69,3),2));
% title('原始没有滤波')

 h  = fdesign.bandpass('N,F3dB1,F3dB2', 6, 0.5,10, Fs);
    Hd = design(h,'butter');
    [B, A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
    a=filtfilt(B,A,mean(data_resized(:,[1:20,31:40],69,1),2));
    plot(a)
    figure
    plot(mean(data_resized(:,[1:20,31:40],69,1),2))