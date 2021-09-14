load('P2_H2_1_Raw_Glove.mat');
subplot(2,1,1);
plot(Data.data(1:3000,2));
X=length(Data.data(:,2));
% Data.data(:,2)=smooth(1:X,Data.data(:,2),7,'rloess');% robust loess method with span 5
Data.data(:,2)=smooth(Data.data(:,2),7);% smooth with moving average
% Data.data(:,2)=smooth([1:X],Data.data(:,2),7,'sgolay');%smooth the signal using the avitzky-Golay method  
subplot(2,1,2);
plot(Data.data(1:3000,2));
