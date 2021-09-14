function [EMG_Marker]=Cal_Latency_EMG_V3(data,fea_label,Fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Liguangye (liguangye.hust@gmail.com) @2016.09.05 @SJTU
% Function used in the function "ResizeData"
% data is the EMG signal(N*1) and the same length with fea_label(trigger)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(data)~=length(fea_label)
    error('EMG data and the trigger label shall be in the same length!!');
end

data2=smooth(abs(data),0.025*Fs);
index=find(fea_label~=0);
EMG_Marker=zeros(length(fea_label),1);
for i=1:length(index)
    flag=0;
    tskd=data(index(i):index(i)+5*Fs);
    alarm=envelop_hilbert_v2(tskd,round(0.025*Fs),1,round(0.05*Fs),0);
    robustIndex=index(i)+min(find(alarm==1))-round((0.025*Fs-1)/2);
    for j=index(i)+0.25*Fs:(index(i)+4.5*Fs)
        tskd=data2(index(i):index(i)+5*Fs);
        meanval=mean(tskd);%%%%   
        if data2(j)>=1.5*meanval && flag==0
            if j>robustIndex
                EMG_Marker(robustIndex)=1;
            else
                EMG_Marker(j)=1;
            end
            flag=1;
        end
    end
end
end
            
    


