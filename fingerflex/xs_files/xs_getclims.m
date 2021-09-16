function xs_getclims(subject)
% allows for selection of color limits based upon histogram of voxel intensities



    % load mri
    mrStruct=spm_vol([cd '/brains/' subject '/' subject '_mri.nii']); % get the mri 
    mrmat=spm_read_vols(mrStruct); % from structure to data matrix and xyz matrix (voxel coordinates)
    
    voxint=reshape(mrmat,1,[]);
    % histogram to decide clims
    figure,hist(voxint,50)
    % actual limit
title([subject ' voxel intensity histogram'])