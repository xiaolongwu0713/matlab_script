%% process all together
%  process pipline.
Inf = [2, 1000; 3, 1000; 4, 1000; 5, 1000; 7, 1000; 8, 1000; 9, 1000; 10, 2000; % 11, 500; 12, 500;
       13, 2000;  16, 2000; 17, 2000; 18, 2000; 19, 2000; 20, 1000; 21, 1000; 22, 2000; 23, 2000; % 14, 2000;
       29, 2000; 30, 2000; 31, 2000; 32, 2000; 34, 2000; 35, 1000; % 28, 2000; 33,    24, 2000; 25, 2000; 26, 2000; 
       36, 2000; 37, 2000; 41,2000;
       ];
%goodSubj = [1,2,3,8,9,12,16,18,21,22,26];
goodSubj = [8,];
Inf = Inf(goodSubj,:);

for i = 1 : size(Inf, 1)
    pn = Inf(i, 1);
    Fs = Inf(i, 2);
    %%
    % 找到 trigger 向量.
    % EMG 信号的预处理.
    % 剔除噪声通道.
     subInfo = config(pn);
%     
     preprocessing1(pn, Fs, subInfo);
    %%
    % SEEG 信号预处理.
    % 滤波, 重参考, trigger 对齐为切片做准备.
    
     %preprocessing2(pn, 1000);
    %%
    % preprocess for DeepConvNet.
%     preprocessing3(pn, 1000);
    
%     pre_3_psd_v2(pn, 1000)
    
    %pre_3_psd_v3(pn)
end






%% process individually

%pn=5;
%Fs=1000;
%subInfo = config(pn);
%preprocessing1(pn, 1000, subInfo)
%preprocessing2(pn, 1000)

