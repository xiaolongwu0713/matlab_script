%%% p10_0908 caxis([-10,10]);
%%% p41_0916
clear;clc;
set(0,'defaultfigurecolor','w');
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F0_p4_0916.mat';
load(FEA_PATH, 'features_root_F0');  %% shape: (samples, 1, chns, time)
[Samples, ~, channelNum, TPoints] = size(features_root_F0);
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F2_p4_0916.mat';
load(FEA_PATH, 'features_root_F2');  %% shape: (samples, 1, chns, time)
VAR_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V3_p4_0916.mat';
load(VAR_PATH, 'testLabel');
testlabel = [];
for i = 1:Samples
    testlabel = [testlabel find(testLabel(i,:)==1)];
end
classNum = 5;
C = [5 1 2 3 4];
figure(1);clf;
for c  = 1: classNum
    testlabel_ = find(testlabel == C(c));
    tmp_F0 = [];tmp_F2 = [];
    for s = testlabel_
        tmp_F0 = cat(3, tmp_F0, reshape(features_root_F0(s, 1,:,:), channelNum, TPoints));
        tmp_F2 = cat(3, tmp_F2, reshape(features_root_F2(s, 1,:,:), channelNum, TPoints));
    end
    subplot(2,5,c);
    M_F0 = mean(tmp_F0,3);
    if c == 1
      [~,sortP0] = sort(sum(M_F0(:, 1:100), 2));
    end
    M_F0 = M_F0(sortP0, :);
    imagesc(M_F0);
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);
%     caxis([-10,10]);
    set(gca,'Ydir', 'normal');
    
    subplot(2,5,5+c);
    M_F2 = mean(tmp_F2,3);
    if c== 1
    [~,sortP2] = sort(sum(M_F2(:, 1:100), 2));
    end
    M_F2 = M_F2(sortP2, :);
    imagesc(M_F2);
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);
%      caxis([-10,10]);
   set(gca,'Ydir', 'normal');
end
%%
clear;clc;
set(0,'defaultfigurecolor','w');
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F0_p10_0908.mat';
load(FEA_PATH, 'features_root_F0');  %% shape: (samples, 1, chns, time)
[Samples, ~, channelNum, TPoints] = size(features_root_F0);
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F2_p10_0908.mat';
load(FEA_PATH, 'features_root_F2');  %% shape: (samples, 1, chns, time)
VAR_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V2_p10_0908.mat';
load(VAR_PATH, 'testLabel');
testlabel = [];
for i = 1:Samples
    testlabel = [testlabel find(testLabel(i,:)==1)];
end
classNum = 5;

for c  = 1: classNum
    testlabel_ = find(testlabel == c);
    tmp_F0 = [];tmp_F2 = [];
    for s = testlabel_
        tmp_F0 = cat(3, tmp_F0, reshape(features_root_F0(s, 1,:,:), channelNum, TPoints));
        tmp_F2 = cat(3, tmp_F2, reshape(features_root_F2(s, 1,:,:), channelNum, TPoints));
    end
    C_F0{c} = tmp_F0;
    C_F2{c} = tmp_F2;
end

figure(2);

M_F0_C1 = mean(C_F0{1},3);
M_F2_C1 = mean(C_F2{1},3);

M_F0_C2 = mean(C_F0{2},3);
M_F2_C2 = mean(C_F2{2},3);

D_F0 = M_F0_C1-M_F0_C2;
D_F2 = M_F2_C1-M_F2_C2;

subplot(1,2,1);
imagesc(D_F0);
load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
colormap(MyColormap);
colorbar;
caxis([min(D_F0(:))*0.9,max(D_F0(:)*0.9)]);


subplot(1,2,2);
 [~,sortP] = sort(sum(D_F2, 2));
    D_F2 = D_F2(sortP, :);
imagesc(D_F2);
load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
colormap(MyColormap);
colorbar;
caxis([min(D_F2(:))*0.9,max(D_F2(:)*0.9)]);

%%  Input 和 DA后的 频域能量
clear;clc;
set(0,'defaultfigurecolor','w');
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F0_p10_0908.mat';
load(FEA_PATH, 'features_root_F0');  %% shape: (samples, 1, chns, time)
features_root_F0 = double(features_root_F0);
[Samples, ~, channelNum, TPoints] = size(features_root_F0);
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F2_p10_0908.mat';
load(FEA_PATH, 'features_root_F2');  %% shape: (samples, 1, chns, time)
features_root_F2 = double(features_root_F2);
VAR_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V2_p10_0908.mat';
load(VAR_PATH, 'testLabel');
testlabel = [];
for i = 1:Samples
    testlabel = [testlabel find(testLabel(i,:)==1)];
end
classNum = 5;
Fs= 1000;
P_F0 = zeros(classNum,channelNum, TPoints/2+1, length(testlabel)/classNum);
P_F2 = zeros(classNum,channelNum, TPoints/2+1, length(testlabel)/classNum);
for c  = 1: classNum
    testlabel_ = find(testlabel == c);
    tmpct = 0;
    for s = testlabel_
        tmpct = tmpct+1;
        tmp_F0 = reshape(features_root_F0(s, 1,:,:), channelNum, TPoints);
        tmp_F2 = reshape(features_root_F2(s, 1,:,:), channelNum, TPoints);
        for chn = 1:channelNum
            Y=fft(tmp_F0(chn,:));
            P2 = abs(Y/TPoints);
            P1 = P2(1:TPoints/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            P_F0(c,chn, :, tmpct) = P1;
            
            Y=fft(tmp_F2(chn,:));
            P2 = abs(Y/TPoints);
            P1 = P2(1:TPoints/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            P_F2(c,chn, :, tmpct) = P1;
        end
    end
end
for c = 1:classNum
    figure(c);clf;
    subplot(121);
    M_P_F0 = mean(reshape(P_F0(c, :, :, :), channelNum, TPoints/2+1, length(testlabel_)),3);
    f = Fs*(0:(TPoints/2))/TPoints;
    imagesc(f, 1:channelNum, reshape(M_P_F0, channelNum, TPoints/2+1));
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);       
    set(gca, 'Clim', [0, 10]);
    subplot(122);
    M_P_F2 = mean(reshape(P_F2(c, :, :, :), channelNum, TPoints/2+1, length(testlabel_)),3);
    M_P_F2 = reshape(M_P_F2, channelNum, TPoints/2+1);
    f = Fs*(0:(TPoints/2))/TPoints;
    imagesc(f(1:100), 1:channelNum, M_P_F2(:, 1:100));
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);  
    set(gca, 'Clim', [0, 10]);
end

%% F3 output, FFT.
clear;clc;
set(0,'defaultfigurecolor','w');
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F3_p4_0916.mat';
load(FEA_PATH, 'features_root_F3');  %% shape: (samples, filters, chns, time)
features_root_F3 = double(features_root_F3);
[Samples, filters, channelNum, TPoints] = size(features_root_F3);
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F2_p4_0916.mat';
load(FEA_PATH, 'features_root_F2');  %% shape: (samples, 1, chns, time)
features_root_F2 = double(features_root_F2);
VAR_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V3_p4_0916.mat';
load(VAR_PATH, 'testLabel');
testlabel = [];
for i = 1:Samples
    testlabel = [testlabel find(testLabel(i,:)==1)];
end
classNum = 5;
Fs= 1000;
P_F3 = zeros(classNum,filters, channelNum, floor(TPoints/2)+1, length(testlabel)/classNum);
for c  = 1: classNum
    testlabel_ = find(testlabel == c);
    tmpct = 0;
    for s = testlabel_
        tmpct = tmpct+1;
        for f = 1:filters
            tmp_F3 = reshape(features_root_F3(s, f,:,:), channelNum, TPoints);
            for chn = 1:channelNum
                Y=fft(tmp_F3(chn,:));
                P2 = abs(Y/TPoints);
                P1 = P2(1:floor(TPoints/2)+1);
                P1(2:end-1) = 2*P1(2:end-1);
                P_F3(c,f, chn, :, tmpct) = P1;
            end
        end
    end
end

for f = 1:filters
    figure(f);clf;
    for c = 1:classNum
        subplot(1,classNum, c);
        M_P_F3 = mean(reshape(P_F3(c, f, :, :, :), channelNum, floor(TPoints/2)+1, length(testlabel_)),3);
        M_P_F3 = reshape(M_P_F3, channelNum, floor(TPoints/2)+1);
        ff = Fs*(0:(TPoints/2))/TPoints;
        imagesc(ff(1:100), 1:channelNum, M_P_F3(:,1:100));
        load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
        colormap(MyColormap); 
    end
end
    
%%
clear;clc;
SAVE_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F1_weight_p10_0908.mat';
load(SAVE_PATH, 'weight_spati');
WF1 = weight_spati;
[channelNum, ~, ~, filters] = size(WF1);

for i = 1:filters
    for j = i:filters
        [corrMtix, pvalMtrix] = corrcoef(reshape(WF1(:,:,:,i),1,[]), reshape(WF1(:,:,:,j),1,[]));
        corr_X0(i, j) = corrMtix(1,2);
        corr_X0(j, i) = corrMtix(1,2);
        pval_WF1(i, j) = pvalMtrix(1,2);
        pval_WF1(j, i) = pvalMtrix(1,2);
    end
end
imagesc(abs(corr_X0)) ;
%%
clear;clc;
SAVE_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F4_weight_p10_0908.mat';
load(SAVE_PATH, 'weight_spati');
[~, channelNum, ~, filters] = size(weight_spati);
WF4 = reshape(weight_spati, channelNum, filters);
imagesc(WF4) ;
 
 %%  F0和F2 channel 之间的Sig的相关性 /trial
clear;clc;
set(0,'defaultfigurecolor','w');
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F0_p10_0915.mat';
load(FEA_PATH, 'features_root_F0');  %% shape: (samples, 1, chns, time)
features_root_F0 = double(features_root_F0);
[Samples, ~, channelNum, TPoints] = size(features_root_F0);
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F2_p10_0915.mat';
load(FEA_PATH, 'features_root_F2');  %% shape: (samples, 1, chns, time)
features_root_F2 = double(features_root_F2);

corr_X0 = zeros(channelNum);
corr_X2 = zeros(channelNum);
for i = 1:channelNum
    for j = i:channelNum
        
        for s = 1:Samples
            [corrMtix, ~] = corrcoef(reshape(features_root_F0(s,1,i,:),1,[]), reshape(features_root_F0(s,1,j,:),1,[]));
            corr_X0(i, j) = corr_X0(i, j)+corrMtix(1,2);
            [corrMtix, ~] = corrcoef(reshape(features_root_F2(s,1,i,:),1,[]), reshape(features_root_F2(s,1,j,:),1,[]));
            corr_X2(i, j) = corr_X2(i, j)+corrMtix(1,2);
        end
        corr_X0(i, j) = corr_X0(i, j)/Samples;
        corr_X0(j, i) = corr_X0(i, j);
        corr_X2(i, j) = corr_X2(i, j)/Samples;
        corr_X2(j, i) = corr_X2(i, j);
    end
end
figure(2);
subplot(121);
imagesc(abs(corr_X0)) ;
 subplot(122);
imagesc(abs(corr_X2)) ;
 
 
%% F0和F2 channel 类之间的Sig的相关性 /trial
clear;clc;
set(0,'defaultfigurecolor','w');
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F0_p4_0916.mat';
load(FEA_PATH, 'features_root_F0');  %% shape: (samples, 1, chns, time)
[Samples, ~, channelNum, TPoints] = size(features_root_F0);
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F2_p4_0916.mat';
load(FEA_PATH, 'features_root_F2');  %% shape: (samples, 1, chns, time)
VAR_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V3_p4_0916.mat';
load(VAR_PATH, 'testLabel');
testlabel = [];
for i = 1:Samples
    testlabel = [testlabel find(testLabel(i,:)==1)];
end
classNum = 5;

for c  = 1: classNum
    testlabel_ = find(testlabel == c);
    tmp_F0 = [];tmp_F2 = [];
    for s = testlabel_
        tmp_F0 = cat(3, tmp_F0, reshape(features_root_F0(s, 1,:,:), channelNum, TPoints));
        tmp_F2 = cat(3, tmp_F2, reshape(features_root_F2(s, 1,:,:), channelNum, TPoints));
    end
    C_F0{c} = tmp_F0;
    C_F2{c} = tmp_F2;
end
corr_F0 = zeros(channelNum, 10);
corr_F2 = zeros(channelNum, 10);
tmp = 0;
for c1 = 1:classNum-1
    for c2 = c1+1:classNum
        tmp = tmp+1;
        
        M_F0_C1 = mean(C_F0{c1},3);
        M_F2_C1 = mean(C_F2{c1},3);
        
        M_F0_C2 = mean(C_F0{c2},3);
        M_F2_C2 = mean(C_F2{c2},3);

        for ch = 1:channelNum
            [corrMtix, ~] = corrcoef(M_F0_C1(ch, :),M_F0_C2(ch, :));
            corr_F0(ch, tmp) =  corrMtix(1,2);
            [corrMtix, ~] = corrcoef(M_F2_C1(ch, :),M_F2_C2(ch, :));
            corr_F2(ch, tmp) =  corrMtix(1,2);
        end
    end
end
figure(3);clf;
subplot(1,2,1);
imagesc(corr_F0);
caxis([0, 0.5]);

subplot(1,2,2);
imagesc(corr_F2);
caxis([0, 0.5]);

tmp = 0; 
res_F0 = diag(ones(1,classNum));
res_F2 = diag(ones(1,classNum));
for c1 = 1:classNum-1
    for c2 = c1+1:classNum
        tmp = tmp+1;
        res_F0(c1,c2) = mean(abs(corr_F0(:,tmp)));
        res_F0(c2,c1) = res_F0(c1,c2);
        
        res_F2(c1,c2) = mean(abs(corr_F2(:,tmp)));
        res_F2(c2,c1) = res_F2(c1,c2);
    end
end
figure(4);clf;
subplot(1,2,1);
imagesc(res_F0);
caxis([0.2, 0.3]);

subplot(1,2,2);
imagesc(res_F2);
caxis([0.2, 0.3]);

%%
clear;clc;
set(0,'defaultfigurecolor','w');
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F0_p10_0908.mat';
load(FEA_PATH, 'features_root_F0');  %% shape: (samples, 1, chns, time)
[Samples, ~, channelNum, TPoints] = size(features_root_F0);
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F2_p10_0908.mat';
load(FEA_PATH, 'features_root_F2');  %% shape: (samples, 1, chns, time)
VAR_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V2_p10_0908.mat';
load(VAR_PATH, 'testLabel');
testlabel = [];
for i = 1:Samples
    testlabel = [testlabel find(testLabel(i,:)==1)];
end
classNum = 5;
C = [2 1 3 4 5];
tmp = 0;
for c  = 1: classNum
    testlabel_ = find(testlabel == C(c));
    for s = testlabel_(1:15:end)
        tmp = tmp +1;
        figure(tmp);clf;
        tmp_F0 = reshape(features_root_F0(s, 1,:,:), channelNum, TPoints);
        tmp_F2 = reshape(features_root_F2(s, 1,:,:), channelNum, TPoints);
        [~,sortP0] = sort(sum(tmp_F0(:, 1:100), 2));
        tmp_F0 = tmp_F0(sortP0, :);
        subplot(221);
        imagesc( tmp_F0 );
        load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
        colormap(MyColormap);
        caxis([-60,60]);
        
        subplot(222);
        [~,sortP2] = sort(sum(tmp_F2(:, 1:100), 2));
        tmp_F2 = tmp_F2(sortP2, :);
        imagesc( tmp_F2 );
        load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
        colormap(MyColormap);
        caxis([-60,60]);
        
        subplot(223);
        tmp_F0 = mean(abs(tmp_F0));
        tmp_F0 = (tmp_F0-mean(tmp_F0))/std(tmp_F0);
        S_F0 = smooth(tmp_F0,100);
        plot(S_F0);
        hold on;
        tmp_F2 = mean(abs(tmp_F2));
        tmp_F2 = (tmp_F2-mean(tmp_F2))/std(tmp_F2);
        S_F2 = smooth(tmp_F2,100);
        plot(S_F2);    
    end
end

%% F0和F2 channel 类之间的Sig的相关性 /trial, all subj.
clear;clc;
set(0,'defaultfigurecolor','w');
Inf = [2, 1000; 3, 1000; 4, 1000; 5, 1000; 7, 1000; 8, 1000; 9, 1000; 10, 2000; % 11, 500; 12, 500;
       13, 2000;  16, 2000; 17, 2000; 18, 2000; 19, 2000; 20, 1000; 21, 1000; 22, 2000; 23, 2000; % 14, 2000;
       29, 2000; 30, 2000; 31, 2000; 32, 2000; 34, 2000; 35, 1000; % 28, 2000; 33,    24, 2000; 25, 2000; 26, 2000; 
       36, 2000; 37, 2000; 41,2000; 45,2000;
       ];
goodSubj = [1,2,3,8,9,12,16,18,21,22,26];
Inf = Inf(goodSubj,:);

classNum = 5;
res_F0_All = zeros(size(Inf, 1), classNum, classNum);
res_F2_All = zeros(size(Inf, 1), classNum, classNum);
for subj = 1:size(Inf, 1)
    pn = Inf(subj, 1);
    
    FEA_PATH = strcat('D:/lsj/Modelvari_CNN/P',num2str(pn),'/Model_F0_output_0916.mat');
    load(FEA_PATH, 'features_root_F0');  %% shape: (samples, 1, chns, time)
    [Samples, ~, channelNum, TPoints] = size(features_root_F0);
    FEA_PATH = strcat('D:/lsj/Modelvari_CNN/P',num2str(pn),'/Model_F2_output_0916.mat');
    load(FEA_PATH, 'features_root_F2');  %% shape: (samples, 1, chns, time)
    VAR_PATH =strcat('D:/lsj/Modelvari_CNN/P',num2str(pn),'/Vis_Data_0916.mat');
    load(VAR_PATH, 'testLabel');
    testlabel = [];
    for i = 1:Samples
        testlabel = [testlabel find(testLabel(i,:)==1)];
    end
    
    C_F0 = cell(classNum,1);
    for c  = 1: classNum
        testlabel_ = find(testlabel == c);
        tmp_F0 = [];tmp_F2 = [];
        for s = testlabel_
            tmp_F0 = cat(3, tmp_F0, reshape(features_root_F0(s, 1,:,:), channelNum, TPoints));
            tmp_F2 = cat(3, tmp_F2, reshape(features_root_F2(s, 1,:,:), channelNum, TPoints));
        end
        C_F0{c} = tmp_F0;
        C_F2{c} = tmp_F2;
    end
    corr_F0 = zeros(channelNum, 10);
    corr_F2 = zeros(channelNum, 10);
    tmp = 0;
    for c1 = 1:classNum-1
        for c2 = c1+1:classNum
            tmp = tmp+1;
            
            M_F0_C1 = mean(C_F0{c1},3);
            M_F2_C1 = mean(C_F2{c1},3);
            
            M_F0_C2 = mean(C_F0{c2},3);
            M_F2_C2 = mean(C_F2{c2},3);
            
            for ch = 1:channelNum
                [corrMtix, ~] = corrcoef(M_F0_C1(ch, :),M_F0_C2(ch, :));
                corr_F0(ch, tmp) =  corrMtix(1,2);
                [corrMtix, ~] = corrcoef(M_F2_C1(ch, :),M_F2_C2(ch, :));
                corr_F2(ch, tmp) =  corrMtix(1,2);
            end
        end
    end
   
    tmp = 0;
    res_F0 = diag(ones(1,classNum));
    res_F2 = diag(ones(1,classNum));
    for c1 = 1:classNum-1
        for c2 = c1+1:classNum
            tmp = tmp+1;
            res_F0(c1,c2) = mean(abs(corr_F0(:,tmp)));
            res_F0(c2,c1) = res_F0(c1,c2);
            
            res_F2(c1,c2) = mean(abs(corr_F2(:,tmp)));
            res_F2(c2,c1) = res_F2(c1,c2);
        end
    end
    res_F0_All(subj,:,:) = res_F0;
    res_F2_All(subj,:,:) = res_F2;  
    
    figure(subj);clf;
    subplot(1,2,1);
    imagesc(res_F0);
%     caxis([0.2, 0.3]);
    
    subplot(1,2,2);
    imagesc(res_F2);
%     caxis([0.2, 0.3]);

end

figure(subj+1);clf;
subplot(1,2,1);
imagesc(reshape(mean(res_F0_All, 1),classNum, classNum));
caxis([0.22, 0.25]);

subplot(1,2,2);
imagesc(reshape(mean(res_F2_All, 1),classNum, classNum));
caxis([0.22, 0.25]);

%% Depthwise 权重,
clear;clc;
pn = 10;
DEPTH_PATH = strcat('D:/lsj/Modelvari_CNN/P', num2str(pn), '/Model_F4_weight_0916.mat');
load(DEPTH_PATH, 'weight_spati');
[~, channelNum, ~, Filters] = size(weight_spati);
WT_Dwise = reshape(weight_spati,channelNum, Filters);
imagesc(WT_Dwise);
%% F4 output, 
clear;clc;
set(0,'defaultfigurecolor','w');
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F4_p10_0908.mat';
load(FEA_PATH, 'features_root_F4');  %% shape: (samples, 1, chns, time)
[Samples, Filters, ~, TPoints] = size(features_root_F4);
Fs = 1000;
VAR_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V2_p10_0908.mat';
load(VAR_PATH, 'testLabel');
testlabel = [];
for i = 1:Samples
    testlabel = [testlabel find(testLabel(i,:)==1)];
end
classNum = 5;

tmp = 0;
for c  = 1: classNum   
    testlabel_ = find(testlabel == c);
    tmpct = 0;
    for s = testlabel_
        tmpct = tmpct+1;
        for f = 1:Filters
            tmp_F3 = reshape(features_root_F4(s, f,:,:), 1, TPoints);
            Y=fft(tmp_F3);
            
            P2 = abs(Y/TPoints);
            P1 = P2(1:floor(TPoints/2)+1);
            P1(2:end-1) = 2*P1(2:end-1);
%             P_F4(c,f,:,tmpct) = mapminmax(P1,0,1);
            P_F4(c,f,:,tmpct) = P1;
            
            A2 = angle(Y);
            A1 = A2(1:floor(TPoints/2)+1);
            A_F4(c,f,:,tmpct) = A1;
        end
    end
end

% figure(100);clf;
% for c = 1:classNum
%     subplot(2,classNum, c);
%     M_P_F4 = mean(reshape(P_F4(c, :, :, :), Filters, floor(TPoints/2)+1,length(testlabel_)),3);
%     M_P_F4 = reshape(M_P_F4, Filters, floor(TPoints/2)+1);
%     ff = Fs*(0:(TPoints/2))/TPoints;
%     imagesc(ff(1:100), 1:Filters, M_P_F4(:,1:100));
%     load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
%     colormap(MyColormap);
%     set(gca, 'Clim',[0,1]);
%     
%     subplot(2,classNum, classNum+c);
%     M_A_F4 = mean(reshape(A_F4(c, :, :, :), Filters, floor(TPoints/2)+1,length(testlabel_)),3);
%     M_A_F4 = reshape(M_A_F4, Filters, floor(TPoints/2)+1);
%     ff = 2*pi*(0:(TPoints/2))/TPoints-pi;
%     imagesc(ff(1:100), 1:Filters, M_A_F4(:,1:100));
%     load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
%     colormap(MyColormap);
% end

C_M = [[69,178,76]/255;[55,121,187]/255;[231,27,31]/255;[218,165,32]/255;[105,105,105]/255];
C_S = [[218,239,221]/255;[213,229,237]/255;[249,209,208]/255;[255,248,220]/255;[211,211,211]/255];
for f = 1:Filters
    figure(200+f);clf;
    for c = 1:classNum
        M_P_F4 = mean(reshape(P_F4(c, f, :, :), floor(TPoints/2)+1,length(testlabel_)),2);
        S_P_F4 = std(reshape(P_F4(c, f, :, :), floor(TPoints/2)+1,length(testlabel_)),0,2)/sqrt(length(testlabel_));
        y1 = M_P_F4 + S_P_F4;
        y2 = M_P_F4 - S_P_F4;
        M_P_F4 = smooth(M_P_F4,20);
        y1 = smooth(y1,20);
        y2 = smooth(y2,20);
%         ff = [0 log(Fs*(1:(TPoints/2))/TPoints)];
        ff = Fs*(0:(TPoints/2))/TPoints;
        hold on;
        fill([ff(1:100),fliplr(ff(1:100))],[y1(1:100)',fliplr(y2(1:100)')],C_S(c,:),'EdgeColor','none','FaceAlpha',0.7);
        hold on;
        plot(ff(1:100), M_P_F4(1:100)','Color',C_M(c,:),'LineWidth',2);
        set(gca,'Xlim',[0,200]);
%         set(gca,'Xlim',[0,log(200)]);
    end
end   
    
%% F4 output, pair_class T-test.   
clear;clc;
set(0,'defaultfigurecolor','w');
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V2_F4_p10_0908.mat';
load(FEA_PATH, 'features_root_F4');  %% shape: (samples, 1, chns, time)
[Samples, Filters, ~, TPoints] = size(features_root_F4);
Fs = 1000;
VAR_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V2_p10_0908.mat';
load(VAR_PATH, 'testLabel');
testlabel = [];
for i = 1:Samples
    testlabel = [testlabel find(testLabel(i,:)==1)];
end
classNum = 5;

tmp = 0;
for c  = 1: classNum   
    testlabel_ = find(testlabel == c);
    tmpct = 0;
    for s = testlabel_
        tmpct = tmpct+1;
        for f = 1:Filters
            tmp_F3 = reshape(features_root_F4(s, f,:,:), 1, TPoints);
            Y=fft(tmp_F3);
            
            P2 = abs(Y/TPoints);
            P1 = P2(1:floor(TPoints/2)+1);
            P1(2:end-1) = 2*P1(2:end-1);
%             P_F4(c,f,:,tmpct) = mapminmax(P1,0,1);
            P_F4(c,f,:,tmpct) = P1;  
        end
    end
end

H_Ttest = [];
P_Ttest = [];
S_Ttest = zeros(Filters, floor(TPoints/2)+1);
S_Ttest_Mean = zeros(Filters, floor(TPoints/2)+1);
for f = 1:Filters
    h_Ttest = zeros(10, floor(TPoints/2)+1);
    p_Ttest = zeros(10, floor(TPoints/2)+1);
    tmp = 0;
    for c1 = 1:classNum-1
        C1_F4 = reshape(P_F4(c1, f, :, :), floor(TPoints/2)+1,length(testlabel_));
        for c2 = c1+1:classNum
            C2_F4 = reshape(P_F4(c2, f, :, :), floor(TPoints/2)+1,length(testlabel_));
            tmp = tmp+1;
            for tp = 1:floor(TPoints/2)+1
                [h, p] = ttest(C1_F4(tp,:), C2_F4(tp,:));
                h_Ttest(tmp,tp) = h;
                p_Ttest(tmp,tp) = p;
            end
        end
    end
    H_Ttest = cat(3,H_Ttest,h_Ttest);
    P_Ttest = cat(3,P_Ttest,p_Ttest);
%     S_Ttest(f,:) = sum(h_Ttest, 1); 
    for tp = 1:floor(TPoints/2)+1 
        S_Ttest(f,tp) = length(find(p_Ttest(:,tp)<=0.005));
        S_Ttest_Mean(f,tp) = mean(p_Ttest(:,tp));
    end
end       

    
    
    
    
    
