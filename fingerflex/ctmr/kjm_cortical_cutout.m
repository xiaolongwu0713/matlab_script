function kjm_cortical_cutout




%% order of operations  - use pt HT for now for illustration

% load normalized - structural mri
% load cortical surface mesh
% normalize brain into ac/pc space
% rotate brain into desired axes for receding
% reslice brain into normalized coordinates - into axes that we want - e.g. like hebb project stuff
% for each level, need
    % 3 plane cuts
    % proper scalp/head cutouts




%%

% load structural mri
[data.gName]=spm_select(1,'image','select image with gray matter');
brain_info=spm_vol(data.gName); [g]=spm_read_vols(brain_info);



% reslice brain into normalized coordinates

%%


colormap gray
[data.gName]=spm_select(1,'image','select image with gray matter');
brain_info=spm_vol(data.gName); [g]=spm_read_vols(brain_info);
figure, imagesc(g(:,:,50))
colorbar
a=g;
isoparm = 400;
ctmr_gauss_plot(cortex,[0 0 0],0)
loc_view(180,0)
sm_par=2;
a=sm_filt(a,sm_par);
figure, imagesc(a(:,:,50))
colorbar
isoparm = 100;
close all
ctmr_gauss_plot(cortex,[0 0 0],0)
loc_view(180,-50)





