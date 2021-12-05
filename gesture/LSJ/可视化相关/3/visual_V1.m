clear;clc;
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V1_F17_p41_0904.mat';
load(FEA_PATH, 'features_root_F17');  %% shape: (150, 512, 1, 21)
features_root = double(features_root_F17);
PWR_PATH = 'D:/lsj/Modelvari_CNN/power5FB_P41.mat';
load(PWR_PATH, 'power5Seg');    %% shape: {trials, freqs}(time, chns)
INX_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V1_2_p41_0904.mat';
load(INX_PATH, 'testInx');                                                                                                                     

Inx = [];
for i = 1: length(testInx)
    Inx = [Inx, (i-1)*15+1:i*15];
end
% features_root = features_root(Inx,:,:,:);
power5Seg = power5Seg(Inx, :);

trialNum = size(power5Seg,1);
[samples, channelNum] = size(power5Seg{1,1});

%%% layer 5 %%%
power5Seg_F17 = cell(size(power5Seg));
for k = 1:49   %% k, Freq bands.
    for i = 1:trialNum  %% 1 - 150.
        power5Seg_F17{i, k} = zeros(21, channelNum);
        for j = 1: channelNum
            
%             for z = 1:21   %% same as the receptive filed size.
%                 if z < 5; tamp = power5Seg{i, k}(1:24*z+93,j);
%                 elseif  z < 16; tamp = power5Seg{i, k}(24*z-107:24*z+93,j);
%                 else; tamp = power5Seg{i, k}(24*z-107:498,j);
%                 end
%                 power5Seg_F17{i, k}(z,j) = mean(tamp); 
%             end

              for z = 1:21   %% same as the receptive filed size.
                  if z < 5; tamp = power5Seg{i, k}(1:24*z+93,j);
                  elseif  z < 16; tamp = power5Seg{i, k}(24*z-107:24*z+93,j);
                  else; tamp = power5Seg{i, k}(24*z-107:498,j);
                  end
                  power5Seg_F17{i, k}(z,j) = mean(tamp); 
              end
              
        end
    end
end

SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_power5Seg_F17_p41_0904.mat';
save(SAVE_PATH, 'power5Seg_F17' , '-v7.3');

%% 展示了10个样本(i)的通道1(j)的8个filters(q)和5个频带包络(k)的 input-feature/unit output.
% clear;clc;
% INX_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V1_2_p10.mat';
% load(INX_PATH, 'testLabel');
% SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_power5Seg_F17_p10_210825.mat';
% load(SAVE_PATH, 'power5Seg_F17');
% FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V1_F17_p10.mat';
% load(FEA_PATH, 'features_root_F17');  %% shape: (150, 512, 1, 21)
% features_root = double(features_root_F17);
% 
% testlabel = [];
% for i = 1:150
%     testlabel = [testlabel find(testLabel(i,:)==1)];
% end
% Trials = find(testlabel == 1);
% 
% fig1 = figure(1);clf;
% for i = 1:length(Trials)
%     I  = Trials(i);
%     tamp = 0;
%     for j = 127  % channel
%         for q = [284]  %% filter No.,
%             output = reshape(features_root(I,q,:,:), 1,[]);
%             output = mapminmax(output,-3,3);  %%
%             % standardized,好像也没必要，纯粹为了画图才标准化一下.
%             tamp = tamp + 1;
%             gca = axes('Parent',fig1,'Position', [ 0.1+(i-1)*0.03, 0.1+(tamp-1)*0.018, 0.03, 0.015]);
%             hold(gca,'on');
%             imagesc(output);
%             box off;axis off;
%         end
%         for k = 3
%             power =  power5Seg_F17{I, k}(:,j)';
%             power = mapminmax(power,-3,3);
%             tamp = tamp + 1;
%             gca = axes('Parent',fig1,'Position', [ 0.1+(i-1)*0.03, 0.215+(tamp-1)*0.018, 0.03, 0.015]);
%             hold(gca,'on');
%             imagesc(power);
%             box off;axis off;
%         end
%     end
% end
% set(0,'defaultfigurecolor','w') 
%% 
INX_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V1_2_p41_0904.mat';
load(INX_PATH, 'testLabel');

testlabel = [];
for i = 1:150
    testlabel = [testlabel find(testLabel(i,:)==1)];
end

classNum = 5;
% clear corr_Sgl pval_Sgl;

for c  = 1: classNum
    testl = find(testlabel == c);
    
    for q = 1: 512
        output = [];
        for i = testl
            output = [output, reshape(features_root(i,q,:,:),[1, 21])];
        end
        %         output = zscore(output);
        for j = 1: channelNum
            for k = 1:49
                power = [];
                for i = testl
                    power = [power, power5Seg_F17{i, k}(:,j)];
                end
                %                 power = zscore(power);
                [corrMtix, pvalMtrix] = corrcoef(output, power);
                corr_Sgl(c,j,q,k) = corrMtix(1,2);
                pval_Sgl(c,j,q,k) = pvalMtrix(1,2);
            end
        end
    end
end
SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_0904.mat';
save(SAVE_PATH, 'corr_Sgl' , 'pval_Sgl',  '-v7.3');


% clear corr_Sgl pval_Sgl;
% for q = 1: 512
%     for i = 1:150
%         output = features_root(i,q,:,:);
% %         output = zscore(output);
%         for j = 1: channelNum
%             for k = 1:5
%                 power = power5Seg_F17{i, k}(:,j);
% %                 power = zscore(power);
%                 [corrMtix, pvalMtrix] = corrcoef(output, power);
%                 corr_Sgl(i,j,q,k) = corrMtix(1,2);
%                 pval_Sgl(i,j,q,k) = pvalMtrix(1,2);
%             end
%         end
%     end
% end
%%  
%%%%%%%%%%%%%%%%%%%%%%%%% Filter-Freq, single class %%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;
SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_0904.mat';
load(SAVE_PATH, 'corr_Sgl');
[~, channelNum, filters, freqs] = size(corr_Sgl);
for  j = 1: channelNum
    figure1 = figure(j);clf;
    x = reshape(corr_Sgl(1,j,:,:), filters, freqs);
    [~,sortP] = sort(mean(x(:, 16:49), 2));
    x = x(sortP, :);
    imagesc(x');
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);
    set(gca, 'Clim', [-1,1], 'YDir','normal');

end

%%
%%%%%%%%%%%%%%%%%%%%%% Filter-Freq, single class + 显著性%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;
SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_210825.mat';
load(SAVE_PATH, 'corr_Sgl', 'pval_Sgl');
[~, channelNum, filters, freqs] = size(corr_Sgl);
for  j = [154, 208]%1: channelNum
    figure1 = figure(j);clf;
    x = reshape(corr_Sgl(1,j,:,:), filters, freqs);
    [~,sortP] = sort(mean(x(:, 16:49), 2));
    x = x(sortP, :);
    
    Bx = reshape(pval_Sgl(1,j,:,:), filters, freqs);
    Bx = Bx(sortP, :);
    imagesc(Bx');
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps_backGnd.mat','MyColormap');
    colormap(MyColormap);
    set(gca, 'Clim', [0,0.1], 'YDir','normal');
     
    freezeColors;
    hold on;
    h = imagesc(x');
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);
    set(gca, 'Clim', [-1,1], 'YDir','normal');
    set(h, 'AlphaData', 0.9);
end

%%
%%%%%%%%%%%%%%%%%%%%% Filter-Freq + weights, single class %%%%%%%%%%%%%%%%%%%%%
clear;clc;
INX_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V1_2_p10.mat';
load(INX_PATH, 'testLabel');
SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_210825.mat';
load(SAVE_PATH, 'corr_Sgl');
[~, channelNum, filters, freqs] = size(corr_Sgl);
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V1_F19_p10.mat';
load(FEA_PATH, 'features_root_F19');  %% shape: (150, 512, 1, 21)
features_root_F19 = double(features_root_F19);
WIT_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V1_F20_weight_p10.mat';
load(WIT_PATH, 'weight_spati');
weight_spati = double(weight_spati);

testlabel = [];
for i = 1:150
    testlabel = [testlabel find(testLabel(i,:)==1)];
end
testl = find(testlabel == 1);
features_root_F19 = features_root_F19(testl, :); %%% 先考察label == 1.
    
DenseO = zeros(5, filters);
for i = 1:5
    tmp = features_root_F19.* weight_spati(:,i)';
    DenseO(i,:) = mean(tmp, 1);
    acc(:,i) = sum(tmp, 2);
end

for  j = [154, 208]%1: channelNum
    figure1 = figure(j);clf;
    x = reshape(corr_Sgl(1,j,:,:), filters, freqs);
    [~,sortP] = sort(mean(x(:, 16:49), 2));
    x = x(sortP, :);
    
    DenseO_ = DenseO(:, sortP);
    
    gca = axes('Parent',figure1,'Position', [ 0.1,0.28, 0.8, 0.7]);
    hold(gca,'on');
    imagesc(x');
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);
    set(gca, 'Clim', [-1,1], 'YDir','normal');
    axis off;
    
    freezeColors;
    gca = axes('Parent',figure1,'Position', [ 0.1,0.15, 0.8, 0.08]);
    hold(gca,'on');
    imagesc(DenseO_(1,:));
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);
    set(gca, 'Clim', [-0.05,0.05], 'YDir','normal');
    axis off;
    
    freezeColors;
    gca = axes('Parent',figure1,'Position', [ 0.1,0.06, 0.8, 0.03]);
    hold(gca,'on');
    We = weight_spati(sortP,1);
    We = double(We>0);
    imagesc(We');
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);
    set(gca, 'Clim', [0.25,0.75], 'YDir','normal');
    axis off;
end
%%
%%%%%%%%%%%%%%%%% Filter-chn, weight_corr_corr, single class %%%%%%%%%%%%%%%%%%
clear;clc;
INX_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V1_2_p10.mat';
load(INX_PATH, 'testLabel');
SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_210825.mat';
load(SAVE_PATH, 'corr_Sgl');
[~, channelNum, filters, freqs] = size(corr_Sgl);
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V1_F19_p10.mat';
load(FEA_PATH, 'features_root_F19');  %% shape: (150, 512, 1, 21)
features_root_F19 = double(features_root_F19);
WIT_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V1_F20_weight_p10.mat';
load(WIT_PATH, 'weight_spati');
weight_spati = double(weight_spati);

testlabel = [];
for i = 1:150
    testlabel = [testlabel find(testLabel(i,:)==1)];
end
testl = find(testlabel == 1);
features_root_F19 = features_root_F19(testl, :); %%% 先考察label == 1.
    
DenseO = zeros(5, filters);
for i = 1:5
    tmp = features_root_F19.* weight_spati(:,i)';
    DenseO(i,:) = mean(tmp, 1);
end

W_corr_C = zeros(freqs, channelNum);
W_corr_C_Pval = zeros(freqs, channelNum);
figure1 = figure(1);clf;
for  j = 1: channelNum
    for q = 1: freqs  
        x = reshape(corr_Sgl(1,j,:,q), 1, filters);
        
        [corrMtix, pvalMtrix] = corrcoef(x, DenseO(1,:));
        W_corr_C(q, j) = corrMtix(1,2);
        W_corr_C_Pval(q, j) = pvalMtrix(1,2);
    end
end
[~,sortP] = sort(mean(W_corr_C(1:8, :), 1));
W_corr_C = W_corr_C(:, sortP);
imagesc(W_corr_C);
load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
colormap(MyColormap);
set(gca, 'Clim', [-1,1], 'YDir','normal');
axis off;


%%
%%%%%%%%%%%%%%%%%%%%%%%%% Filter-Freq, multi classes %%%%%%%%%%%%%%%%%%%%%%%%%% 
clear;clc;
SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_0904.mat';
load(SAVE_PATH, 'corr_Sgl');
[classNum, channelNum, filters, freqs] = size(corr_Sgl);

for  j = 1: channelNum
    figure(j+1000);
    
    for c = 1: classNum   
        x = reshape(corr_Sgl(c,j,:,:), filters, freqs);
        [~,sortP] = sort(mean(x(:, 1:16), 2));
        x = x(sortP, :);
        
        subplot(2,3,c);
        imagesc(x');
        load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
        colormap(MyColormap);
        set(gca, 'Clim', [-0.8,0.8], 'YDir','normal');
    end
end
%%
%%%%%%%%%%%%%%%%%%%%%% Filter-Freq, single class + D-val %%%%%%%%%%%%%%%%%%%%%%
clear;clc;
SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_2_NoTr_210826.mat';
load(SAVE_PATH, 'corr_Sgl');
corr_Sgl_Raw = corr_Sgl;
SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_210901.mat';
load(SAVE_PATH, 'corr_Sgl');
[~, channelNum, filters, freqs] = size(corr_Sgl);

for  j = 1: channelNum
    figure1 = figure(100+j);clf;
    
    x = reshape(corr_Sgl(1,j,:,:), filters, freqs);
    [~,sortP] = sort(mean(x(:, 16:49), 2));
    x = x(sortP, :);
    
    gca = axes('Parent',figure1,'Position', [ 0.075,0.1, 0.75, 0.75]);
    hold(gca,'on');
    
    imagesc(x');
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);
    set(gca, 'Clim', [-1,1], 'YDir','normal');
    box off;
    axis off;
    
    gca = axes('Parent',figure1,'Position', [ 0.765,0.1, 0.23, 0.75]);
    hold(gca,'on');
    
    xAbsMean = mean(abs(x)',2);
    xAbsMean = smooth(xAbsMean, 5);
    plot(xAbsMean, 1:length(xAbsMean), '--b', 'LineWidth', 2);
    hold on;
    
    xRaw = reshape(corr_Sgl_Raw(1,j,:,:), filters, freqs);
    xRawAbsMean = mean(abs(xRaw)', 2);
    xRawAbsMean = smooth(xRawAbsMean, 5);
    plot(xRawAbsMean, 1:length(xRawAbsMean), '--g', 'LineWidth', 0.75);
    hold on;
    
%     plot(xAbsMean - xRawAbsMean, 1:length(xRawAbsMean),'r', 'LineWidth', 2);
    plot(smooth(xAbsMean - xRawAbsMean, 5), 1:length(xRawAbsMean),'r', 'LineWidth', 2);
    grid on;
    box off; 
    set(gca,'GridColor',[1 1 1],'Color', [0.95 0.95 0.95],'GridAlpha', 1,...
        'FontName','Times New Roman','XColor',[1 1 1],'YColor',[1 1 1]);
    legend({'Trained', 'Untrained', 'Difference'});
    legend('boxoff');
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

figure(1);clf;
for c  = 1: classNum
    testlabel_ = find(testlabel == c);
    tmp_F0 = [];tmp_F2 = [];
    for s = testlabel_
        tmp_F0 = cat(3, tmp_F0, reshape(features_root_F0(s, 1,:,:), channelNum, TPoints));
        tmp_F2 = cat(3, tmp_F2, reshape(features_root_F2(s, 1,:,:), channelNum, TPoints));
    end
    subplot(2,5,c);
    M_F0 = mean(tmp_F0,3);
    imagesc(M_F0);
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);
    colorbar;
    caxis([-8,8]);
    
    subplot(2,5,5+c);
    M_F2 = mean(tmp_F2,3);

    [~,sortP] = sort(sum(M_F2(:, 1:100), 2));

    M_F2 = M_F2(sortP, :);
    imagesc(M_F2);
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);
    colorbar;
     caxis([-8,8]);
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

%%
clear;clc;
set(0,'defaultfigurecolor','w');
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V1_F0_p10_0904.mat';
load(FEA_PATH, 'features_root_F0');  %% shape: (samples, 1, chns, time)
features_root_F0 = double(features_root_F0);
[Samples, ~, channelNum, TPoints] = size(features_root_F0);
VAR_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V1_2_p10_0904.mat';
load(VAR_PATH, 'testLabel');
testlabel = [];
for i = 1:Samples
    testlabel = [testlabel find(testLabel(i,:)==1)];
end
classNum = 5;
Fs= 1000;
P_F0 = zeros(classNum,channelNum, TPoints/2+1, length(testlabel)/classNum);
for c  = 1: classNum
    testlabel_ = find(testlabel == c);
    tmpct = 0;
    for s = testlabel_
        tmpct = tmpct+1;
        tmp_F0 = reshape(features_root_F0(s, 1,:,:), channelNum, TPoints);
      
        for chn = 1:channelNum
            Y=fft(tmp_F0(chn,:));
            P2 = abs(Y/TPoints);
            P1 = P2(1:TPoints/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            P_F0(c,chn, :, tmpct) = P1;
        end
    end
end
for c = 1:classNum
    figure(c);clf;

    M_P_F0 = mean(reshape(P_F0(c, :, :, :), channelNum, TPoints/2+1, length(testlabel_)),3);
    f = Fs*(0:(TPoints/2))/TPoints;
    imagesc(f, 1:channelNum, reshape(M_P_F0, channelNum, TPoints/2+1));
    load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
    colormap(MyColormap);              
end


%%
clear;clc;
set(0,'defaultfigurecolor','w');
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V1_F1_p10_0904.mat';
load(FEA_PATH, 'features_root_F1');  %% shape: (samples, filters, chns, time)
features_root_F1 = double(features_root_F1);
[Samples, filters, channelNum, TPoints] = size(features_root_F1);
VAR_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V1_2_p10_0904.mat';
load(VAR_PATH, 'testLabel');
testlabel = [];
for i = 1:Samples
    testlabel = [testlabel find(testLabel(i,:)==1)];
end
classNum = 5;
Fs= 1000;
P_F1 = zeros(classNum,filters, channelNum, floor(TPoints/2)+1, length(testlabel)/classNum);
for c  = 1: classNum
    testlabel_ = find(testlabel == c);
    tmpct = 0;
    for s = testlabel_
        tmpct = tmpct+1;
        for f = 1:filters
            tmp_F1 = reshape(features_root_F1(s, f,:,:), channelNum, TPoints);
            for chn = 1:channelNum
                Y=fft(tmp_F1(chn,:));
                P2 = abs(Y/TPoints);
                P1 = P2(1:floor(TPoints/2)+1);
                P1(2:end-1) = 2*P1(2:end-1);
                P_F1(c,f, chn, :, tmpct) = P1;
            end
        end
    end
end

for f = 1:filters
    figure(f);clf;
    for c = 1:classNum
        subplot(1,classNum, c);
        M_P_F1 = mean(reshape(P_F1(c, f, :, :, :), channelNum, floor(TPoints/2)+1, length(testlabel_)),3);
        M_P_F1 = reshape(M_P_F1, channelNum, floor(TPoints/2)+1);
        ff = Fs*(0:(TPoints/2))/TPoints;
        imagesc(ff(1:100), 1:channelNum, M_P_F1(:,1:100));
        load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
        colormap(MyColormap); 
    end
end








