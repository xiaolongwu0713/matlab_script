% load('G:\毕业设计备份\毕业设计\Plot_Topography\Plot_Topography\PF6_SYF_2018_08_09_Simply\SEEG_Data\data_resized.mat');
CN=22; %选取第21个通道
trial=[1:20,31:40];
% T=15;
seeg_p1=mean(data_resized(:,trial,CN,1),2);
Fs=2000;
Time=15;
Ts=0.5;
slide_length=round(Fs*Ts/2); %每次滑动500个数据点
Window_length=round(Ts*Fs); %窗长1000个数据点
DF=[8,30,60,140];%%Segment of frequency band
N=length(DF)/2;%多少个频段 此处是两个 低频段和gamma段
pLEN=513; %length(psd)
segSEQ=round(DF*pLEN*2/Fs);
LENW=(Time-Ts)*2/Ts+1;%窗的个数
nfft=1024;
ARPSD_base=zeros(pLEN,1);
threeArray_1=zeros(pLEN,length(CN),LENW);
threeArray_2=zeros(N,length(CN),LENW);
nData1=seeg_p1;
 for j=1:LENW
    if j==1
        basedata=nData1(1:Window_length,:);
    end
    if j>1 && j<=LENW
        basedata=nData1((j-1)*slide_length+1:(j-1)*slide_length+Window_length,:);
    end
    for m=1:length(CN)
        ARPSD_base(:)=pburg(basedata(:,1),40,nfft,Fs);                
        threeArray_1(:,m,j)=ARPSD_base;
    end
    for r=1:N                
    threeArray_2(r,:,j)=mean(10*log10(threeArray_1(segSEQ(2*r-1):segSEQ(2*r),:,j)));
    end
 end
 

low_freq=squeeze(threeArray_2(1,1,:));
low_freq_basel=mean(low_freq((end-3):end));
low_freq=log10(low_freq/low_freq_basel);
gamma=squeeze(threeArray_2(2,1,:));
gamma_basel=mean(gamma((end-3):end));
gamma=log10(gamma/gamma_basel);
plot(low_freq,'b','linewidth',1.5)
hold on
plot(gamma,'r','linewidth',1.5)







