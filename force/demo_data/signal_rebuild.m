% seeg_ch107_p1=data_resized(:,15,107,1);
% seeg_ch107_p2=data_resized(:,1,107,2);
% seeg_ch107_p3=data_resized(:,32,107,3);
% seeg_ch107_p4=data_resized(:,4,107,4);
% seeg_ch107=zeros(12000,1);
% seeg_ch107=zeros(30000,4);
% seeg_ch107(:,1)=seeg_ch107_p1;
% seeg_ch107(:,2)=seeg_ch107_p2;
% seeg_ch107(:,3)=seeg_ch107_p3;
% seeg_ch107(:,4)=seeg_ch107_p4;
% seeg_ch107_res=resample(seeg_ch107,500,2000);

% emg_p1=emg_resized(:,15,1);
% emg_p2=emg_resized(:,1,2);
% emg_p3=emg_resized(:,32,3);
% emg_p4=emg_resized(:,4,4);
% emg_data=zeros(30000,4);
% emg_data(:,1)=emg_p1;
% emg_data(:,2)=emg_p2;
% emg_data(:,3)=emg_p3;
% emg_data(:,4)=emg_p4;
% emg_data_res=resample(emg_data,500,2000);
% 对emg数据做平滑处理
% emg_data_res_smooth=smooth(emg_data_res(:,1));
% plot(emg_data_res_smooth(:,1))
% hold on
% plot(emg_data_res(:,1))
% h  = fdesign.lowpass('N,F3dB', 4,10, 2000); % OME为低通截止频率：可取5hz
% Hd = design(h, 'butter');
% [B A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
% emg_data_res=filtfilt(B,A,double(emg_data_res));
% plot(emg_data_res_filtered(:,1))
% hold on
% plot(emg_data_res(:,1))

emg_p1=emg_resized(:,15,1);
emg_p2=emg_resized(:,1,2);
emg_p3=emg_resized(:,32,3);
emg_p4=emg_resized(:,4,4);
emg_data=zeros(30000,4);
emg_data(:,1)=emg_p1;
emg_data(:,2)=emg_p2;
emg_data(:,3)=emg_p3;
emg_data(:,4)=emg_p4;
emg_data_res=resample(emg_data,500,2000);
