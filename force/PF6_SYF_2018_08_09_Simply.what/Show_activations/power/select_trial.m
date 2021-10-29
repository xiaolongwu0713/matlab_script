 for i=1:10
power_p2_ch69(:,i)=power_of_broadband_gamma_1(triggerseeg_1(p2(i)):triggerseeg_1(p2(i))+30000-1,4);
 end
Hd = design(h, 'butter');
[B A] = sos2tf(Hd.sosMatrix,Hd.scaleValues);
power_1_2_69_filtered=filtfilt(B,A,double(power_p2_ch69));