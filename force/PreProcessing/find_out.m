% h  = fdesign.bandpass('N,F3dB1,F3dB2', 6, 0.5,400, Fs);
%     Hd = design(h,'butter');
%     [B, A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
% subplot(4,1,2)
% a=filtfilt(B,A,mean(data_resized_1(:,[1:20,31:40],69,3),2));
% plot(a)
% title('ȥ��0.5')
% subplot(4,1,3)
% b=cFilterD_EEG(mean(data_resized_1(:,[1:20,31:40],69,3),2),1,Fs,2,[0.5 400]);
% plot(b)
% title('ȥ��0.5��ȥ��Ƶ')
% subplot(4,1,4)
% plot(mean(data_resized(:,[1:20,31:40],69,3),2));
% title('һ��ʼ���˲���')
% subplot(4,1,1)
% plot(mean(data_resized_1(:,[1:20,31:40],69,3),2));
% title('ԭʼû���˲�')

 h  = fdesign.bandpass('N,F3dB1,F3dB2', 6, 0.5,10, Fs);
    Hd = design(h,'butter');
    [B, A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
    a=filtfilt(B,A,mean(data_resized(:,[1:20,31:40],69,1),2));
    plot(a)
    figure
    plot(mean(data_resized(:,[1:20,31:40],69,1),2))