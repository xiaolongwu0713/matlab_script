clear;clc;

pn = 10;

SAVE_PATH = 'D:/lsj/Modelvari_CNN/visual_V1_paras_corr_Sgl_p10_210825.mat';
load(SAVE_PATH, 'corr_Sgl');
[~, channelNum, filters, freqs] = size(corr_Sgl);
  
xAbsMean.delta = []; xAbsMean.theta = []; xAbsMean.alpha = []; xAbsMean.highgamma = [];
for  j = 1: channelNum
    x = reshape(corr_Sgl(1,j,:,:), filters, freqs);x = x';
    xAbsMean.delta = [xAbsMean.delta mean(abs(x(1,:)))];
    xAbsMean.theta = [xAbsMean.theta mean(abs(x(2,:)))];
    xAbsMean.alpha = [xAbsMean.alpha mean(abs(x(3,:)))];   
    xAbsMean.highgamma = [xAbsMean.highgamma mean(abs(x(16:49,:)))];  
end

load('C:\Users\liushengjie\Documents\MATLAB\ø… ”ªØ\MyColormaps_viewbrain.mat','MyColormap');

xAbsMean.Mdelta = mapminmax(xAbsMean.delta, 1,64);
xAbsMean.Cdelta = MyColormap(round(xAbsMean.Mdelta),:);
xAbsMean.Mtheta = mapminmax(xAbsMean.theta, 1,64);
xAbsMean.Ctheta = MyColormap(round(xAbsMean.Mtheta),:);
xAbsMean.Malpha = mapminmax(xAbsMean.alpha, 1,64);
xAbsMean.Calpha = MyColormap(round(xAbsMean.Malpha),:);
xAbsMean.Mhighgamma = mapminmax(xAbsMean.highgamma, 1,64);
xAbsMean.Chighgamma = MyColormap(round(xAbsMean.Mhighgamma),:);




% Localization of Electrodes°Ø 3D Coordinates.
%     addpath(genpath([cd,'\nicebrain']));
Electrode_Registration_Folder=strcat('D:\lsj\EleCTX_Files_2018_10_26\P',num2str(pn),'\SignalChanel_Electrode_Registration.mat'); % input electrode file folder here
load(Electrode_Registration_Folder);

Electrode_Folder=strcat('D:\lsj\EleCTX_Files_2018_10_26\P',num2str(pn),'\electrodes_Final_Anatomy_wm_All.mat'); % input electrode file folder here
%     Brain_Model_Folder=strcat('D:\lsj\EleCTX_Files_2018_10_26\P',num2str(pn),'\WholeCortex.mat');% input brain cortex file folder here
load(Electrode_Folder);
%     load(Brain_Model_Folder);
load 'D:\lsj\EleCTX_Files_2018_10_26\Standard Brain\Norm_Brain' cortex

strname = strcat('D:/lsj/preprocessing_data/P',num2str(pn),'/preprocessing1/preprocessingALL_1.mat');
load(strname, 'good_channels');
Etala.trielectrodes=cell2mat(elec_Info_Final_wm.norm_pos');
good_channels = CHN(good_channels);
Etala.trielectrodes_good_channels = Etala.trielectrodes(good_channels,:);
% view_vect = input('What side of the brain do you want to view? ("front"|"top"|"lateral"|"isometric"|"right"|"left"): ');
view_vect = 'top';
% switch t
%     case 1;view_vect = 'left';
%     case 2;view_vect = 'front';
%     case 3;view_vect = 'top';
% end
figure(1);
transp = 0.3;colix = 32;
viewBrain_copy(cortex, Etala, {'brain','trielectrodes'}, transp, colix, view_vect, xAbsMean);
axis off;
colorbar off
