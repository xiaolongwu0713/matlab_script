function  [voxind]=mni2vox(locs,subject)
% convert locs discovered from ct (already presumed that CT was normed into mri) into mri voxel indices



%% load MR
mrStruct=spm_vol([cd '/brains/' subject '/' subject '_mri.nii']); % get the mri 

a=ones(size(locs,1),1)*(mrStruct.mat(1:3,4).');
b=(pinv(mrStruct.mat(1:3,1:3))*((locs-a).')).';

voxind=round(b); % x, y, z voxels - all rounded to nearest

% b(1:2,:)=round(b(1:2,:)); % x and y voxels - round to nearest
% b(3,:)=round(b(3,:)); % z voxels - round up, so tentorial ones in gyri








