function gen_xs_anat(subject)
% generate anatomy, etc to get electrode positions in cross-sectional anatomy


%protocol:
% 1 - import dcms of mr and ct
% 2 - rotate brain into proper reference using estimate - spm
% 3 - reslice to 1mm voxels using "reorient"
% 4 - reslice ct to reoriented mr using spm "estimate and reslice"
% 5 - use kjm_ctmr to generate volume for electrodes




%% load MRI
    [data.gName]=spm_select(1,'image','select image with MRI');
    brain_info=spm_vol(data.gName); [g]=spm_read_vols(brain_info);

%% load electrodes (output from kjm_ctmr)
    [dt.gName]=spm_select(1,'image','select image with electrodes');
    brain_info2=spm_vol(dt.gName); [els]=spm_read_vols(brain_info2);

%% get appropriate order for indices

locs = kjm_sortElsMat;


    
%% save     

% %% plotting later
%     figure, imagesc(g2(:,:,n(k))), colormap gray
%     hold on, plot(m(k),l(k),'r.')




