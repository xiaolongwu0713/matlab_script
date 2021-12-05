clear;clc;
FEA_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V1_F17_p10_2_NoTr.mat';
load(FEA_PATH, 'features_root_F17');  %% shape: (150, 512, 1, 21)
features_root = double(features_root_F17);
PWR_PATH = 'D:/lsj/Modelvari_CNN/power5FB_P10.mat';
load(PWR_PATH, 'power5Seg');    %% shape: {trials, freqs}(time, chns)
INX_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V1_2_p10.mat';
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

SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_power5Seg_F17_p10_2_NoTr_210826.mat';
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
%     for j = 153  % channel
%         for q = [283 478]  %% filter No.,
%             output = reshape(features_root(I,q,:,:), 1,[]);
%             % output = mapminmax(output,-3,3);  %%
%             % standardized,好像也没必要，纯粹为了画图才标准化一下.
%             tamp = tamp + 1;
%             gca = axes('Parent',fig1,'Position', [ 0.1+(i-1)*0.1, 0.1+(tamp-1)*0.055, 0.1, 0.04]);
%             hold(gca,'on');
%             imagesc(output);
%             box off;axis off;
%         end
%         for k = 3
%             power =  power5Seg_F17{I, k}(:,j)';
%             % power = mapminmax(power,-3,3);
%             tamp = tamp + 1;
%             gca = axes('Parent',fig1,'Position', [ 0.1+(i-1)*0.1, 0.215+(tamp-1)*0.055, 0.1, 0.04]);
%             hold(gca,'on');
%             imagesc(power);
%             box off;axis off;
%         end
%     end
% end
% set(0,'defaultfigurecolor','w') 
%% 
INX_PATH = 'D:/lsj/Modelvari_CNN/Visualization_V1_2_p10.mat';
load(INX_PATH, 'testLabel');

testlabel = [];
for i = 1:150
    testlabel = [testlabel find(testLabel(i,:)==1)];
end

classNum = 5;
clear corr_Sgl pval_Sgl;

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
SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_2_NoTr_210826.mat';
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
% %%  
% %%%%%%%%%%%%%%%%%%%%%%%%%% Filter-Freq, single class %%%%%%%%%%%%%%%%%%%%%%%%%%
% clear;clc;
% SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_210825.mat';
% load(SAVE_PATH, 'corr_Sgl');
% [~, channelNum, filters, freqs] = size(corr_Sgl);
% for  j = 1: channelNum
%     figure1 = figure(j);clf;
%     x = reshape(corr_Sgl(1,j,:,:), filters, freqs);
%     [~,sortP] = sort(mean(x(:, 16:49), 2));
%     x = x(sortP, :);
%     imagesc(x');
%     load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
%     colormap(MyColormap);
%     set(gca, 'Clim', [-1,1], 'YDir','normal');
% 
% end
% 
% 
% %%%%%%%%%%%%%%%%%%%%%% Filter-Freq, single class + 显著性%%%%%%%%%%%%%%%%%%%%%%%
% clear;clc;
% SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_210825.mat';
% load(SAVE_PATH, 'corr_Sgl', 'pval_Sgl');
% [~, channelNum, filters, freqs] = size(corr_Sgl);
% for  j = 1: channelNum
%     figure1 = figure(j);clf;
%     x = reshape(corr_Sgl(1,j,:,:), filters, freqs);
%     [~,sortP] = sort(mean(x(:, 16:49), 2));
%     x = x(sortP, :);
%     
%     Bx = reshape(pval_Sgl(1,j,:,:), filters, freqs);
%     Bx = Bx(sortP, :);
%     imagesc(Bx');
%     load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps_backGnd.mat','MyColormap');
%     colormap(MyColormap);
%     set(gca, 'Clim', [0,0.1], 'YDir','normal');
%      
%     freezeColors;
%     hold on;
%     h = imagesc(x');
%     load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
%     colormap(MyColormap);
%     set(gca, 'Clim', [-1,1], 'YDir','normal');
%     set(h, 'AlphaData', 0.9);
% end
% 
% 
% %%%%%%%%%%%%%%%%%%%%% Filter-Freq + weights, single class %%%%%%%%%%%%%%%%%%%%%
% WIT_PATH = 'D:/lsj/Modelvari_CNN/Model_Visual_V1_F20_weight_p10.mat';
% load(WIT_PATH, 'weight_spati');
% weight_spati = double(weight_spati);
% for  j = 1: channelNum
%     figure1 = figure(j);clf;
%     x = reshape(corr_Sgl(j,:,:), 512, 49);
%     [~,sortP] = sort(mean(x(:, 16:49), 2));
%     x = x(sortP, :);
%     weight_spati = weight_spati(sortP, :);
%     
%     gca = axes('Parent',figure1,'Position', [ 0.1,0.28, 0.8, 0.7]);
%     hold(gca,'on');
%     imagesc(x');
%     load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
%     colormap(MyColormap);
%     set(gca, 'Clim', [-1,1], 'YDir','normal');
%     axis off;
% %     max(max(x))
% %     min(min(x))
% 
%     gca = axes('Parent',figure1,'Position', [ 0.1,0.03, 0.8, 0.22]);
%     hold(gca,'on');
%     imagesc(weight_spati');
% %     load('H:\lsj\preprocessing_data\refMeths_Result\MyColormaps.mat','MyColormaps');
% %     colormap(MyColormaps); 
% 
% end
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%% Filter-Freq, multi classes %%%%%%%%%%%%%%%%%%%%%%%%%% 
% clear;clc;
% SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_210825.mat';
% load(SAVE_PATH, 'corr_Sgl');
% [classNum, channelNum, filters, freqs] = size(corr_Sgl);
% 
% for  j = 1: channelNum
%     figure(j);
%     
%     for c = 1: classNum   
%         x = reshape(corr_Sgl(c,j,:,:), filters, freqs);
%         [~,sortP] = sort(mean(x(:, 16:49), 2));
%         x = x(sortP, :);
%         
%         subplot(2,3,c);
%         imagesc(x');
%         load('C:\Users\liushengjie\Documents\MATLAB\可视化\MyColormaps.mat','MyColormap');
%         colormap(MyColormap);
%         set(gca, 'Clim', [-1,1], 'YDir','normal');
% %         axis off;
%         %     max(max(x))
%         %     min(min(x))
%     end
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
