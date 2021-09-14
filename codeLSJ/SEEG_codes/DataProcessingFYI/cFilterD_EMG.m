function  [Data]=cFilterD_EMG(data,AC,Fs,k,OME)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove noise and bandpass the EMG signals
% By Li Guangye (liguangye.hust@gmail.com) @2016.04.28 @ SJTU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(OME)~=2
    error('The last varable shall be an 1X2 array, check the input!');
end
if k==1 || k==2    
%     omega=150/(Fs/2);W=omega/30;
%     [B,A]=iirnotch(omega,W);
%     Data(:,1:AC)=filtfilt(B,A,data(:,1:AC));
if k==1
    Data=data(:,1:AC);
end
    if k==2      
        Fo=50;    q=25;
        bw=(Fo/(Fs/2))/q;
        [B,A] = iircomb(Fs/Fo,bw,'notch'); % Note type flag 'notch'
        %          fvtool(B,A);
        Data(:,1:AC)=filtfilt(B,A,data(:,1:AC));      
    end  
    % Bandpass filter
    omega=[OME(1)/(Fs/2),OME(2)/(Fs/2)];
    [B,A]=butter(4,omega);
    Data(:,1:AC)=filtfilt(B,A,Data(:,1:AC));
end
if k==0
    omega=[0.3/(Fs/2),OME/(Fs/2)];
    [B,A]=butter(4,omega);
    Data(:,1:AC)=filtfilt(B,A,data(:,1:AC));
end
end