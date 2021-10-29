function  [Data_1]=cFilterD_EEG_del(data,AC,Fs,k,OME)
% k=1 or 0;
% 50Hz notch filter
if k==1 || k==2
    Data_1=data(:,1:AC);
    if length(OME)~=2
        error('The last varable shall be an 1X2 array, check the input!');
    end
     
    if k==2
        %IIRCOMB filter
       Fo=50;    q=25; % ��Fs���ź����޳���Fo���ź� ������������Ϊq
       bw=(Fo/(Fs/2))/q;
        [B,A] = iircomb(Fs/Fo,bw,'notch'); % Note type flag 'notch'
%         fvtool(B,A)
%         Wo1=50/(Fs/2);
%         BW1=Wo1/35;
%         [B,A]=iircomb(Wo1,BW1);
        %            fvtool(B,A);
        Data_1=filtfilt(B,A,Data_1);
%         Wo2=150/(Fs/2);
%         BW2=Wo2/35;
%         [B,A]=iirnotch(Wo2,BW2);
%          Data=filtfilt(B,A,Data);
    end
     % Bandpass filter
    h  = fdesign.bandpass('N,F3dB1,F3dB2', 6, OME(1),OME(2), Fs);
    Hd = design(h,'butter');
    [B, A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
%     fvtool(B,A)
    Data_1=filtfilt(B,A,Data_1);
    
end
if k==0
    if length(OME)>1
        error('This is low pass filter, OME length shall be 1!');
    end

    h  = fdesign.lowpass('N,F3dB', 4, OME, Fs);
    Hd = design(h, 'butter');
    [B A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);%% this is new
%     fvtool(b,a);
    Data_1=filtfilt(B,A,data(:,1:AC));
end
end