



%%
[data.gName]=spm_select(1,'image','select image with ROI');
brain_info=spm_vol(data.gName); [g]=spm_read_vols(brain_info);


%%
[brain_reslice, mat_reslice] = affine(g, brain_info.mat,1,0,[],1); % reslice at 1mm^3 voxels, method 1 is trilinear interpolation
    
%%
brain_info2=brain_info;
%%
brain_info2.mat=mat_reslice;
brain_info2.dim=size(brain_reslice);
brain_info2.fname=[brain_info.fname(1:end-4) '_reslice.nii'];
brain_info2.dt=brain_info.dt;
brain_info2.descrip='';
brain_info2.pinfo=brain_info.pinfo;

    spm_write_vol(brain_info2,brain_reslice); % need to scale into standard ranges
    




